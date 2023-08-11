//
//  MpdStats.h
//  reMPD
//
//  Created by Jurica Bacurin on 08.01.13.
//

#import <Foundation/Foundation.h>

@interface MpdStats : NSObject

@property (nonatomic) NSUInteger artists;
@property (nonatomic) NSUInteger albums;
@property (nonatomic) NSUInteger songs;
@property (nonatomic) NSUInteger uptime;
@property (nonatomic) NSUInteger playtime;
@property (nonatomic) NSUInteger dbPlaytime;
@property (nonatomic) NSUInteger dbUpdate;

+ (id)instance;

- (void)statsFromResponse:(NSString *)response;
- (NSDictionary *)toDictionary;

@end
