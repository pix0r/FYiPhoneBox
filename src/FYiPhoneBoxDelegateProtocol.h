/*
 *  FYiPhoneBoxDelegateProtocol.h
 *  iPhoneBoxTest
 *
 *  Created by Mike Matz on 7/8/09.
 *  Copyright 2009 Flying Yeti. All rights reserved.
 *
 */

@class FYiPhoneBoxController;

@protocol FYiPhoneBoxDelegate <NSObject>
@optional
- (void)fyiPhoneBoxDidClose:(FYiPhoneBoxController *)boxController;
- (void)fyiPhoneBox:(FYiPhoneBoxController *)boxController didFailToLoadImageWithURL:(NSString *)imageURL;
@end

