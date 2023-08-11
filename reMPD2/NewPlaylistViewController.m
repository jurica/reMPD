//
//  NewPlaylistViewController.m
//  reMPD2
//
//  Created by Jurica Bacurin on 07.01.13.
//

#import "NewPlaylistViewController.h"

@interface NewPlaylistViewController ()

@end

@implementation NewPlaylistViewController

@synthesize playlistName;
@synthesize proxy;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	self.playlistName.delegate = self;
	[self.playlistName becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
	proxy = [MpdProxy instance];
//	proxy.delegate = self;
//	[proxy getPlaylists];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelPressed:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
	
//	[self.parentViewController loadView];
}

- (IBAction)savePresses:(id)sender {
	[proxy savePlaylist:self.playlistName.text];
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Text Field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[proxy savePlaylist:self.playlistName.text];
	[self dismissViewControllerAnimated:YES completion:nil];
	
	return YES;
}
//
//#pragma mark MPD Delegate Methods
//
//- (void)onChangePlaylist {
//}
//
//- (void)onChangeStoredPlaylist:(NSArray *)playlists {
//}

@end
