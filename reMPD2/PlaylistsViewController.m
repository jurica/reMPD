//
//  PlaylistsViewController.m
//  reMPD2
//
//  Created by Jurica Bacurin on 05.01.13.
//

#import "PlaylistsViewController.h"
#import "PlaylistViewController.h"

@interface PlaylistsViewController ()

@end

@implementation PlaylistsViewController

@synthesize proxy;
@synthesize playlists;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
	proxy = [MpdProxy instance];
	proxy.delegate = self;
	playlists = nil;
	[proxy getPlaylists];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
	self.playlists = playlistArray;
	
	[[self tableView] reloadData];
}

- (void)onDisconnectWithError:(NSError *)error {
	self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPlaylist"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PlaylistViewController *destViewController = segue.destinationViewController;
        destViewController.playlistName = [playlists objectAtIndex:indexPath.row];
    }
}

#pragma mark Table Data Source Methdos

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	NSUInteger row = playlists.count / 9 * (index);
	if (row == playlists.count) {
		row--;
	}
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	return 1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if (playlists.count < 20) {
		return nil;
	} else {
		return [NSArray arrayWithObjects:@"•",@"•",@"•",@"•",@"•",@"•",@"•",@"•",@"•",@"•",nil];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [playlists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *SimpleTableIdentifier = @"PlaylistsCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	if ( cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
	}
	
	cell.textLabel.text = [playlists objectAtIndex:indexPath.row];
	if (playlists.count >= 20) {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	[proxy deletePlaylist:[playlists objectAtIndex:indexPath.row]];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	NSLog(@"listplaylist %@", [playlists objectAtIndex:indexPath.row]);
//	
//	[tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

@end
