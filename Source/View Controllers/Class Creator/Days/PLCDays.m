//
//  PLCreatorDays.m
//  Planner
//
//  Created by Kevin Ferguson on 7/10/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

#import "Constants.h"
#import "PLCDays.h"

#define kNibSwtchCellSwitch 1
#define kNibSwtchCellLabel 2

@implementation PLCDays
@synthesize plClass, switchCell;
#pragma mark View Loading
- (void)viewDidLoad 
{
	self.title = @"On Days";
    [super viewDidLoad];
}

- (void)viewDidUnload {
	[self.switchCell release];
}

#pragma mark Memory Management
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	self.plClass = nil;
	
    [super dealloc];
}

#pragma mark Methods
-(IBAction)daySwitchFlipped:(UISwitch *)sender
{
	UITableViewCell *_cell;
	
	//Get the cell and switch that were touched (We need to update the cell)
	for (int i = 0; i < 7; i++)
	{
		_cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
		UISwitch *_switch = (UISwitch *)[_cell viewWithTag:kNibSwtchCellSwitch];
		
		if (sender == _switch)
		{
			_switch = nil;
			break;
		}
		else 
		{
			_cell = nil;
			_switch = nil;
		}
	}
	
	
	NSIndexPath *indexPath = [self.tableView indexPathForCell:_cell]; //We use this to get a row
	if (sender.on) //If the switch was flipped to the on state, we add the row index to the days array
	{
		//Set the accessory view
		_cell.accessoryType = UITableViewCellAccessoryCheckmark;
		//Save the switch value
		[self.plClass.daysOfWeek addObject:[NSNumber numberWithInt:indexPath.row]];
	}
	else
	{
		//Set the accessory view
		_cell.accessoryType = UITableViewCellAccessoryNone;
		//Save the switch value
		[self.plClass.daysOfWeek removeObject:[NSNumber numberWithInt:indexPath.row]];
	}
	
	//And update the cell
	[_cell setNeedsDisplay];
}

#pragma mark UITableViewDataSource/UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 7;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellSwitch];
	
    if (cell == nil) 
	{
		[[NSBundle mainBundle] loadNibNamed:@"PLCDaysSwitchCell" owner:self options:nil];
		cell = switchCell;
		self.switchCell = nil;
    }
	
	NSArray *_weekdays = [NSArray arrayWithObjects:@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday", nil];
	
	[(UILabel *)[cell viewWithTag:kNibSwtchCellLabel] setText:[_weekdays objectAtIndex:indexPath.row]];
	
	if ([self.plClass.daysOfWeek containsObject:[NSNumber numberWithInt:indexPath.row]])
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		[(UISwitch *)[cell viewWithTag:kNibSwtchCellSwitch] setOn:YES];
	}
	else
	{
		cell.accessoryType = UITableViewCellAccessoryNone;
		[(UISwitch *)[cell viewWithTag:kNibSwtchCellSwitch] setOn:NO];
	}
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Days";
}

@end

