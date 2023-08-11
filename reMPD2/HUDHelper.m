//
//  HUDHelper.m
//  reMPD2
//
//  Created by Jurica Bacurin on 01.02.13.
//

#import "HUDHelper.h"

@implementation HUDHelper

+ (void)showHudOnView:(UIView *)view {
	if ([MBProgressHUD allHUDsForView:view].count == 0) {
		[MBProgressHUD showHUDAddedTo:view animated:YES];
	}
}

+ (void)hideHudFromView:(UIView *)view {
	[MBProgressHUD hideAllHUDsForView:view animated:NO];
}

@end
