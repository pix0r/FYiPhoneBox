//
//  iPhoneBoxController.h
//  iPhoneBoxTest
//
//  Created by Mike Matz on 7/8/09.
//  Copyright 2009 Flying Yeti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYiPhoneBoxDelegateProtocol.h"

@interface FYiPhoneBoxController : UIViewController {
	UIColor *overlayColor;
	BOOL alwaysDisplayCloseButton;
	BOOL neverDisplayCloseButton;
	BOOL rotateImageToFitScreen;
	BOOL autoRotateScreen;
	UIButton *closeButton;
	CGRect closeButtonFrame;

	NSString *imageURL;
	NSURLConnection *connection;
	NSMutableData *imageData;
	UIImage *image;
	UIImageView *imageView;
	UIButton *imageButton;
	UIActivityIndicatorView *activityView;
	UIView *imageMaskView;
	
	BOOL _isVisible;
	BOOL _isImageVisible;
	
	id<FYiPhoneBoxDelegate> delegate;
}

@property (nonatomic, retain) UIColor *overlayColor;
@property (nonatomic) BOOL alwaysDisplayCloseButton;
@property (nonatomic) BOOL neverDisplayCloseButton;
@property (nonatomic) BOOL rotateImageToFitScreen;
@property (nonatomic) BOOL autoRotateScreen;
@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic) CGRect closeButtonFrame;

@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *imageData;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIButton *imageButton;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, retain) UIView *imageMaskView;

@property (readonly) UIButton *defaultCloseButton;

@property (nonatomic, assign) id<FYiPhoneBoxDelegate> delegate;

// Public API
- (id)initWithImageURL:(NSString *)theURL;
- (id)initWithImage:(UIImage *)theImage;
- (BOOL)showImageWithURL:(NSString *)theURL;
- (BOOL)showImage:(UIImage *)theImage;
- (BOOL)loadImage;
- (void)show;
- (void)hide;

// IBActions
- (IBAction)clickImage:(id)sender;
- (IBAction)clickClose:(id)sender;

// Private methods
- (NSURLConnection *)getConnectionForURL:(NSString *)theURL;
- (void)showLoading;
- (void)hideLoading;
- (void)initCloseButton;
- (void)layoutCloseButton;
- (void)showCloseButton;
- (void)hideCloseButton;
- (void)startImageDisplayAnimation;
- (void)displayAnimationDidStop:(id)sender;
- (void)startImageHideAnimation;
- (void)hideAnimationDidStop:(id)sender;
- (BOOL)setImageViewBounds;
- (UIImage *)imageByScalingToFitSize:(CGSize)targetSize baseImage:(UIImage *)baseImage;
- (void)debugFrames;
- (void)errorLoadingImage;

@end
