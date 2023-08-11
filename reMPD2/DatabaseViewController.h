//
//  DatabaseViewController.h
//  reMPD2
//
//  Created by Jurica Bacurin on 20.01.13.
//

#import <UIKit/UIKit.h>
#import "MpdProxy.h"

@interface DatabaseViewController : UITableViewController <MpdProxyDelegate>

@property (nonatomic, strong) MpdProxy *proxy;

@end
