//
//  iPhoneBoxTestAppDelegate.h
//  iPhoneBoxTest
//
//  Created by Mike Matz on 7/8/09.
//  Copyright Flying Yeti 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FYiPhoneBoxController;

@interface iPhoneBoxTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	FYiPhoneBoxController *box;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (IBAction)clickImage1:(id)sender;
- (IBAction)clickImage2:(id)sender;

@end

