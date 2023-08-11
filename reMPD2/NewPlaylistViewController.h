//
//  NewPlaylistViewController.h
//  reMPD2
//
//  Created by Jurica Bacurin on 07.01.13.
//

#import <UIKit/UIKit.h>
#import "MpdProxy.h"

@interface NewPlaylistViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *playlistName;
@property (nonatomic, strong) MpdProxy *proxy;

- (IBAction)cancelPressed:(id)sender;
- (IBAction)savePresses:(id)sender;

@end
