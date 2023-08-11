//
//  AppDelegate.h
//  reMPD2
//
//  Created by Jurica Bacurin on 17.12.12.
//

#import <UIKit/UIKit.h>
#import "MpdProxy.h"
@class MpdProxy;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
	MpdProxy *proxy;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MpdProxy *proxy;

@end
