//
//  PLSlideView.m
//  Planner
//
//  Created by Kevin on 10/19/09.
//  Copyright 2009 University of Arizona. All rights reserved.
//

#import "Constants.h"
#import "PLSlideView.h"

@implementation PLSlideView
@synthesize slideView, parentView;

-(id)initWithNibName:(NSString *)nibName inView:(UIView *)view
{
	if (self = [super init]) 
	{
		//ParentView is the view that called this view
		self.parentView = view;
		
		
		//We then need to get the main view of the picker
		NSArray *views = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
		for (int i = 0; i < [views count]; i++) 
		{
			if ([[views objectAtIndex:i] isKindOfClass:[UIView class]]) 
			{
				self.slideView = [views objectAtIndex:i];
				
				if ([self.slideView isKindOfClass:[UIDatePicker class]])
					[(UIDatePicker *)self.slideView addTarget:self action:@selector(datePickerViewChanged) forControlEvents:UIControlEventValueChanged];
			}
		}
		
		//This lets us keep track of when the owner view will leave the screen
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ownerViewWillDisappear) name:kViewWillDisappearNote object:nil];
		
	}
		
	return self;
}


-(id)getSubviewOfClassType:(Class)theClass
{
	NSArray *views = [self.slideView subviews];
	UIView *retView;
	
	for (int i = 0; i < [views count]; i++) 
	{
		if ([[views objectAtIndex:i] isKindOfClass:theClass]) 
		{
			retView = [views objectAtIndex:i];
		}
	}
	
	return retView;
	
}

-(void)slideIn:(NSInteger)verticalShift disableInteraction:(BOOL)modal
{
	[self retain];
	if (modal)
		[self.parentView setUserInteractionEnabled:NO];
	
	self.slideView.frame = CGRectMake(0, 
									  self.parentView.window.frame.size.height + self.slideView.frame.size.height, 
									  self.slideView.frame.size.width, 
									  self.slideView.frame.size.height);
	
	[self.parentView.window addSubview:self.slideView];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	
	self.slideView.frame = CGRectMake(0, 
									  self.parentView.window.frame.size.height - self.slideView.frame.size.height, 
									  self.slideView.frame.size.width, 
									  self.slideView.frame.size.height);
	
	self.parentView.frame = CGRectMake(0, 
									   -verticalShift, 
									   self.parentView.frame.size.width, 
									   self.parentView.frame.size.height);
	[UIView commitAnimations];
	
	isVisible = TRUE;
}

-(IBAction)slideOut
{
	if (![self.parentView isUserInteractionEnabled]) {
		[self.parentView setUserInteractionEnabled:YES];
	}
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.5];
	self.slideView.frame = CGRectMake(0, 
									  self.slideView.frame.size.height + self.parentView.window.frame.size.height , 
									  self.slideView.frame.size.width, 
									  self.slideView.frame.size.height);
	
	self.parentView.frame = CGRectMake(0, 
									   0, 
									   self.parentView.frame.size.width, 
									   self.parentView.frame.size.height);
	[UIView commitAnimations];
	
	isVisible = FALSE;
}

#pragma mark Notification Methods
-(void)ownerViewWillDisappear
{
	if (isVisible)
		[self slideOut];
}

#pragma mark Animations
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	[self.slideView removeFromSuperview];
	[self.slideView release];
	[self.parentView release];
	[self release];
}

#pragma mark Memory Management
-(void)dealloc
{
	kWLog(@"PLSideView dealloc");
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

#pragma mark View Changed Notifications
-(void)datePickerViewChanged
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"datePickerViewChanged" object:nil];
}

@end
