//
//  PLCRoot.h
//  Planner
//
//  Created by Kevin Ferguson on 7/15/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PLKit.h"

@interface PLCRoot : UITableViewController 
{
	NSDateFormatter *formatter;
	
	PLClass *plClass;
	UITableViewCell *textFieldCell;
	UITableViewCell *addAltCell;
}
-(IBAction)altTimeSegmentedControlChanged:(id)sender;

@property (nonatomic, assign) IBOutlet UITableViewCell *textFieldCell;
@property (nonatomic, assign) IBOutlet UITableViewCell *addAltCell;

@property (nonatomic, retain) PLClass *plClass;
@end