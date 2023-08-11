//
//  MpdProxy.h
//  reMPD
//
//  Created by Jurica Bacurin on 17.04.11.
//

#import <Foundation/Foundation.h>

@class GCDAsyncSocket;
@class MpdStatus;
@class MpdPlaylist;
@class MpdPlaylistItem;
@class MpdStats;

@protocol MpdProxyDelegate <NSObject>
@optional
	- (void)onDisconnectWithError: (NSError *)error;
	- (void)onConnectionError: (NSError *)error;
	- (void)onConnect;
//	- (void)onChangeDatabase; -> updateStats
//	- (void)onChangeUpdate;
	- (void)onChangeStoredPlaylist: (NSArray *)playlists;
	- (void)onRetreivedStoredPlaylist: (NSArray *)playlist;
	- (void)onChangePlaylist;
//	- (void)onChangePlayer: (MpdStatus*)status;
//	- (void)onChangeMixer: (MpdStatus*)status;
//	- (void)onChangeOutput;
//	- (void)onChangeSticker;
//	- (void)onChangeSubscription;
//	- (void)onChangeMessage;
	- (void)onChangeStatus;
	- (void)onRetreivedAllTitles: (NSArray *)titles;
	- (void)onRetreivedAllArtists: (NSArray *)artists;
	- (void)onRetreivedAlbums: (NSArray *)albums;
	- (void)onRetreivedAlbumTitles: (NSArray *)titles;
	- (BOOL)shouldShowHud;
	- (void)showHud;
	- (void)hideHud;
@end

@interface MpdProxy : NSObject {
}

@property (nonatomic, weak) IBOutlet id <MpdProxyDelegate> delegate;
@property (nonatomic, strong) GCDAsyncSocket *executer;
@property (nonatomic, strong) GCDAsyncSocket *poller;
@property (nonatomic) NSUInteger reconnectErrorCounter;
@property (nonatomic, strong) NSString *host;
@property (nonatomic) NSUInteger port;
@property (nonatomic, strong) MpdStatus *status;
@property (nonatomic, strong) NSArray *playlist;
@property (nonatomic, strong) MpdStats *stats;
@property (nonatomic) BOOL delegateOnConnectCalled;

+ (id)instance;

- (void)connect;
- (void)disconnect;
//- (void)execute:(NSString *)command withTag:(long)tag;
- (BOOL)isConnected;
- (MpdPlaylistItem *)getCurrentSong;
- (MpdPlaylistItem *)getNextSong;

- (void)playpause;
- (void)toggleRandom;
- (void)previous;
- (void)next;
- (void)setVolume:(int)volume;
- (void)play:(MpdPlaylistItem *)item;
- (void)getPlaylists;
- (void)getPlaylist:(NSString *)playlistName;
- (void)getAllTitles;
- (void)addToPlaylist:(MpdPlaylistItem *)item startPlaying:(BOOL)play;
- (void)addToPlaylist:(MpdPlaylistItem *)item atPos:(NSUInteger)pos;
- (void)addAsNextToPlaylist:(MpdPlaylistItem *)item startPlaying:(BOOL)play;
- (void)clearCurrentPlaylist;
- (void)swap:(NSUInteger)from posTo:(NSInteger)to;
- (void)removeFromCurrentPlaylist:(MpdPlaylistItem *)item;
- (void)searchDatabase:(NSString *)type searchString:(NSString *)what;
- (void)loadPlaylist:(NSString *)playlistName;
- (void)savePlaylist:(NSString *)playlistName;
- (void)deletePlaylist:(NSString *)playlistName;
- (void)addAll;
- (void)getAllArtists;
- (void)searchArtist:(NSString *)artistName;
- (void)getArtistAlbums:(NSString *)artistName;
- (void)findAlbum:(NSString *)albumName;
- (void)searchAlbum:(NSString *)albumName;
- (void)getAllAlbums;

@end
