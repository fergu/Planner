//
//  PLCreatorDays.h
//  Planner
//
//  Created by Kevin Ferguson on 7/10/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLKit.h"

@interface PLCDays : UITableViewController 
{
	//The class being used
	PLClass *plClass;
	
	//Custom Table View Cells
	//UITableViewCell *segmentedCell;
	UITableViewCell *switchCell;
}
//Methods
-(IBAction)daySwitchFlipped:(UISwitch *)sender;

//Properties
@property (nonatomic, retain) PLClass *plClass;
@property (nonatomic, assign) IBOutlet UITableViewCell *switchCell;
@end