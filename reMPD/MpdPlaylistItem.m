//
//  MpdPlaylistItem.m
//  reMPD
//
//  Created by Jurica Bacurin on 22.04.11.
//

#import "MpdPlaylistItem.h"


@implementation MpdPlaylistItem

//- (void)setFile:(NSString *)value {
//    NSLog(@"custom setter");
//    NSString *tmp = [value stringByReplacingOccurrencesOfString:@"file: " withString:@""];
//    self.file = tmp;
//}

@synthesize file;
@synthesize time;
@synthesize artist;
@synthesize albumArtist;
@synthesize title;
@synthesize album;
@synthesize track;
@synthesize date;
@synthesize genre;
@synthesize composer;
@synthesize pos;
@synthesize mpdid;

- (void)setTag:(NSString *)tag {
    if ([tag hasPrefix:@"file: "]) {
        self.file = [tag stringByReplacingOccurrencesOfString:@"file: " withString:@""];
        return;
    } else if ([tag hasPrefix:@"Time: "]) {
        self.time = [tag stringByReplacingOccurrencesOfString:@"Time: " withString:@""];
        return;
    } else if ([tag hasPrefix:@"Artist: "]) {
        self.artist = [tag stringByReplacingOccurrencesOfString:@"Artist: " withString:@""];
        return;
    }else if ([tag hasPrefix:@"AlbumArtist: "]) {
        self.albumArtist = [tag stringByReplacingOccurrencesOfString:@"AlbumArtist: " withString:@""];
        return;
    } else if ([tag hasPrefix:@"Title: "]) {
        self.title = [tag stringByReplacingOccurrencesOfString:@"Title: " withString:@""];
        return;
    } else if ([tag hasPrefix:@"Album: "]) {
        self.album = [tag stringByReplacingOccurrencesOfString:@"Album: " withString:@""];
        return;
    } else if ([tag hasPrefix:@"Track: "]) {
        self.track = [tag stringByReplacingOccurrencesOfString:@"Track: " withString:@""];
        return;
    } else if ([tag hasPrefix:@"Date: "]) {
        self.date = [tag stringByReplacingOccurrencesOfString:@"Date: " withString:@""];
        return;
    } else if ([tag hasPrefix:@"Genre: "]) {
        self.genre = [tag stringByReplacingOccurrencesOfString:@"Genre: " withString:@""];
        return;
    } else if ([tag hasPrefix:@"Pos: "]) {
        self.pos = [tag stringByReplacingOccurrencesOfString:@"Pos: " withString:@""];
        return;
    } else if ([tag hasPrefix:@"Id: "]) {
        self.mpdid = [NSNumber numberWithInt:[[tag stringByReplacingOccurrencesOfString:@"Id: " withString:@""] intValue]];
		
		//TODO: generische lösung für alle tags die leer sein können (reflection)
        if (self.album == nil) {
            self.album = @" ";
        }
        if (self.artist == nil) {
            self.artist = @" ";
        }
        return;
    }
    return;
}

@end
