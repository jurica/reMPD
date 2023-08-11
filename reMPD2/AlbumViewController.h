//
//  AlbumViewController.h
//  reMPD2
//
//  Created by Jurica Bacurin on 15.01.13.
//

#import <UIKit/UIKit.h>
#import "MpdProxy.h"
#import "MpdPlaylistItem.h"
#import "HUDHelper.h"

@interface AlbumViewController : UITableViewController <MpdProxyDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSString *albumName;
@property (nonatomic, strong) MpdProxy *proxy;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) MpdPlaylistItem *selectedItem;

- (IBAction)loadPressed;

@end
