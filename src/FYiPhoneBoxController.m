//
//  iPhoneBoxController.m
//  iPhoneBoxTest
//
//  Created by Mike Matz on 7/8/09.
//  Copyright 2009 Flying Yeti. All rights reserved.
//

#import "FYiPhoneBoxController.h"

#define degreesToRadian(x) (M_PI * (x) / 180.0)

@implementation FYiPhoneBoxController

@synthesize overlayColor, alwaysDisplayCloseButton, neverDisplayCloseButton, rotateImageToFitScreen;
@synthesize closeButton, closeButtonFrame;
@synthesize imageURL, connection, imageData, image;
@synthesize imageView, imageButton, activityView, imageMaskView;

- (void)dealloc {
	[overlayColor release];
	[closeButton release];
	[imageURL release];
	[connection release];
	[imageData release];
	[image release];
	[imageView release];
	[imageButton release];
	[activityView release];
	[imageMaskView release];
    [super dealloc];
}

- (id)init {
	if (self = [super init]) {
		// Set default values
		rotateImageToFitScreen = YES;
		alwaysDisplayCloseButton = NO;
		neverDisplayCloseButton = NO;
		overlayColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
	}
	return self;
}

- (id)initWithImageURL:(NSString *)theURL {
	if (self = [self init]) {
		self.imageURL = theURL;
	}
	return self;
}

- (id)initWithImage:(UIImage *)theImage {
	if (self = [self init]) {
		self.image = theImage;
	}
	return self;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (void)loadView {
	
	UIView *myView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	myView.backgroundColor = self.overlayColor;
	myView.autoresizesSubviews = NO;
	self.view = myView;
	[myView release];

	UIView *myMaskView = [[UIView alloc] initWithFrame:self.view.bounds];
	myMaskView.backgroundColor = [UIColor clearColor];
	myMaskView.clipsToBounds = YES;
	myMaskView.hidden = YES;
	myMaskView.autoresizesSubviews = NO;
	[self.view addSubview:myMaskView];
	self.imageMaskView = myMaskView;
	[myMaskView release];
	
	UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	myImageView.center = self.view.center;
	myImageView.hidden = NO;
	[self.imageMaskView addSubview:myImageView];
	self.imageView = myImageView;
	[myImageView release];
	
	UIButton *myImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
	myImageButton.frame = self.view.frame;
	[myImageButton addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
	[self.imageMaskView addSubview:myImageButton];
	self.imageButton = myImageButton;
	
	UIActivityIndicatorView *myActivityView = [[UIActivityIndicatorView alloc] init];
	myActivityView.center = self.view.center;
	myActivityView.hidden = YES;
	[self.view addSubview:myActivityView];
	self.activityView = myActivityView;
	[myActivityView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (self.image == nil && self.imageURL != nil && self.connection == nil) {
		[self loadImage];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	_isVisible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	_isVisible = NO;
}

#pragma mark -
#pragma mark Public API

- (BOOL)showImageWithURL:(NSString *)theURL {
	self.imageURL = theURL;
	[self loadImage];
	[self show];
	return YES;
}

- (BOOL)showImage:(UIImage *)theImage {
	if (self.connection != nil)
		return NO;
	self.image = theImage;
	[self show];
	return YES;
}

- (BOOL)loadImage {
	self.image = nil;
	self.imageData = nil;
	self.connection = [self getConnectionForURL:self.imageURL];
	if (self.connection == nil)
		return NO;
	//[self.connection start];
	[self showLoading];
	return YES;
}

- (void)show {
	self.view.hidden = NO;
}

- (void)hide {
	self.view.hidden = YES;
}

#pragma mark -
#pragma mark Accessors/Mutators

- (void)setCloseButton:(UIButton *)aButton {
	if (closeButton != nil && closeButton.superview != nil) {
		[closeButton removeFromSuperview];
	}
	[closeButton release];
	closeButton = [aButton retain];
	for (id currTarget in [closeButton allTargets]) {
		NSLog(@"currTarget:%@", currTarget);
		// TODO: Verify that we are not a target
	}
	[closeButton addTarget:self action:@selector(clickClose:) forControlEvents:UIControlEventTouchUpInside];
	self.closeButtonFrame = CGRectZero;
}

- (void)setCloseButtonFrame:(CGRect)aRect {
	closeButtonFrame = aRect;
	self.closeButton.frame = closeButtonFrame;
}

#pragma mark -
#pragma mark IBActions

- (IBAction)clickImage:(id)sender {
	NSLog(@"clickImage");
	if (self.neverDisplayCloseButton) {
		[self hide];
	} else if (!self.alwaysDisplayCloseButton) {
		if (self.closeButton.hidden == NO) {
			[self hideCloseButton];
		} else {
			[self showCloseButton];
		}
	}
}

- (IBAction)clickClose:(id)sender {
	[self hide];
}

#pragma mark -
#pragma mark Private methods

- (NSURLConnection *)getConnectionForURL:(NSString *)theURL {
	NSLog(@"getConnection");
	NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:theURL]];
	if (![NSURLConnection canHandleRequest:req])
		return nil;
	NSURLConnection *conn = [NSURLConnection connectionWithRequest:req delegate:self];
	return conn;
}

- (void)showLoading {
	NSLog(@"showLoading");
	self.activityView.hidden = NO;
	[self.activityView startAnimating];
}

- (void)hideLoading {
	NSLog(@"hideLoading");
	self.activityView.hidden = YES;
	[self.activityView stopAnimating];
}

- (void)layoutCloseButton {
	if (self.closeButton == nil)
		return;
	[self.imageMaskView addSubview:self.closeButton];
	self.closeButton.hidden = YES;
	if (self.closeButtonFrame.size.height > 0)
		return;
	[closeButton sizeToFit];
	// Default to top-right corner of image
	CGRect tmpImageViewFrame = self.imageView.frame;
	CGRect tmpCloseButtonRect = CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width - closeButton.frame.size.width, self.imageView.frame.origin.y, closeButton.frame.size.width, closeButton.frame.size.height);
	self.closeButtonFrame = tmpCloseButtonRect;
}

- (void)showCloseButton {
	self.closeButton.hidden = NO;
}

- (void)hideCloseButton {
	self.closeButton.hidden = YES;
}

- (void)startImageDisplayAnimation {
	[self setImageViewBounds];
	
	// Start with mask as a single-pixel line
	self.imageMaskView.frame = self.view.bounds;
	//self.imageMaskView.bounds = CGRectMake(0, self.view.center.y, self.view.bounds.size.width, 1);
	self.imageMaskView.bounds = CGRectMake(0, self.view.bounds.size.height / 2, self.view.bounds.size.width, 1);
	self.imageMaskView.hidden = NO;
	
	[UIView beginAnimations:@"iPhoneBoxDisplayAnimation" context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(displayAnimationDidStop:)];
	self.imageMaskView.bounds = self.view.bounds;
	[UIView commitAnimations];
}

- (void)displayAnimationDidStop:(id)sender {
	[self layoutCloseButton];
	if (self.alwaysDisplayCloseButton) {
		[self showCloseButton];
	}
}

- (void)setImageViewBounds {
	CGSize imageSize = self.image.size;
	CGSize viewSize = self.view.bounds.size;
	
	if (imageSize.width > viewSize.width || imageSize.height > viewSize.height) {
		// Image is too large to fit - needs to be rotated, scaled, or both
		if (imageSize.width > imageSize.height && viewSize.width < viewSize.height && self.rotateImageToFitScreen) {
			// Image orientation is wrong, and rotateImageToFitScreen is enabled.
			
			// See if image will fit after rotated (width/height switched)
			if (imageSize.height > viewSize.width || imageSize.width > viewSize.height) {
				// Still too large - scale image
				UIImage *newImage = [self imageByScalingToFitSize:CGSizeMake(viewSize.height, viewSize.width) baseImage:self.image];
				self.image = newImage;
				self.imageView.image = newImage;
				imageSize = CGSizeMake(self.image.size.height, self.image.size.width);
			}
			// Apply rotation transformations
			self.imageView.transform = CGAffineTransformMakeRotation(degreesToRadian(90.0));
		} else {
			// Image orientation is correct; simply scale image
			UIImage *newImage = [self imageByScalingToFitSize:viewSize baseImage:self.image];
			self.image = newImage;
			self.imageView.image = newImage;
			self.imageView.transform = CGAffineTransformIdentity;
			imageSize = self.image.size;
		}
	}
	
	// Set new image frame based on image size, and keep it centered
	CGRect imageRect = CGRectMake((viewSize.width - imageSize.width) / 2, (viewSize.height - imageSize.height) / 2, imageSize.width, imageSize.height);
	self.imageView.frame = imageRect;
}

- (UIImage *)imageByScalingToFitSize:(CGSize)targetSize baseImage:(UIImage *)baseImage {
	CGFloat aspectRatio = baseImage.size.width / baseImage.size.height;
	CGFloat targetAspectRatio = targetSize.width / targetSize.height;
	CGSize resizeTo;
	if (aspectRatio > targetAspectRatio) {
		// Image is wide - limit on width
		resizeTo.width = targetSize.width;
		resizeTo.height = resizeTo.width / aspectRatio;
	} else {
		// Image is tall - limit on height
		resizeTo.height = targetSize.height;
		resizeTo.width = resizeTo.height * aspectRatio;
	}
	UIGraphicsBeginImageContext(resizeTo);
	CGRect drawRect = CGRectMake(0, 0, resizeTo.width, resizeTo.height);
	[baseImage drawInRect:drawRect];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	if (newImage == nil) {
		NSLog(@"Error scaling image!");
	}
	UIGraphicsEndImageContext();
	return newImage;
}

#pragma mark -
#pragma mark NSURLRequest delegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Error!");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData {
	if (self.imageData == nil) {
		self.imageData = [NSMutableData data];
	}
	[self.imageData appendData:theData];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)theResponse {
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"connectionDidFinishLoading");
	[NSThread sleepForTimeInterval:1.0];
	NSLog(@"done sleeping");
	self.image = [UIImage imageWithData:self.imageData];
	self.imageView.image = self.image;
	self.imageData = nil;
	self.connection = nil;
	if (_isVisible) {
		[self hideLoading];
		[self startImageDisplayAnimation];
	}
}


@end
