//
//  MpdPlaylistItem.h
//  reMPD
//
//  Created by Jurica Bacurin on 22.04.11.
//

#import <Foundation/Foundation.h>


@interface MpdPlaylistItem : NSObject {
    NSString *file;
    NSString *time;
    NSString *artist;
    NSString *albumArtist;
    NSString *title;
    NSString *album;
    NSString *track;
    NSString *date;
    NSString *genre;
    NSString *composer;
    NSString *pos;
    NSNumber *mpdid;
}

@property (nonatomic, strong) NSString *file;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *albumArtist;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *album;
@property (nonatomic, strong) NSString *track;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *genre;
@property (nonatomic, strong) NSString *composer;
@property (nonatomic, strong) NSString *pos;
@property (nonatomic ,strong) NSNumber *mpdid;

//- (void)setFile:(NSString *)value;
- (void)setTag:(NSString *)tag;

@end
