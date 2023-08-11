//
//  StatusViewController.m
//  reMPD2
//
//  Created by Jurica Bacurin on 29.12.12.
//

#import "StatusViewController.h"
#import "MpdProxy.h"
#import "MpdStatus.h"
#import "MpdPlaylistItem.h"

@interface StatusViewController ()

@end

@implementation StatusViewController

@synthesize proxy;
@synthesize trackInfo;
@synthesize playpause;
@synthesize previous;
@synthesize next;
@synthesize random;
@synthesize reconnect;
@synthesize volume;
@synthesize volumeUp;
@synthesize volumeDown;
@synthesize nextHeader;
@synthesize nextAlbum;
@synthesize nextArtist;
@synthesize nextTitle;
@synthesize currentHeader;
@synthesize currentAlbum;
@synthesize currentArtist;
@synthesize currentTitle;
@synthesize status;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	proxy = [MpdProxy instance];
	proxy.delegate = self;
	[self updateGui];
	[self onChangeStatus];
	
//	[self.tabBarController setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
	proxy.delegate = self;
	[self updateGui];
	[self onChangeStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark button actions

- (IBAction)playpausePressed {
	[proxy playpause];
}

- (IBAction)randomPressed {
	[proxy toggleRandom];
}

- (IBAction)nextPressed {
	[proxy next];
}

- (IBAction)previousPressed {
	[proxy previous];
}

- (IBAction)volDownPressed {
	int vol = [[proxy status] volume] - 5;
	[proxy setVolume:vol];
}

- (IBAction)volUpPressed {
	int vol = [[proxy status] volume] + 5;
	[proxy setVolume:vol];
}

- (IBAction)reconnectPressed {
	[proxy connect];
}

- (void)updateGui {
	if (proxy.isConnected == YES) {
		[self showAll];
		if ([proxy.status.state rangeOfString:@"play"].location != NSNotFound) {
			[playpause setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
		} else {
			[playpause setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
		}
		
		if ([[proxy status] random] == 1) {
			[random setImage:[UIImage imageNamed:@"randomon.png"] forState:UIControlStateNormal];
		} else if ([[proxy status] random] == 0) {
			[random setImage:[UIImage imageNamed:@"randomoff.png"] forState:UIControlStateNormal];
		}
		
		if ([proxy.status.state rangeOfString:@"stop"].location != NSNotFound) {
			currentArtist.text = @"";
			currentAlbum.text = @"";
			currentTitle.text = @"";
			
			nextTitle.text = @"";
			nextArtist.text = @"";
			nextAlbum.text = @"";
		} else {
			currentArtist.text = [proxy getCurrentSong].artist;
			currentAlbum.text = [proxy getCurrentSong].album;
			currentTitle.text = [proxy getCurrentSong].title;
			
			nextTitle.text = [proxy getNextSong].title;
			nextArtist.text = [proxy getNextSong].artist;
			nextAlbum.text = [proxy getNextSong].album;
		}
		
		[volume setText:[NSString stringWithFormat:@"Volume: %i", [[proxy status] volume]]];
	} else {
		[self hideAll];
	}
}

- (void) hideAll {
	playpause.hidden = YES;
	random.hidden = YES;
	next.hidden = YES;
	previous.hidden = YES;
	volume.hidden = YES;
	volumeDown.hidden = YES;
	volumeUp.hidden = YES;
	nextHeader.hidden = YES;
	nextAlbum.hidden = YES;
	nextArtist.hidden = YES;
	nextTitle.hidden = YES;
	currentHeader.hidden = YES;
	currentTitle.hidden = YES;
	currentArtist.hidden = YES;
	currentAlbum.hidden = YES;
	reconnect.hidden = NO;
	status.hidden = NO;
	
	for (UITabBarItem *item in self.tabBarController.tabBar.items) {
		if (item.tag == 0) {
			item.enabled = NO;
		}
    }
}

- (void) showAll {
	playpause.hidden = NO;
	random.hidden = NO;
	next.hidden = NO;
	previous.hidden = NO;
	volume.hidden = NO;
	volumeDown.hidden = NO;
	volumeUp.hidden = NO;
	nextHeader.hidden = NO;
	nextAlbum.hidden = NO;
	nextArtist.hidden = NO;
	nextTitle.hidden = NO;
	currentHeader.hidden = NO;
	currentTitle.hidden = NO;
	currentArtist.hidden = NO;
	currentAlbum.hidden = NO;
	reconnect.hidden = YES;
	status.hidden = YES;
	[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
	
	for (UITabBarItem *item in self.tabBarController.tabBar.items) {
		item.enabled = YES;
    }
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

- (void)onConnect {
	[self updateGui];
}

- (void)onChangeStatus {
	[self updateGui];
}

- (void)onChangePlaylist {
	[self updateGui];
}

- (void)onConnectionError:(NSError *)error {
	[self updateGui];
}

- (void)onDisconnectWithError:(NSError *)error {
	[self updateGui];
}

@end
