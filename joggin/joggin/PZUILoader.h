//
//  TictappsUILoader.h
//
//
//  Created by Marcos Griselli on 20/09/14.
//  Copyright 2010 pizquiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PZUILoader : UIView {
	UIImageView* imageView;
	UIInterfaceOrientation orientation;
	CGSize screenSize;
	BOOL mustRotate;
    UIView* contentView;
    UILabel* messageLbl;
    UIActivityIndicatorView* activity;
    float value;
    float prevalue;
}

@property(nonatomic,retain) NSString* message;
/*!
 @discussion Indicate if the loader must rotate.
 */
@property(nonatomic)BOOL mustRotate;

/*!
 @discussion The UIImageView that will be shown. If has animation images then will shown with the animation.
 */
@property(nonatomic,retain)UIImageView *imageView;

/*!
 @discussion Returns the singleton pizquizUILoader.
 */
+ (id)sharedLoader;

/*!
 @discussion Shows the progress view in front of every other current view in the screen.
 */
- (void)show;

/*!
 @discussion Hides the progress view, if it was being shown.
 */
- (void)hide;

-(void) removeBackground;

- (BOOL) isWorking;

@end
