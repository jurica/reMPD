//
//  MpdPlaylist.h
//  reMPD
//
//  Created by Bacurin Jurica on 25.07.11.
//

@class MpdPlaylistItem;

@interface MpdPlaylist : NSObject {
}

@property (strong, nonatomic) NSDictionary *items;
@property (strong, nonatomic) NSArray *index;

- (id)initWithMpdResponse:(NSString *)playlistResponse;
- (MpdPlaylistItem *)itemForId:(NSNumber *)songId;

@end
