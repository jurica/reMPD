//
//  TitlesViewController.m
//  reMPD2
//
//  Created by Jurica Bacurin on 06.01.13.
//

#import "TitlesViewController.h"

@interface TitlesViewController ()

@end

@implementation TitlesViewController

@synthesize proxy;
@synthesize titles;
@synthesize selectedItem;
@synthesize searchBar;
@synthesize initialTitlesLength;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	proxy = [MpdProxy instance];
	proxy.delegate = self;
	
	searchBar.placeholder = NSLocalizedString(@"searchbar.placeholder", @"Search for");
	searchBar.scopeButtonTitles = [NSArray arrayWithObjects:NSLocalizedString(@"searchbar.scopeAny", @""), NSLocalizedString(@"searchbar.scopeArtist", @"Artist"), NSLocalizedString(@"searchbar.scopeAlbum", @"Album"), NSLocalizedString(@"searchbar.scopeTitle", @"Title"), nil];
	
	self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated {
	proxy.delegate = self;
	titles = nil;
//	[proxy getAllTitles];
}

- (void)viewDidAppear:(BOOL)animated {
	[proxy getAllTitles];
//	if (self.titles.count >0) {
//		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//	}
	NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidAppear:) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
	NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadClicked {
	if (titles.count == proxy.stats.songs) {
		UIActionSheet *actionSheet = [[UIActionSheet alloc]
									  initWithTitle:@"Please select action"
									  delegate:self
									  cancelButtonTitle:@"Cancel"
									  destructiveButtonTitle:nil
									  otherButtonTitles:@"New Playlist with all Titles", nil];
		[actionSheet showFromTabBar:[[self tabBarController] tabBar]];
	} else {
		UIActionSheet *actionSheet = [[UIActionSheet alloc]
									  initWithTitle:@"Please select action"
									  delegate:self
									  cancelButtonTitle:@"Cancel"
									  destructiveButtonTitle:nil
									  otherButtonTitles:@"Add Selection to the end of Playlist", @"New Playlist from Selection", nil];
		[actionSheet showFromTabBar:[[self tabBarController] tabBar]];
	}
	
	self.selectedItem = nil;
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
}

- (void)onRetreivedStoredPlaylist:(MpdPlaylist *)playlist {
}

- (void)onRetreivedAllTitles:(NSArray *)newTitles {
	self.titles = nil;
	self.titles = newTitles;
	
	[[self tableView] reloadData];

	if (self.titles.count > 0 && (searchBar.text.length == 0) ) {
		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	}
}

- (void)onDisconnectWithError:(NSError *)error {
	self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
}

#pragma mark Table Data Source Methdos

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
	return [titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *SimpleTableIdentifier = @"TitlesCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	
	MpdPlaylistItem *item = [titles objectAtIndex:[indexPath row]];
	
	cell.textLabel.text = [item title];
	if (item.album.length == 0) {
		cell.detailTextLabel.text = [item artist];
	} else {
		cell.detailTextLabel.text = [[[item album] stringByAppendingString:@" - "] stringByAppendingString:[item artist]];
	}
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
	
	self.selectedItem = [titles objectAtIndex:indexPath.row];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

# pragma mark UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//	[actionSheet cancelButtonIndex];
//	[actionSheet destructiveButtonIndex];
	
	if (self.selectedItem != nil) {
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
		if (titles.count == proxy.stats.songs) {
			if (buttonIndex == 0) {
				[proxy clearCurrentPlaylist];
				[proxy addAll];
			}
		} else {
			if (buttonIndex == 0) {
				for (MpdPlaylistItem *title in titles) {
					[proxy addToPlaylist:title startPlaying:NO];
				}
			} else if (buttonIndex == 1) {
				[proxy clearCurrentPlaylist];
				for (MpdPlaylistItem *title in titles) {
					[proxy addToPlaylist:title startPlaying:NO];
				}
			}
		}
		[self searchBarTextDidEndEditing];
	}
}

#pragma mark SearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)bar {
	if (searchBar.selectedScopeButtonIndex == 0) {
		[proxy searchDatabase:@"any" searchString:searchBar.text];
	} else if (searchBar.selectedScopeButtonIndex == 1) {
		[proxy searchDatabase:@"artist" searchString:searchBar.text];
	} else if (searchBar.selectedScopeButtonIndex == 2) {
		[proxy searchDatabase:@"album" searchString:searchBar.text];
	} else if (searchBar.selectedScopeButtonIndex == 3) {
		[proxy searchDatabase:@"title" searchString:searchBar.text];
	}
	
	[self.view endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self searchBarTextDidEndEditing];
}

- (void)searchBarTextDidEndEditing {
	[proxy getAllTitles];
	searchBar.text = @"";
    [searchBar resignFirstResponder];
}

#pragma mark keyboard handling

- (void) keyboardDidAppear:(NSNotification*) n {
    CGRect bounds = [[[n userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    bounds = [self.view convertRect:bounds fromView:nil];
	
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height -= bounds.size.height; // subtract the keyboard height
    if (self.tabBarController != nil) {
        tableFrame.size.height += 49; // add the tab bar height
    }
	
    [UIView beginAnimations:nil context:NULL];
	
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(shrinkDidEnd:finished:contextInfo:)];
    self.tableView.frame = tableFrame;
    [UIView commitAnimations];
}

- (void) keyboardWillDisappear:(NSNotification*) n {
    CGRect bounds = [[[n userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    bounds = [self.view convertRect:bounds fromView:nil];
	
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height += bounds.size.height; // add the keyboard height
	
    if (self.tabBarController != nil) {
        tableFrame.size.height -= 49; // subtract the tab bar height
    }
	
    [UIView beginAnimations:nil context:NULL];
	
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(shrinkDidEnd:finished:contextInfo:)];
    self.tableView.frame = tableFrame;
    [UIView commitAnimations];
}

@end
