//
//  AlbumsViewController.h
//  reMPD2
//
//  Created by Jurica Bacurin on 15.01.13.
//

#import <UIKit/UIKit.h>
#import "MpdProxy.h"
#import "AlbumViewController.h"
#import "HUDHelper.h"

@interface AlbumsViewController : UITableViewController <MpdProxyDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UISearchBarDelegate>

@property (nonatomic, strong) MpdProxy *proxy;
@property (nonatomic, strong) NSArray *albums;

@end
