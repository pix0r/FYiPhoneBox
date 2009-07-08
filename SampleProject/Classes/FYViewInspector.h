//
//  FYViewInspector.h
//  WolverineApp
//
//  Created by Mike Matz on 4/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface FYViewInspector : NSObject {

}

+ (void)inspectView: (UIView *)theView depth:(int)depth path:(NSString *)path;
+ (NSString *)stringPad:(int)numPad;


@end
