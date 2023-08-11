//
//  StatsViewController.h
//  reMPD2
//
//  Created by Jurica Bacurin on 09.01.13.
//

#import <UIKit/UIKit.h>
#import "MpdProxy.h"
#import "MpdStats.h"

@interface StatsViewController : UITableViewController

@property (nonatomic, strong) MpdProxy *proxy;
@property (nonatomic, strong) NSDictionary *stats;
@property (nonatomic, strong) NSArray *index;

-(IBAction)doneClicked;

@end
