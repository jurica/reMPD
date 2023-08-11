//
//  SettingsViewController.h
//  reMPD2
//
//  Created by Jurica Bacurin on 20.01.13.
//

#import <UIKit/UIKit.h>
#import "MpdProxy.h"
#import "HUDHelper.h"

@interface SettingsViewController : UITableViewController <MpdProxyDelegate, UITextFieldDelegate>

@property (nonatomic, strong) MpdProxy *proxy;
@property (nonatomic, strong) IBOutlet UITextField *server;
@property (nonatomic, strong) IBOutlet UITextField *port;
@property (nonatomic, strong) IBOutlet UILabel *connected;

@end
