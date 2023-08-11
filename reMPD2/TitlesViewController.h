//
//  TitlesViewController.h
//  reMPD2
//
//  Created by Jurica Bacurin on 06.01.13.
//

#import <UIKit/UIKit.h>
#import "MpdProxy.h"
#import "MpdPlaylistItem.h"
#import "MpdStats.h"
#import "HUDHelper.h"

@interface TitlesViewController : UITableViewController <MpdProxyDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UISearchBarDelegate>

@property (nonatomic, strong) MpdProxy *proxy;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) MpdPlaylistItem *selectedItem;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic) NSUInteger initialTitlesLength;

- (IBAction)loadClicked;

@end
