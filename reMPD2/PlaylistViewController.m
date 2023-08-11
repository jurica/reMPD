//
//  PlaylistViewController.m
//  reMPD2
//
//  Created by Jurica Bacurin on 05.01.13.
//

#import "PlaylistViewController.h"

@interface PlaylistViewController ()

@end

@implementation PlaylistViewController

@synthesize playlistName;
@synthesize proxy;
@synthesize playlist;
@synthesize selectedItem;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	proxy = [MpdProxy instance];
	proxy.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
	proxy.delegate = self;
	playlist = nil;
	[self setTitle:playlistName];
	[proxy getPlaylist:playlistName];
	
	//[[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadPressed:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@"Please select action"
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:nil
								  otherButtonTitles:@"Add to the end of Playlist", @"Create new Playlist", nil];
    [actionSheet showFromTabBar:[[self tabBarController] tabBar]];
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

- (void)onChangeStatus {
}

- (void)onChangePlaylist {
	[[self tableView] reloadData];
}

- (void)onChangeStoredPlaylist:(NSArray *)playlistArray {
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)onRetreivedStoredPlaylist:(NSArray *)_playlist {
	self.playlist = _playlist;
	
	[[self tableView] reloadData];
}

- (void)onConnectionError:(NSError *)error {
}

- (void)onDisconnectWithError:(NSError *)error {
	self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
}

#pragma mark Table Data Source Methdos

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	NSUInteger row = playlist.count / 9 * (index);
	if (row == playlist.count) {
		row--;
	}
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	return 1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if (playlist.count < 20) {
		return nil;
	} else {
		return [NSArray arrayWithObjects:@"•",@"•",@"•",@"•",@"•",@"•",@"•",@"•",@"•",@"•",nil];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [playlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *SimpleTableIdentifier = @"PlaylistCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	if ( cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
	}
	
	MpdPlaylistItem *item = [playlist objectAtIndex:[indexPath row]];
	
	cell.textLabel.text = [item title];
	cell.detailTextLabel.text = [[[item album] stringByAppendingString:@" - "] stringByAppendingString:[item artist]];
	if (playlist.count >= 20) {
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
	
	self.selectedItem = [playlist objectAtIndex:indexPath.row];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

# pragma mark UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	//	[actionSheet cancelButtonIndex];
	//	[actionSheet destructiveButtonIndex];
	
	if (actionSheet.numberOfButtons == 3) {
		if (buttonIndex == 0) {
			[proxy loadPlaylist:self.playlistName];
		} else if (buttonIndex == 1) {
			[proxy clearCurrentPlaylist];
			[proxy loadPlaylist:self.playlistName];
		}
	} else if (actionSheet.numberOfButtons) {
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
	}
}

@end
