//
//  PlaylistViewController.h
//  reMPD2
//
//  Created by Jurica Bacurin on 05.01.13.
//

#import <UIKit/UIKit.h>
#import "MpdProxy.h"
#import "MpdStatus.h"
#import "MpdPlaylist.h"
#import "MpdPlaylistItem.h"
#import "HUDHelper.h"

@interface PlaylistViewController : UITableViewController <MpdProxyDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (nonatomic, strong) NSString *playlistName;
@property (nonatomic, strong) MpdProxy *proxy;
@property (nonatomic, strong) NSArray *playlist;
@property (nonatomic, strong) MpdPlaylistItem *selectedItem;

- (IBAction)loadPressed:(id)sender;

@end
