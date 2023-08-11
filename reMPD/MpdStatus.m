//
//  MpdStatus.m
//  reMPD
//
//  Created by Jurica Bacurin on 27.04.11.
//

#import "MpdStatus.h"


@implementation MpdStatus

@synthesize volume;
@synthesize repeat;
@synthesize random;
@synthesize sinlge;
@synthesize consume;
@synthesize playlist;
@synthesize playlistlength;
@synthesize xfade;
@synthesize mixrampdb;
@synthesize mixrampdelay;
@synthesize state;
@synthesize song;
@synthesize songid;
@synthesize time;
@synthesize bitrate;
@synthesize nextsong;
@synthesize elapsed;
@synthesize audio;

+ (MpdStatus *)instance {
	static dispatch_once_t pred;
	static MpdStatus *globalStatus = nil;
	dispatch_once(&pred, ^{
		globalStatus = [[super allocWithZone:NULL] init];
	});
	
	return globalStatus;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self instance];
}

- (id)copyWithZone:(NSZone *)zome {
    return self;
}

- (id)init {
    if (self == [super init]) {
		[self statusFromResponse:@""];
    }
	return self;
}

- (void)reset {
	self.mixrampdb = nil;
	self.mixrampdelay = nil;
	self.nextsong = nil;
	self.playlist = nil;
	self.playlistlength = nil;
	self.random = nil;
	self.repeat = nil;
	self.sinlge = nil;
	self.song = nil;
	self.songid = nil;
	self.state = nil;
	self.time = nil;
	self.volume = nil;
	self.xfade = nil;
	self.consume = nil;
	self.elapsed = nil;
	self.bitrate = nil;
	self.audio = nil;
}

- (void)statusFromResponse:(NSString *)response {
	[self reset];
	NSArray *responseLines = [response componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	for (NSString *responseLine in responseLines) {
		[self setStatus:responseLine];
	}
}

- (void)setStatus:(NSString *)status {
    if ([status hasPrefix:@"volume: "]) {
		int vol = [[status stringByReplacingOccurrencesOfString:@"volume: " withString:@""] intValue];
		if (vol < 0) {
			vol = 0;
		}
        self.volume = vol;
    } else if ([status hasPrefix:@"repeat: "]) {
        self.repeat = [[status stringByReplacingOccurrencesOfString:@"repeat: " withString:@""] intValue];
    } else if ([status hasPrefix:@"random: "]) {
        self.random = [[status stringByReplacingOccurrencesOfString:@"random: " withString:@""] intValue];
    } else if ([status hasPrefix:@"single: "]) {
        self.sinlge = [[status stringByReplacingOccurrencesOfString:@"single: " withString:@""] intValue];
    } else if ([status hasPrefix:@"consume: "]) {
        self.consume = [[status stringByReplacingOccurrencesOfString:@"consume: " withString:@""] intValue];
    } else if ([status hasPrefix:@"playlist: "]) {
        self.playlist = [[status stringByReplacingOccurrencesOfString:@"playlist: " withString:@""] intValue];
    } else if ([status hasPrefix:@"playlistlength: "]) {
        self.playlistlength = [[status stringByReplacingOccurrencesOfString:@"playlistlength: " withString:@""] intValue];
    } else if ([status hasPrefix:@"xfade: "]) {
        self.xfade = [[status stringByReplacingOccurrencesOfString:@"xfade: " withString:@""] intValue];
    } else if ([status hasPrefix:@"state: "]) {
        self.state = [status stringByReplacingOccurrencesOfString:@"state: " withString:@""];
    } else if ([status hasPrefix:@"song: "]) {
        self.song = [[status stringByReplacingOccurrencesOfString:@"song: " withString:@""] intValue];
    } else if ([status hasPrefix:@"songid: "]) {
        self.songid = [NSNumber numberWithInt:[[status stringByReplacingOccurrencesOfString:@"songid: " withString:@""] intValue]];
    } else if ([status hasPrefix:@"time: "]) {
        self.time = [[[status stringByReplacingOccurrencesOfString:@"time: " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
    } else if ([status hasPrefix:@"bitrate: "]) {
        self.bitrate = [[status stringByReplacingOccurrencesOfString:@"bitrate: " withString:@""] intValue];
    } else if ([status hasPrefix:@"nextsong: "]) {
        self.nextsong = [[status stringByReplacingOccurrencesOfString:@"nextsong: " withString:@""] intValue];
    }
}

@end
