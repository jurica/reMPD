//
//  PlaylistsViewController.h
//  reMPD2
//
//  Created by Jurica Bacurin on 05.01.13.
//

#import <UIKit/UIKit.h>
#import "MpdProxy.h"
#import "HUDHelper.h"

@interface PlaylistsViewController : UITableViewController <MpdProxyDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MpdProxy *proxy;
@property (nonatomic, strong) NSArray *playlists;

@end
