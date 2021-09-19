//
//  PLVCAssignment.h
//  Planner
//
//  Created by Kevin Ferguson on 7/19/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "PLKit.h"

@interface PLVCAssignmentRoot : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	PLClass *plClass;
	PLAssignment *plAssignment;
	
	UITableViewCell *textFieldCell;
	UITableViewCell *textViewCell;
}
-(void)setLeftBarButtonItem;

-(void)slideUp;
-(void)slideDown;

@property (nonatomic, retain) PLClass *plClass;
@property (nonatomic, retain) PLAssignment *plAssignment;

@property (nonatomic, retain) IBOutlet UITableViewCell *textFieldCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *textViewCell;
@end
