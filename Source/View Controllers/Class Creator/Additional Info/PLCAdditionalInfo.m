//
//  PLCAdditionalInfo.m
//  Planner
//
//  Created by Kevin Ferguson on 7/13/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

#import "PLCAdditionalInfo.h"


@implementation PLCAdditionalInfo
@synthesize plClass;

#pragma mark View Loading
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Additional Info";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
	[self.view setFrame:CGRectMake(0, 0, 320, 200)];
	
	if (self.plClass.additionalInfo)
		[(UITextView *)self.view setText:self.plClass.additionalInfo];
}

-(void)viewDidAppear:(BOOL)animated
{
	[self.view becomeFirstResponder];
}

#pragma mark Memory Management
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.plClass = nil;
    [super dealloc];
}

#pragma mark UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
	//Save the text
	self.plClass.additionalInfo = [textView text];
	//Remove the right button item
	[self.navigationItem setRightBarButtonItem:nil animated:YES];
}
@end
