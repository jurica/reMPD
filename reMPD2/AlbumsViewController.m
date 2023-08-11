//
//  AlbumsViewController.m
//  reMPD2
//
//  Created by Jurica Bacurin on 15.01.13.
//

#import "AlbumsViewController.h"

@interface AlbumsViewController ()

@end

@implementation AlbumsViewController

@synthesize proxy;
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
	proxy.delegate = self;
	albums = nil;
	
	[proxy getAllAlbums];
}

- (void)onRetreivedAlbums:(NSArray *)_albums {
	self.albums = _albums;
	[self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	AlbumViewController *destViewController = segue.destinationViewController;
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

- (void)onDisconnectWithError:(NSError *)error {
	self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AlbumsCell";
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
