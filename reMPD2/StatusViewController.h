//
//  StatusViewController.h
//  reMPD2
//
//  Created by Jurica Bacurin on 29.12.12.
//

#import <UIKit/UIKit.h>
#import "MpdProxy.h"
#import "HUDHelper.h"

@class MpdProxy;

@interface StatusViewController : UIViewController <MpdProxyDelegate>

@property (nonatomic, strong) MpdProxy *proxy;
@property (nonatomic, strong) IBOutlet UITextView *trackInfo;
@property (nonatomic, strong) IBOutlet UIButton *playpause;
@property (nonatomic, strong) IBOutlet UIButton *random;
@property (nonatomic, strong) IBOutlet UIButton *reconnect;
@property (nonatomic, strong) IBOutlet UIButton *next;
@property (nonatomic, strong) IBOutlet UIButton *previous;
@property (nonatomic, strong) IBOutlet UILabel *volume;
@property (nonatomic, strong) IBOutlet UIButton *volumeUp;
@property (nonatomic, strong) IBOutlet UIButton *volumeDown;
@property (nonatomic, strong) IBOutlet UILabel *nextHeader;
@property (nonatomic, strong) IBOutlet UILabel *nextTitle;
@property (nonatomic, strong) IBOutlet UILabel *nextArtist;
@property (nonatomic, strong) IBOutlet UILabel *nextAlbum;
@property (nonatomic, strong) IBOutlet UILabel *currentHeader;
@property (nonatomic, strong) IBOutlet UILabel *currentTitle;
@property (nonatomic, strong) IBOutlet UILabel *currentArtist;
@property (nonatomic, strong) IBOutlet UILabel *currentAlbum;
@property (nonatomic, strong) IBOutlet UILabel *status;

- (IBAction)playpausePressed;
- (IBAction)randomPressed;
- (IBAction)reconnectPressed;
- (IBAction)nextPressed;
- (IBAction)previousPressed;
- (IBAction)volUpPressed;
- (IBAction)volDownPressed;

@end
