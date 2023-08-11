//
//  ArtistAlbumsViewController.m
//  reMPD2
//
//  Created by Jurica Bacurin on 15.01.13.
//

#import "ArtistAlbumsViewController.h"

@interface ArtistAlbumsViewController ()

@end

@implementation ArtistAlbumsViewController

@synthesize proxy;
@synthesize artistName;
@synthesize albums;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	proxy = [MpdProxy instance];
	proxy.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
	self.title = artistName;
	if ([artistName isEqual:@""]) {
		self.title = @"<unknown>";
	}
	
	proxy.delegate = self;
	albums = nil;
	
	[proxy getArtistAlbums:artistName];
}

- (void)onRetreivedAlbums:(NSArray *)_albums {
	self.albums = _albums;
	[self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	ArtistAlbumViewController *destViewController = segue.destinationViewController;
	destViewController.albumName = [albums objectAtIndex:indexPath.row];
}

#pragma mark MpdProxyDelegegate methods

- (BOOL)shouldShowHud {
	return YES;
}

- (void)showHud {
	[HUDHelper showHudOnView:self.view];
}

- (void)hideHud {
	[HUDHelper hideHudFromView:self.view];
}

- (void)onDisconnectWithError:(NSError *)error {
	self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	NSUInteger row = albums.count / 9 * (index);
	if (row == albums.count) {
		row--;
	}
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	return 1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if (albums.count < 20) {
		return nil;
	} else {
		return [NSArray arrayWithObjects:@"•",@"•",@"•",@"•",@"•",@"•",@"•",@"•",@"•",@"•",nil];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ArtistAlbumCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if ([[albums objectAtIndex:indexPath.row] isEqual:@""]) {
		cell.textLabel.text = @"<unknown>";
	} else {
		cell.textLabel.text = [albums objectAtIndex:indexPath.row];
	}
	if (albums.count >= 20) {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
    return cell;
}

@end
