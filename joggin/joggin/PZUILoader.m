//
//  TictappsUILoader.m
//
//
//  Created by Marcos Griselli on 20/09/10.
//  Copyright 2010 pizquiz. All rights reserved.
//

#import "PZUILoader.h"
@interface PZUILoader(private)
- (void)orientationChange:(NSNotification *)notification;
- (void)rotateTo:(UIInterfaceOrientation)anOrientation;

@end

@implementation PZUILoader

@synthesize imageView,mustRotate,message;

PZUILoader *pizquizUILoaderInstance;

+ (id)sharedLoader{
	if (!pizquizUILoaderInstance)
		pizquizUILoaderInstance = [[PZUILoader alloc] initWithFrame:CGRectZero];
	return pizquizUILoaderInstance;
}


- (id)initWithFrame:(CGRect)frame {
	
    if (self = [super initWithFrame:[[[UIApplication sharedApplication] keyWindow] bounds]]) {
		mustRotate = YES;
		CGRect screenBounds =  [[UIScreen mainScreen]bounds];
		
		screenSize = CGSizeMake(screenBounds.size.width,screenBounds.size.height);
		self.backgroundColor = [UIColor clearColor];
//        self.alpha = 0.5;
        self.tintColor = [UIColor clearColor];

        contentView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 40, self.frame.size.height/2 - 40, 80, 80)];
        contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        contentView.layer.cornerRadius = 10;
        contentView.backgroundColor = [UIColor blackColor];
        contentView.alpha = 0.5;


        [self addSubview:contentView];
        
        messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 190, 200, 30)];
        messageLbl.textColor = [UIColor whiteColor];
        messageLbl.text = @"Loading...";
        messageLbl.backgroundColor = [UIColor clearColor];
        messageLbl.textAlignment = NSTextAlignmentCenter;
        messageLbl.font = [UIFont boldSystemFontOfSize:20];
        messageLbl.layer.shadowOffset = CGSizeMake(0, 1);
        messageLbl.layer.shadowColor = [[UIColor blackColor] CGColor];
        messageLbl.layer.shadowRadius = 1;
//        [contentView addSubview:messageLbl];
        

        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        CGSize activitySize = CGSizeMake(25, 25);
        activity.frame = CGRectMake( contentView.frame.size.width/2 - activitySize.width/2,
                                     contentView.frame.size.height/2 - activitySize.height/2,
                                    activitySize.width, activitySize.height);

//        [activity setColor: [UIColor colorWithRed:73.f/255.f green:140.f/255.f blue:208.f/255.f alpha:1]];
        [activity setColor:[UIColor whiteColor]];
        [contentView addSubview:activity];
        
    }
    return self;
}

- (void) setMessage:(NSString *)aMessage {
    messageLbl.text = aMessage;
}

- (NSString*) message {
    return messageLbl.text;
}

-(void)setImageView:(UIImageView *)anImageView{
	if(anImageView != imageView){
		imageView = anImageView;
		[self addSubview:imageView];

		imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
	}
}

#pragma mark Show

- (void)show {
    value = 0;
    prevalue = 0;
    self.hidden = NO;
	orientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	UIApplication* thisApplication = [UIApplication sharedApplication]; 
	UIWindow* frontWindow = thisApplication.keyWindow;
	
	[frontWindow addSubview:self];
	[imageView startAnimating];
	imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	scaleAnimation.fromValue = [NSNumber numberWithFloat:0.0];
	scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
	scaleAnimation.duration = 0.35f; //loader
	scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

	[contentView.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];

	if(imageView.animationImages)
		[imageView startAnimating];
    
    [activity startAnimating];
}

- (void)animationIdBegan:(NSString*)animationId finished:(BOOL)finished context:(void*)context {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	if(imageView.animationImages)
		[imageView stopAnimating];

	[self removeFromSuperview];
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {    
    self.hidden = YES;    
}

#pragma mark Hide

- (void)hide {


    [activity stopAnimating];


	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
	scaleAnimation.toValue = [NSNumber numberWithFloat:.0];
	scaleAnimation.duration = .35f;
	scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.delegate = self;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
	[contentView.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
    self.hidden = YES;

    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

}

-(void) removeBackground{
    CGSize activitySize = CGSizeMake(25, 25);
    activity.frame = CGRectMake( self.frame.size.width/2 - activitySize.width/2,
                                self.frame.size.height/2 - activitySize.height/2,
                                activitySize.width, activitySize.height);
    [self addSubview:activity];
    [contentView removeFromSuperview];
}

- (BOOL) isWorking {
    return [activity isAnimating];
}


@end
