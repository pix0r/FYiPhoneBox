//
//  iPhoneBoxTestAppDelegate.m
//  iPhoneBoxTest
//
//  Created by Mike Matz on 7/8/09.
//  Copyright Flying Yeti 2009. All rights reserved.
//

#import "iPhoneBoxTestAppDelegate.h"
#import "FYiPhoneBoxController.h"
#import "FYViewInspector.h"

@implementation iPhoneBoxTestAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window makeKeyAndVisible];
	
	NSLog(@"Showing iPhoneBoxController");
	FYiPhoneBoxController *box = [[FYiPhoneBoxController alloc] initWithImageURL:@"http://images.sushipedia.org/Akami.1.large.jpg"];
	[box viewWillAppear:NO];
	[window addSubview:box.view];
	[box viewDidAppear:NO];
	
	UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[closeButton setTitle:@"Close!" forState:UIControlStateNormal];
	box.closeButton = closeButton;
	
	[FYViewInspector inspectView:window depth:0 path:@""];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
