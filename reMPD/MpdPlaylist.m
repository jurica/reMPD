//
//  MpdPlaylist.m
//  reMPD
//
//  Created by Bacurin Jurica on 25.07.11.
//

#import "MpdPlaylist.h"
#import "MpdPlaylistItem.h"

@implementation MpdPlaylist

@synthesize items;
@synthesize index;

- (id)initWithMpdResponse:(NSString *)playlistResponse {
	NSMutableArray *tmpIndex = [[NSMutableArray alloc] init];
	NSMutableDictionary *tmpItems = [[NSMutableDictionary alloc] init];
	
    NSArray *responseLines = [playlistResponse componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
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
			[tmpItems setObject:item forKey:[item mpdid]];
			[tmpIndex addObject:[item mpdid]];
        }
        num++;
    }
	
	items = tmpItems;
	index = tmpIndex;
	
	return self;
}

- (MpdPlaylistItem *)itemForId:(NSNumber *)songId {
	return [items objectForKey:songId];
}

@end
