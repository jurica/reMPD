//
//  ArtistAlbumsViewController.h
//  reMPD2
//
//  Created by Jurica Bacurin on 15.01.13.
//

#import <UIKit/UIKit.h>
#import "MpdProxy.h"
#import "ArtistAlbumViewController.h"
#import "HUDHelper.h"

@interface ArtistAlbumsViewController : UITableViewController <MpdProxyDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) MpdProxy *proxy;
@property (nonatomic, strong) NSArray *albums;

@end
