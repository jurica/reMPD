//
//  CurrentPlaylistViewController.h
//  reMPD2
//
//  Created by Jurica Bacurin on 30.12.12.
//

#import <UIKit/UIKit.h>
#import "MpdProxy.h"
#import "StatusViewController.h"

@interface CurrentPlaylistViewController : UITableViewController <MpdProxyDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MpdProxy *proxy;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *edit;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *compose;

- (IBAction)editPressed:(id)sender;

@end
