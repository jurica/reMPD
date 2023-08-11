//
//  ArtistsViewController.h
//  reMPD2
//
//  Created by Jurica Bacurin on 15.01.13.
//

#import <UIKit/UIKit.h>
#import "MpdProxy.h"
#import "MpdPlaylistItem.h"
#import "ArtistAlbumsViewController.h"
#import "HUDHelper.h"

@interface ArtistsViewController : UITableViewController <MpdProxyDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (nonatomic, strong) MpdProxy *proxy;
@property (nonatomic, strong) NSArray *artists;

@end
