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
	
	box = [[FYiPhoneBoxController alloc] init];
	[box viewWillAppear:NO];
	[window addSubview:box.view];
	[box viewDidAppear:NO];
	
	/*
	UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[closeButton setTitle:@"Close!" forState:UIControlStateNormal];
	[closeButton addTarget:self action:@selector(dummySelector:) forControlEvents:UIControlEventValueChanged];
	box.closeButton = closeButton;
	 */
	
	[FYViewInspector inspectView:window depth:0 path:@""];
}

- (void)dealloc {
    [window release];
    [box release];
	[super dealloc];
}

- (IBAction)clickImage1:(id)sender {
	[box showImageWithURL:@"http://images.sushipedia.org/Akami.1.large.jpg"];
}

- (IBAction)clickImage2:(id)sender {
	[box showImageWithURL:@"http://images.sushipedia.org/Akami.2.large.jpg"];
}


@end
