//
//  PLCTime.h
//  Planner
//
//  Created by Kevin Ferguson on 7/13/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLKit.h"

@interface PLCTime : UIViewController 
{
	NSDateFormatter *formatter;
	
	PLClass *plClass; //The class we are using
	
	IBOutlet UITableView *timeTable;
}

//Methods
-(IBAction)timePicked:(UIDatePicker *)sender;

//Properties
@property (nonatomic, retain) PLClass *plClass;
@end
