//
//  FYViewInspector.h
//
//  Created by Mike Matz on 4/9/09.
//  Copyright 2009 Flying Yeti. All rights reserved.
//
//	Credit: http://www.codza.com/custom-uiimagepickercontroller-camera-view

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface FYViewInspector : NSObject {

}

+ (void)inspectView: (UIView *)theView depth:(int)depth path:(NSString *)path;
+ (NSString *)stringPad:(int)numPad;


@end
