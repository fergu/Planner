//
//  PLSlideView.h
//  Planner
//
//  Created by Kevin on 10/19/09.
//  Copyright 2009 University of Arizona. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PLSlideView : UIView
{
	BOOL isVisible;
	
	UIView *slideView;
	UIView *parentView;
}
-(id)initWithNibName:(NSString *)nibName inView:(UIView *)view;

-(id)getSubviewOfClassType:(Class)theClass;

-(void)slideIn:(NSInteger)verticalShift disableInteraction:(BOOL)modal;

-(IBAction)slideOut;

@property (nonatomic, retain) UIView *slideView;
@property (nonatomic, retain) UIView *parentView;
@end
