//
//  HUDHelper.h
//  reMPD2
//
//  Created by Jurica Bacurin on 01.02.13.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface HUDHelper : NSObject

+ (void)showHudOnView:(UIView *)view;
+ (void)hideHudFromView:(UIView *)view;

@end
