//
//  SettingsViewController.m
//  reMPD2
//
//  Created by Jurica Bacurin on 20.01.13.//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize proxy;
@synthesize port;
@synthesize server;
@synthesize connected;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	proxy = [MpdProxy instance];
	proxy.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
	proxy.delegate = self;
	[self updateGui];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateGui {
	server.text = proxy.host;
	port.text = [NSString stringWithFormat:@"%i", proxy.port];

	if (proxy.isConnected) {
		connected.text = NSLocalizedString(@"settings.connected.yes", @"text for is connected on settings screen");
		for (UITabBarItem *item in self.tabBarController.tabBar.items) {
			item.enabled = YES;
		}
	} else {
		connected.text = NSLocalizedString(@"settings.connected.no", @"text for is not connected on settings screen");
		for (UITabBarItem *item in self.tabBarController.tabBar.items) {
			if (item.tag == 0) {
				item.enabled = NO;
			}
		}
	}
}

- (void)updateMpdSettingsAndReconnect {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (![proxy.host isEqualToString:server.text]) {
		[defaults setValue:server.text forKey:@"Server"];
		[proxy disconnect];
	}
	if (proxy.port != [port.text integerValue]) {
		[defaults setValue:port.text forKey:@"Port"];
		[proxy disconnect];
	}
	
	[self.view endEditing:YES];
	
	[proxy connect];
}

#pragma mark MpdProxyDelegate

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
	[self updateGui];
}

- (void)onConnect {
	[self updateGui];
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[self updateMpdSettingsAndReconnect];
	[self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self updateMpdSettingsAndReconnect];
	[self.view endEditing:YES];
	
	return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
	
	if (indexPath.row == 2) {
		[self updateMpdSettingsAndReconnect];
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
