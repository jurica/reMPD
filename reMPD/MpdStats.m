//
//  MpdStats.m
//  reMPD
//
//  Created by Jurica Bacurin on 08.01.13.
//

#import "MpdStats.h"

@implementation MpdStats

@synthesize albums;
@synthesize artists;
@synthesize dbPlaytime;
@synthesize dbUpdate;
@synthesize playtime;
@synthesize songs;
@synthesize uptime;

+ (MpdStats *)instance {
	static dispatch_once_t pred;
	static MpdStats *globalStatus = nil;
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
		[self statsFromResponse:@""];
    }
	return self;
}

- (void)statsFromResponse:(NSString *)response {
	NSArray *responseLines = [response componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	for (NSString *responseLine in responseLines) {
		[self setStat:responseLine];
	}
}

- (void)setStat:(NSString *)statLine{
	if ([statLine hasPrefix:@"artists: "]) {
		int val = [[statLine stringByReplacingOccurrencesOfString:@"artists: " withString:@""] intValue];
		artists = val;
    } else if ([statLine hasPrefix:@"albums: "]) {
		int val = [[statLine stringByReplacingOccurrencesOfString:@"albums: " withString:@""] intValue];
		albums = val;
    } else if ([statLine hasPrefix:@"songs: "]) {
		int val = [[statLine stringByReplacingOccurrencesOfString:@"songs: " withString:@""] intValue];
		songs = val;
    } else if ([statLine hasPrefix:@"uptime: "]) {
		int val = [[statLine stringByReplacingOccurrencesOfString:@"uptime: " withString:@""] intValue];
		uptime = val;
    } else if ([statLine hasPrefix:@"playtime: "]) {
		int val = [[statLine stringByReplacingOccurrencesOfString:@"playtime: " withString:@""] intValue];
		playtime = val;
    } else if ([statLine hasPrefix:@"db_playtime: "]) {
		int val = [[statLine stringByReplacingOccurrencesOfString:@"db_playtime: " withString:@""] intValue];
		dbPlaytime = val;
    } else if ([statLine hasPrefix:@"db_update: "]) {
		int val = [[statLine stringByReplacingOccurrencesOfString:@"db_update: " withString:@""] intValue];
		dbUpdate = val;
    }
}

- (NSDictionary *)toDictionary {
	NSMutableDictionary *retvar = [[NSMutableDictionary alloc] initWithCapacity:7];
	
	[retvar setObject:[NSString stringWithFormat:@"%i", self.artists] forKey:@"Artists"];
	[retvar setObject:[NSString stringWithFormat:@"%i", self.albums] forKey:@"Albums"];
	[retvar setObject:[NSString stringWithFormat:@"%i", self.songs] forKey:@"Songs"];
	[retvar setObject:[NSString stringWithFormat:@"%i", self.uptime] forKey:@"Uptime"];
	[retvar setObject:[NSString stringWithFormat:@"%i", self.playtime] forKey:@"Played"];
	[retvar setObject:[NSString stringWithFormat:@"%i", self.dbPlaytime] forKey:@"Playtime"];
	[retvar setObject:[NSString stringWithFormat:@"%i", self.dbUpdate] forKey:@"Updated"];
	
	return retvar;
}

@end
