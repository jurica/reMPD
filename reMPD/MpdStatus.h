//
//  MpdStatus.h
//  reMPD
//
//  Created by Jurica Bacurin on 27.04.11.
//

#import <Foundation/Foundation.h>


@interface MpdStatus : NSObject {
    NSUInteger volume;
    NSUInteger repeat;
    NSUInteger random;
    NSUInteger sinlge;
    NSUInteger consume;
    NSUInteger playlist;
    NSUInteger playlistlength;
    NSUInteger xfade;
	NSNumber *mixrampdb;
	NSString *mixrampdelay;
    NSString *state;
    NSUInteger song;
    NSNumber *songid;
    NSUInteger time;
	NSNumber *elapsed;
    NSUInteger bitrate;
	NSString *audio;
	NSUInteger nextsong;
	NSUInteger nextsongid;
}

+ (id)instance;

- (void)statusFromResponse:(NSString *)status;

@property (nonatomic) NSUInteger volume;
@property (nonatomic) NSUInteger repeat;
@property (nonatomic) NSUInteger random;
@property (nonatomic) NSUInteger sinlge;
@property (nonatomic) NSUInteger consume;
@property (nonatomic) NSUInteger playlist;
@property (nonatomic) NSUInteger playlistlength;
@property (nonatomic) NSUInteger xfade;
@property (nonatomic, strong) 	NSNumber *mixrampdb;
@property (nonatomic,strong) NSString *mixrampdelay;
@property (nonatomic,strong) NSString *state;
@property (nonatomic) NSUInteger song;
@property (nonatomic, strong) NSNumber *songid;
@property (nonatomic) NSUInteger time;
@property (nonatomic) NSUInteger bitrate;
@property (nonatomic) NSUInteger nextsong;
@property (nonatomic, strong) 	NSNumber *elapsed;
@property (nonatomic,strong) NSString *audio;

@end
