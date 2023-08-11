//
//  AlbumViewController.m
//  reMPD2
//
//  Created by Jurica Bacurin on 15.01.13.
//

#import "AlbumViewController.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController

@synthesize proxy;
@synthesize titles;
@synthesize albumName;
@synthesize selectedItem;

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
	self.title = albumName;
	if ([albumName isEqual:@""]) {
		self.title = @"<unknown>";
	}
	
	proxy.delegate = self;
	titles = nil;
	selectedItem = nil;
	
	[proxy findAlbum:albumName];
}

- (void)onRetreivedAlbumTitles:(NSArray *)_titles {
	self.titles = _titles;
	[self.tableView reloadData];
}

- (IBAction)loadPressed {
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@"Please select action"
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:nil
								  otherButtonTitles:@"Add to the end of Playlist", @"Create new Playlist", nil];
    [actionSheet showFromTabBar:[[self tabBarController] tabBar]];
	
	selectedItem = nil;
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
	NSUInteger row = titles.count / 9 * (index);
	if (row == titles.count) {
		row--;
	}
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	return 1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if (titles.count < 20) {
		return nil;
	} else {
		return [NSArray arrayWithObjects:@"•",@"•",@"•",@"•",@"•",@"•",@"•",@"•",@"•",@"•",nil];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AlbumCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	MpdPlaylistItem *item = [titles objectAtIndex:[indexPath row]];
    cell.textLabel.text = [item title];
	cell.detailTextLabel.text = [item artist];
	if (titles.count >= 20) {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@"Please select action"
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:nil
								  otherButtonTitles:@"Add to the end of Playlist", @"Add to Playlist as next Song", @"Add to Playlist as next Song and play", @"New Playlist from Song", nil];
    [actionSheet showFromTabBar:[[self tabBarController] tabBar]];
	
	selectedItem = [titles objectAtIndex:indexPath.row];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

# pragma mark UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (selectedItem != nil) {
		if (buttonIndex == 0) {
			[proxy addToPlaylist:self.selectedItem startPlaying:NO];
		} else if (buttonIndex == 1) {
			[proxy addAsNextToPlaylist:self.selectedItem startPlaying:NO];
		} else if (buttonIndex == 2) {
			[proxy addAsNextToPlaylist:self.selectedItem startPlaying:YES];
		} else if (buttonIndex == 3) {
			[proxy clearCurrentPlaylist];
			[proxy addToPlaylist:self.selectedItem startPlaying:NO];
		}
	} else {
		if (buttonIndex != actionSheet.cancelButtonIndex) {
			if (buttonIndex == 1) {
				[proxy clearCurrentPlaylist];
			}
			for (MpdPlaylistItem *title in titles) {
				[proxy addToPlaylist:title startPlaying:NO];
			}
		}
	}
}

@end
