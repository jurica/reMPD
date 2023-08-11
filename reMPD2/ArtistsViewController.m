//
//  ArtistsViewController.m
//  reMPD2
//
//  Created by Jurica Bacurin on 15.01.13.
//

#import "ArtistsViewController.h"

@interface ArtistsViewController ()

@end

@implementation ArtistsViewController

@synthesize proxy;
@synthesize artists;

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
	artists = nil;

	[proxy getAllArtists];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	ArtistAlbumsViewController *destViewController = segue.destinationViewController;
	destViewController.artistName = [artists objectAtIndex:indexPath.row];
}

#pragma mark MpdProxyDelegate methods

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

- (void)onConnect {
	[proxy getAllArtists];
}

- (void)onRetreivedAllArtists:(NSArray *)_artists {
	self.artists = _artists;
	[self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	NSUInteger row = artists.count / 9 * (index);
	if (row == artists.count) {
		row--;
	}
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	return 1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if (artists.count < 20) {
		return nil;
	} else {
		return [NSArray arrayWithObjects:@"•",@"•",@"•",@"•",@"•",@"•",@"•",@"•",@"•",@"•",nil];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return artists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ArtistCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	if ([[artists objectAtIndex:indexPath.row] isEqual:@""]) {
		cell.textLabel.text = @"<unknown>";
	} else {
		cell.textLabel.text = [artists objectAtIndex:indexPath.row];
	}
	if (artists.count >= 20) {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
    return cell;
}

@end
