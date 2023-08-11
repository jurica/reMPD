//
//  CurrentPlaylistViewController.m
//  reMPD2
//
//  Created by Jurica Bacurin on 30.12.12.
//

#import "CurrentPlaylistViewController.h"
#import "MpdProxy.h"
#import "MpdStatus.h"
#import "MpdPlaylist.h"
#import "MpdPlaylistItem.h"

@interface CurrentPlaylistViewController ()

@end

@implementation CurrentPlaylistViewController

@synthesize proxy;
@synthesize edit;
@synthesize compose;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	proxy = [MpdProxy instance];
	proxy.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
	proxy.delegate = self;
	[[self tableView] reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	if (proxy.isConnected && proxy.status.song != 0) {
		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:proxy.status.song inSection:0]
							  atScrollPosition:UITableViewScrollPositionNone animated:YES];
	}
	[self updateGui];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editPressed:(id)sender {
	if ([self.tableView isEditing]) {
		[self.tableView setEditing:NO animated:YES];
		[edit setStyle:UIBarButtonItemStyleBordered];
		[edit setTitle:@"Edit"];
	} else {
		[self.tableView setEditing:YES animated:YES];
		[edit setStyle:UIBarButtonItemStyleDone];
		[edit setTitle:@"Done"];
	}
}

#pragma mark MpdProxyDelegate methods

- (void)onChangeStatus {
	[self updateGui];
	[[self tableView] reloadData];
}

- (void)onChangePlaylist {
	[self updateGui];
	[[self tableView] reloadData];
}

- (void)onConnectionError:(NSError *)error {
	[self updateGui];
	[[self tableView] reloadData];
}

- (void)onDisconnectWithError:(NSError *)error {
	self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
}

- (void)updateGui {
	if (proxy.isConnected) {
		edit.enabled = YES;
		compose.enabled = YES;
		for (UITabBarItem *item in self.tabBarController.tabBar.items) {
			item.enabled = YES;
		}
	} else {
		edit.enabled = NO;
		compose.enabled = NO;
		for (UITabBarItem *item in self.tabBarController.tabBar.items) {
			if (item.tag == 0) {
				item.enabled = NO;
			}
		}
	}
}

#pragma mark Table Data Source Methdos

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	NSUInteger row = proxy.playlist.count / 9 * (index);
	if (row == proxy.playlist.count) {
		row--;
	}
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	return 1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if (proxy.playlist.count < 20) {
		return nil;
	} else {
		return [NSArray arrayWithObjects:@"•",@"•",@"•",@"•",@"•",@"•",@"•",@"•",@"•",@"•",nil];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (!proxy.isConnected) {
		return 0;
	}
	return [[proxy playlist] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *SimpleTableIdentifier;
	if ([proxy.status.state rangeOfString:@"stop"].location != NSNotFound) {
		SimpleTableIdentifier = @"CurrentPlaylistCell";
	} else if (self.proxy.status.song == indexPath.row) {
		SimpleTableIdentifier = @"CurrentPlaylistCellPlaying";
	} else {
		SimpleTableIdentifier = @"CurrentPlaylistCell";
	}
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	if ( cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
	}
	cell.showsReorderControl = YES;

	MpdPlaylistItem *item = [[proxy playlist] objectAtIndex:indexPath.row];
	cell.textLabel.text = [item title];
	cell.detailTextLabel.text = [[[item album] stringByAppendingString:@" - "] stringByAppendingString:[item artist]];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MpdPlaylistItem *item = [[proxy playlist] objectAtIndex:[indexPath row]];
	
	[proxy play:item];
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	MpdPlaylistItem *selectedItem = [proxy.playlist objectAtIndex:sourceIndexPath.row];
	[proxy removeFromCurrentPlaylist:selectedItem];
	[proxy addToPlaylist:selectedItem atPos:destinationIndexPath.row];
//	[[self tableView] reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	[proxy removeFromCurrentPlaylist:[proxy.playlist objectAtIndex:indexPath.row]];
}

@end
