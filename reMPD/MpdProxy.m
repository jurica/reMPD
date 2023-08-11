//
//  MpdProxy.m
//  reMPD
//
//  Created by Jurica Bacurin on 17.04.11.
//

#import "MpdProxy.h"
#import "GCDAsyncSocket.h"
#import "MpdPlaylistItem.h"
#import "MpdStatus.h"
#import "SortAndGroupPlaylist.h"
#import "MpdStats.h"
#import <objc/message.h>


#define TAG_STATS 9
#define TAG_WELCOME 10
#define TAG_IDLE 11
#define TAG_STATUS 12
#define TAG_COMMAND 13
#define TAG_CURRENTPLAYLIST 14
#define TAG_LISTPLAYLISTS 15
#define TAG_LISTPLAYLISTINFO 16
#define TAG_LISTARTISTS 19
#define TAG_LISTALLINFO 17
#define TAG_LISTALBUMS 20
#define TAG_FINDALBUM 21

#define NUMRECONNECTTRIES 1
#define RECONNECTINTERVAL 500000

//static MpdProxy *globalProxy = nil;

@implementation MpdProxy

@synthesize executer;
@synthesize poller;
@synthesize reconnectErrorCounter;
@synthesize delegate;
@synthesize host;
@synthesize port;
@synthesize status;
@synthesize playlist;
@synthesize stats;
@synthesize delegateOnConnectCalled;

+ (MpdProxy *)instance {
	static dispatch_once_t pred;
	static MpdProxy *globalProxy = nil;
	dispatch_once(&pred, ^{
		globalProxy = [[super allocWithZone:NULL] init];
	});
	
	return globalProxy;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self instance];
}

- (id)copyWithZone:(NSZone *)zome {
    return self;
}

- (id)init {
    if (self == [super init]) {
		self.executer = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
		self.poller = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
		reconnectErrorCounter = 0;
		status = [MpdStatus instance];
		playlist = nil;
		stats = [MpdStats instance];
		delegateOnConnectCalled = NO;
    }
        return self;
}

- (void)disconnect {
	//NSLog(@"disconnecting sockets");
	[poller disconnect];
	[executer disconnect];
	reconnectErrorCounter = 0;
}

- (BOOL)isConnected {
//	if (poller.isConnected == YES && executer.isConnected == YES) {
//		return YES;
//	} else {
//		return NO;
//	}
	return poller.isConnected && executer.isConnected;
}

- (void)execute:(NSString *)command withTag:(long)tag{
//	NSLog(@"command: %@", command);
	if (![self isConnected]) {
//		NSLog(@"can't do anything, i'm not connected!");
		return;
	}
	if (tag > TAG_COMMAND) {
		[self showHud];
	}
    NSData *data = [command dataUsingEncoding:NSUTF8StringEncoding];
    [executer writeData:data withTimeout:-1.0 tag:tag];
}

- (void)idle {
	NSData *data = [@"idle\r\n" dataUsingEncoding:NSUTF8StringEncoding];
	[poller writeData:data withTimeout:-1.0 tag:TAG_IDLE];
}

- (void)updateStatus {
	[self execute:@"status\r\n" withTag:TAG_STATUS];
}

- (void)updateStats {
	[self execute:@"stats\r\n" withTag:TAG_STATS];
}

- (void)updateCurrentPlaylist {
	[self execute:@"playlistinfo\r\n" withTag:TAG_CURRENTPLAYLIST];
}

- (void)playpause {
	if ([[[self status] state] rangeOfString:@"stop"].location != NSNotFound) {
		[self execute:@"play\r\n" withTag:TAG_COMMAND];
	} else {
		[self execute:@"pause\r\n" withTag:TAG_COMMAND];
	}
}

- (void)toggleRandom {
	if ([[self status] random] == 1) {
		[self execute:@"random 0\r\n" withTag:TAG_COMMAND];
	} else if ([[self status] random] == 0) {
		[self execute:@"random 1\r\n" withTag:TAG_COMMAND];
	}
}

- (void)next {
	[self execute:@"next\r\n" withTag:TAG_COMMAND];
}

- (void)previous {
	[self execute:@"previous\r\n" withTag:TAG_COMMAND];
}

- (void)setVolume:(int)volume {
	if (volume < 0) {
		volume = 0;
	} else if (volume > 100) {
		volume = 100;
	}
	NSString *command = [NSString stringWithFormat:@"setvol %i\r\n", volume];
	[self execute:command withTag:TAG_COMMAND];
}

- (void)play:(MpdPlaylistItem *)item {
	NSString *command = [NSString stringWithFormat:@"play %@\r\n", [item pos]];
	[self execute:command withTag:TAG_COMMAND];

}

- (MpdPlaylistItem *)getCurrentSong {
	@try {
		return [playlist objectAtIndex:[status song]];
	}
	@catch (NSException *exception) {
		return nil;
	}
}

- (MpdPlaylistItem *)getNextSong {
	@try {
		return [playlist objectAtIndex:[status nextsong]];
	}
	@catch (NSException *exception) {
		return nil;
	}
}

- (void)getPlaylists {
	[self execute:@"listplaylists\r\n" withTag:TAG_LISTPLAYLISTS];
}

- (void)getPlaylist:(NSString *)playlistName {
	NSString *command = [NSString stringWithFormat:@"listplaylistinfo \"%@\"\r\n", playlistName];
	[self execute:command withTag:TAG_LISTPLAYLISTINFO];
}

- (void)getAllTitles {
	[self execute:@"listallinfo\r\n" withTag:TAG_LISTALLINFO];
}

- (void)addToPlaylist:(MpdPlaylistItem *)item startPlaying:(BOOL)play{
	NSString *command = [NSString stringWithFormat:@"addid \"%@\"\r\n", item.file];
	[self execute:command withTag:TAG_COMMAND];
	
	if (play) {
		[self playpause];
	}
}

- (void)addToPlaylist:(MpdPlaylistItem *)item atPos:(NSUInteger)pos {
	NSString *command = [NSString stringWithFormat:@"addid \"%@\" %i\r\n", item.file, pos];
	[self execute:command withTag:TAG_COMMAND];
}

- (void)addAll {
	[self execute:@"add \"/\"\r\n" withTag:TAG_COMMAND];
}

- (void)addAsNextToPlaylist:(MpdPlaylistItem *)item startPlaying:(BOOL)play{
	NSString *command = [NSString stringWithFormat:@"addid \"%@\" %i\r\n", item.file, status.nextsong];
	[self execute:command withTag:TAG_COMMAND];
		
	if (play) {
		[self next];
	}
}

- (void)clearCurrentPlaylist {
	[self execute:@"clear\r\n" withTag:TAG_COMMAND];
}

- (void)swap:(NSUInteger)from posTo:(NSInteger)to {
	if (from < to) {
		to++;
	}
	NSString *command = [NSString stringWithFormat:@"swap %i %i\r\n", from, to];
	[self execute:command withTag:TAG_COMMAND];
}
- (void)removeFromCurrentPlaylist:(MpdPlaylistItem *)item {
	NSString *command = [NSString stringWithFormat:@"delete %@\r\n", item.pos];
	[self execute:command withTag:TAG_COMMAND];
}

- (void)searchDatabase:(NSString *)type searchString:(NSString *)what {
	NSString *command = [NSString stringWithFormat:@"search %@ \"%@\"\r\n", type, what];
	[self execute:command withTag:TAG_LISTALLINFO];
}

- (void)loadPlaylist:(NSString *)playlistName {
	NSString *command = [NSString stringWithFormat:@"load \"%@\"\r\n", playlistName];
	[self execute:command withTag:TAG_CURRENTPLAYLIST];
	
}

- (void)savePlaylist:(NSString *)playlistName {
	if (playlistName.length == 0) {
		return;
	}
	
	NSString *command = [NSString stringWithFormat:@"save \"%@\"\r\n", playlistName];
	[self execute:command withTag:TAG_COMMAND];
	
}

- (void)deletePlaylist:(NSString *)playlistName {
	NSString *command = [NSString stringWithFormat:@"rm \"%@\"\r\n", playlistName];
	[self execute:command withTag:TAG_COMMAND];
	
}

- (void)getAllArtists {
	[self execute:@"list artist\r\n" withTag:TAG_LISTARTISTS];
}

- (void)getArtistAlbums:(NSString *)artistName {
	NSString *command = [NSString stringWithFormat:@"list album \"%@\"\r\n", artistName];
	[self execute:command withTag:TAG_LISTALBUMS];
}

- (void)findAlbum:(NSString *)albumName {
	NSString *command = [NSString stringWithFormat:@"find album \"%@\"\r\n", albumName];
	[self execute:command withTag:TAG_FINDALBUM];
}

- (void)getAllAlbums {
	[self execute:@"list album\r\n" withTag:TAG_LISTALBUMS];
}

- (void)searchAlbum:(NSString *)albumName {}

- (void)searchArtist:(NSString *)artistName {
	NSString *command = [NSString stringWithFormat:@"search artist \"%@\"\r\n", artistName];
	[self execute:command withTag:TAG_LISTARTISTS];
}

- (void)showHud {
	if ([delegate respondsToSelector:@selector(shouldShowHud)] && [delegate shouldShowHud]) {
		[delegate showHud];
	}
}

- (void)hideHud {
	if ([delegate respondsToSelector:@selector(shouldShowHud)] && [delegate shouldShowHud]) {
		[delegate hideHud];
	}
}

#pragma mark delegate methods

- (void)socket:(GCDAsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag {
	NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		
	if (tag == TAG_WELCOME) {
		if (sender == poller) {
			[self idle];
		}
		if (sender == executer) {
			[self updateStatus];
			[self updateStats];
			[self updateCurrentPlaylist];
		}
		return;
	}
	
	if (tag == TAG_IDLE) {
		if ([response rangeOfString:@"changed: mixer"].location != NSNotFound ||
			[response rangeOfString:@"changed: player"].location != NSNotFound ||
			[response rangeOfString:@"changed: options"].location != NSNotFound) {
				[self updateStatus];
		}
		if ([response rangeOfString:@"changed: playlist"].location != NSNotFound) {
			[self updateStatus];
			[self updateCurrentPlaylist];
		}
		if ([response rangeOfString:@"changed: stored_playlist"].location != NSNotFound) {
			[self getPlaylists];
		}
		// TODO: delegate call methods for all change events
		[self idle];
	}
	
	if (tag == TAG_STATUS) {
		[status statusFromResponse:response];
		if ([delegate respondsToSelector:@selector(onChangeStatus)]) {
			[delegate onChangeStatus];
		}
	}
	
	if (tag == TAG_STATS) {
		[stats statsFromResponse:response];
//		TODO
//		if ([delegate respondsToSelector:@selector(onChangeStatus)]) {
//			[delegate onChangeStatus];
//		}
	}
	
	if (tag == TAG_CURRENTPLAYLIST) {
		NSMutableArray *retvar = [[NSMutableArray alloc] init];
		
		NSArray *responseLines = [response componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		NSInteger num = 0;
		for (NSString *responseLine in responseLines) {
			if ([responseLine hasPrefix:@"file: "]) {
				MpdPlaylistItem *item = [MpdPlaylistItem alloc];
				[item setTag:responseLine];
				NSInteger n = 1;
				while (!(num+n == [responseLines count]) && ![[responseLines objectAtIndex:num+n] hasPrefix:@"file: "]) {
					[item setTag:[responseLines objectAtIndex:num+n]];
					n++;
				}
				[retvar addObject:item];
			}
			num++;
		}
		
		self.playlist = retvar;
//		[self setPlaylist:[[MpdPlaylist alloc] initWithMpdResponse:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]];
		if ([delegate respondsToSelector:@selector(onChangePlaylist)]) {
			[delegate onChangePlaylist];
		}
		[self updateStatus];
		[self hideHud];
	}
	
	if (tag == TAG_LISTPLAYLISTS) {
		NSMutableArray *playlists = [[NSMutableArray alloc] init];
		NSArray *responseLines = [response componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		for (NSString *responseLine in responseLines) {
			if ([responseLine hasPrefix:@"playlist: "]) {
				[playlists addObject:[responseLine stringByReplacingOccurrencesOfString:@"playlist: " withString:@""]];
			}
		}
		
		if ([delegate respondsToSelector:@selector(onChangeStoredPlaylist:)]) {
			[delegate onChangeStoredPlaylist:playlists];
		}
		[self hideHud];
	}
	
	if (tag == TAG_LISTPLAYLISTINFO) {
		NSMutableArray *retvar = [[NSMutableArray alloc] init];
		
		NSArray *responseLines = [response componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		NSInteger num = 0;
		for (NSString *responseLine in responseLines) {
			if ([responseLine hasPrefix:@"file: "]) {
				MpdPlaylistItem *item = [MpdPlaylistItem alloc];
				[item setTag:responseLine];
				NSInteger n = 1;
				while (!(num+n == [responseLines count]) && ![[responseLines objectAtIndex:num+n] hasPrefix:@"file: "]) {
					[item setTag:[responseLines objectAtIndex:num+n]];
					n++;
				}
				[retvar addObject:item];
			}
			num++;
		}
		
		if ([delegate respondsToSelector:@selector(onRetreivedStoredPlaylist:)]) {
			[delegate onRetreivedStoredPlaylist:retvar];
		}
		[self hideHud];
	}
	
	if (tag == TAG_LISTALLINFO) {
		NSMutableArray *retvar = [[NSMutableArray alloc] init];
		
		NSArray *responseLines = [response componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		NSInteger num = 0;
		for (NSString *responseLine in responseLines) {
			if ([responseLine hasPrefix:@"file: "]) {
				MpdPlaylistItem *item = [MpdPlaylistItem alloc];
				[item setTag:responseLine];
				NSInteger n = 1;
				while (!(num+n == [responseLines count]) && ![[responseLines objectAtIndex:num+n] hasPrefix:@"file: "]) {
					[item setTag:[responseLines objectAtIndex:num+n]];
					n++;
				}
				[retvar addObject:item];
			}
			num++;
		}
		
		if ([delegate respondsToSelector:@selector(onRetreivedAllTitles:)]) {
			[delegate onRetreivedAllTitles:retvar];
		}
		[self hideHud];
	}
	
	if (tag == TAG_LISTARTISTS) {
		NSArray *responseLines = [response componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		
		NSMutableArray *artists = [[NSMutableArray alloc] initWithCapacity:responseLines.count];
		
		for (NSString *responseLine in responseLines) {
			if ([responseLine hasPrefix:@"Artist: "]) {
				NSString *artist = [responseLine stringByReplacingOccurrencesOfString:@"Artist: " withString:@""];
				[artists addObject:artist];	
//				if (artist.length == 0) {
//					[artists addObject:@"<unknown>"];
//				} else {
//					[artists addObject:artist];
//					NSLog(@"\"%@\"", artist);
//				}
			}
		}
		
		[artists sortUsingComparator:^(NSString *artist1, NSString *artist2){
			return [artist1 compare:artist2 options:NSCaseInsensitiveSearch];
		}];
		
		if ([delegate respondsToSelector:@selector(onRetreivedAllArtists:)]) {
			[delegate onRetreivedAllArtists:artists];
		}
		[self hideHud];
	}
	
	if (tag == TAG_LISTALBUMS) {
		NSArray *responseLines = [response componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		
		NSMutableArray *albums = [[NSMutableArray alloc] initWithCapacity:responseLines.count];
		
		for (NSString *responseLine in responseLines) {
			if ([responseLine hasPrefix:@"Album: "]) {
				NSString *artist = [responseLine stringByReplacingOccurrencesOfString:@"Album: " withString:@""];
				[albums addObject:artist];
			}
		}
		
		[albums sortUsingComparator:^(NSString *album1, NSString *album2){
			return [album1 compare:album2 options:NSCaseInsensitiveSearch];
		}];
		
		if ([delegate respondsToSelector:@selector(onRetreivedAlbums:)]) {
			[delegate onRetreivedAlbums:albums];
		}
		[self hideHud];
	}
	
	if (tag == TAG_FINDALBUM) {
		NSMutableArray *retvar = [[NSMutableArray alloc] init];
		
		NSArray *responseLines = [response componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		NSInteger num = 0;
		for (NSString *responseLine in responseLines) {
			if ([responseLine hasPrefix:@"file: "]) {
				MpdPlaylistItem *item = [MpdPlaylistItem alloc];
				[item setTag:responseLine];
				NSInteger n = 1;
				while (!(num+n == [responseLines count]) && ![[responseLines objectAtIndex:num+n] hasPrefix:@"file: "]) {
					[item setTag:[responseLines objectAtIndex:num+n]];
					n++;
				}
				[retvar addObject:item];
			}
			num++;
		}
		
		if ([delegate respondsToSelector:@selector(onRetreivedAlbumTitles:)]) {
			[delegate onRetreivedAlbumTitles:retvar];
		}
		[self hideHud];
	}
	
	//NSLog(response);
}

- (void)connect{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	host = [defaults objectForKey:@"Server"];
	if ([defaults objectForKey:@"Port"] != nil) {
		port = [[defaults objectForKey:@"Port"] integerValue];
	} else {
		port = 6600;
	}
	
	BOOL connectionError = false;
	NSError *err = nil;
	if (executer.isConnected == NO) {
		[self showHud];
//		NSLog(@"try to connect executer");
		if (![executer connectToHost:host onPort:port withTimeout:2 error:&err]) {
			if ([delegate respondsToSelector:@selector(onConnectionError:)]) {
				connectionError = true;
			}
		}
	}
	
	if (poller.isConnected == NO) {
		[self showHud];
//		NSLog(@"try to connect poller");
		if (![poller connectToHost:host onPort:port withTimeout:2 error:&err]) {
			if ([delegate respondsToSelector:@selector(onConnectionError:)]) {
				connectionError = true;
			}
		}
	}
	
	if (connectionError) {
		[delegate onConnectionError:err];
	}
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
	// read mpds response after connection
	NSData *data = [@"OK" dataUsingEncoding:NSUTF8StringEncoding];
	[sock readDataToData:data withTimeout:-1.0 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port {
	[self hideHud];
	
	if (delegateOnConnectCalled == NO && [self isConnected] && [delegate respondsToSelector:@selector(onConnect)]) {
		[delegate onConnect];
		delegateOnConnectCalled = YES;
	}
	//read the welcome message after connetion
	[sender readDataToData:[GCDAsyncSocket LFData] withTimeout:-1.0 tag:TAG_WELCOME];
	reconnectErrorCounter = 0;
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sender withError:(NSError *)err {
	[self hideHud];
	
	if (err == nil) {
		// do nothing, disconnected on purpose!
		return;
	}
	reconnectErrorCounter++;
//	NSLog(@"reconnectErrorCounter: %i", reconnectErrorCounter);
	if (![self isConnected] && reconnectErrorCounter == NUMRECONNECTTRIES) {
		if ([delegate respondsToSelector:@selector(onDisconnectWithError:)]) {
			[delegate onDisconnectWithError:err];
			delegateOnConnectCalled = NO;
			[poller disconnect];
			[executer disconnect];
		}
	}
	if (reconnectErrorCounter <= NUMRECONNECTTRIES) {
//		NSLog(@"will try to reconnect, %i. retry", reconnectErrorCounter);
//		dispatch_async(dispatch_get_main_queue(), ^{
//			usleep(RECONNECTINTERVAL);
//			[self connect];
//		});
		usleep(RECONNECTINTERVAL);
		[self connect];
	}
}

@end
