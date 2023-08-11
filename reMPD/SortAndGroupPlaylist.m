//
//  SortAndGroupPlaylist.m
//  reMPD
//
//  Created by Jurica Bacurin on 24.07.11.
//

#import "SortAndGroupPlaylist.h"
#import "MpdPlaylistItem.h"

#define HASH	@"123"

@implementation SortAndGroupPlaylist

//+ (NSArray *) indizes {
//	return [NSArray arrayWithObjects:@"#",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",HASH,nil];
//}
//
//+ (NSArray *)groupPlaylist:(NSDictionary *)playlist by:(NSString *)attr {
//	NSArray *result = [self createGroupArray];
//	NSArray *indizes = [self indizes];
//	SEL selector = NSSelectorFromString(attr);
//	
//	for (NSNumber *itemId in playlist) {
//		MpdPlaylistItem *item = [playlist objectForKey:itemId];
//		NSString *firstChar = [[[item performSelector:selector] substringToIndex:1] capitalizedString];
//		if ([indizes containsObject:firstChar]) {
//			[[result objectAtIndex:[indizes indexOfObject:firstChar]] addObject:[item mpdid]];
//		} else {
//			[[result objectAtIndex:[indizes indexOfObject:HASH]] addObject:[item mpdid]];
//		}
//	}
//	
//	for (NSMutableArray *members in result) {
//		[members sortUsingComparator:^(id obj1, id obj2) {
//			MpdPlaylistItem *item1 = [playlist objectForKey:obj1];
//			MpdPlaylistItem *item2 = [playlist objectForKey:obj2];
//			
//			return [[item1 performSelector:selector] compare:[item2 performSelector:selector] options:NSCaseInsensitiveSearch];
//		}];
//	}
//	
//	return result;
//}
//
//+ (NSArray *)createGroupArray {
//	NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[[self indizes] count]];
//	
//	for (NSString *index in [self indizes]) {
//		NSMutableArray *arr = [[NSMutableArray alloc] init];
//		[result addObject:arr];
//	}
//	
//	return result;
//}

@end
