//
//  PLVAssignments.m
//  Planner
//
//  Created by Kevin Ferguson on 7/17/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

#import "Constants.h"
#import "PLVAssignments.h"
#import "PLVAssignment.h"
#import "PLVCAssignmentRoot.h"

@implementation PLVAssignments
@synthesize plClass;

#pragma mark View Loading
- (void)viewDidLoad 
{
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self	action:@selector(addAssignment)];
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
	
    [super viewDidLoad];
	self.title = @"Assignments";
}

-(void)viewWillAppear:(BOOL)animated
{
	[self.tableView reloadData];
}

#pragma mark Memory Management
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	self.plClass = nil;
	
    [super dealloc];
}

#pragma mark Methods
-(void)addAssignment
{
	PLVCAssignmentRoot *controller = [[PLVCAssignmentRoot alloc] initWithStyle:UITableViewStyleGrouped];
	PLAssignment *assignment = [[PLAssignment alloc] initWithClass:self.plClass usingAssignment:nil];
	
	controller.plClass = self.plClass;
	controller.plAssignment = assignment;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	[assignment release];
}

#pragma mark UITableViewDelegate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	NSArray *assignments = [self.plClass.assignments allKeys];
	NSMutableArray *_array = [NSMutableArray array];
	int i = 0;
	
    if (section == 0)
	{	
		for (i = 0; i < [assignments count]; i++) 
		{
			PLAssignment *theAssign = [[PLAssignment alloc] initWithClass:self.plClass usingAssignment:[assignments objectAtIndex:i]];
			if ([self dueStatusForAssignment:theAssign] == 0)
				[_array addObject:theAssign];
			
			[theAssign release];
		}
	}
	else if (section == 1)
	{	
		for (i = 0; i < [assignments count]; i++) 
		{
			PLAssignment *theAssign = [[PLAssignment alloc] initWithClass:self.plClass usingAssignment:[assignments objectAtIndex:i]];
			if ([self dueStatusForAssignment:theAssign] == 1)
				[_array addObject:theAssign];
			
			[theAssign release];
		}
	}
	else if (section == 2)
	{
		for (i = 0; i < [assignments count]; i++) 
		{
			PLAssignment *theAssign = [[PLAssignment alloc] initWithClass:self.plClass usingAssignment:[assignments objectAtIndex:i]];
			if ([self dueStatusForAssignment:theAssign] == 2)
				[_array addObject:theAssign];
			
			[theAssign release];
		}
	}
	else if (section == 3)
	{
		for (i = 0; i < [assignments count]; i++) 
		{
			PLAssignment *theAssign = [[PLAssignment alloc] initWithClass:self.plClass usingAssignment:[assignments objectAtIndex:i]];

			if ([self dueStatusForAssignment:theAssign] == 3)
				[_array addObject:theAssign];
			
			[theAssign release];
		}
	}
	
	return [_array count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellValue1];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellValue1] autorelease];
    }
    	
	NSArray *assignments = [self.plClass.assignments allKeys];
	
	NSMutableArray *_array = [NSMutableArray array];
	int i = 0;
	
	if (indexPath.section == 0)
	{		
		for (i = 0; i < [assignments count]; i++) 
		{
			PLAssignment *theAssign = [[PLAssignment alloc] initWithClass:self.plClass usingAssignment:[assignments objectAtIndex:i]];
			if ([self dueStatusForAssignment:theAssign] == 0)
				[_array addObject:theAssign];
			
			[theAssign release];
		}
	}
	else if (indexPath.section == 1)
	{	
		for (i = 0; i < [assignments count]; i++) 
		{
			PLAssignment *theAssign = [[PLAssignment alloc] initWithClass:self.plClass usingAssignment:[assignments objectAtIndex:i]];
			if ([self dueStatusForAssignment:theAssign] == 1)
				[_array addObject:theAssign];
			
			[theAssign release];
		}
	}
	else if (indexPath.section == 2)
	{
		for (i = 0; i < [assignments count]; i++) 
		{
			PLAssignment *theAssign = [[PLAssignment alloc] initWithClass:self.plClass usingAssignment:[assignments objectAtIndex:i]];			
			if ([self dueStatusForAssignment:theAssign] == 2)
				[_array addObject:theAssign];
			
			[theAssign release];
		}
	}
	else if (indexPath.section == 3)
	{
		for (i = 0; i < [assignments count]; i++) 
		{
			PLAssignment *theAssign = [[PLAssignment alloc] initWithClass:self.plClass usingAssignment:[assignments objectAtIndex:i]];
			if ([self dueStatusForAssignment:theAssign] == 3)
				[_array addObject:theAssign];
			
			[theAssign release];
		}
	}

	PLAssignment *assn = [_array objectAtIndex:indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = assn.assignmentName;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%d%%", [assn.completionStatus intValue]];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	NSString *assignmentName = cell.textLabel.text;
		
	PLAssignment *assn = [[PLAssignment alloc] initWithClass:self.plClass usingAssignment:assignmentName];
	
	PLVAssignment *controller = [[PLVAssignment alloc] initWithStyle:UITableViewStyleGrouped];
	controller.plClass = self.plClass;
	controller.plAssignment = assn;
	
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	[assn release];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return @"Due";
			break;
		case 1:
			return @"Past Due";
			break;
		case 2:
			return @"Upcoming";
			break;
		case 3:
			return @"Completed Assignments";
			break;
		default:
			return nil;
			break;
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
		//Remove the assignment being referred to
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		NSString *assignmentName = cell.textLabel.text;
		
		[self.plClass removeAssignmentWithName:assignmentName];
		//Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
}

#pragma mark Other
-(NSInteger)dueStatusForAssignment:(PLAssignment *)assignment
{
	//Return 0 for due
	//Return 1 for past due
	//Return 2 for upcoming
	//Return 3 for completed
	
	NSNumber *reminderSetting = assignment.reminderSetting;
	NSDate *dueDate = assignment.dueDate;
	NSDate *today = [NSDate date];
	
	//8001 = day
	//8002 = week
	//8003 = month
	//8004 = always
	//8005 = never
	
	//Start off by eliminating the case of the assignment being completed
	//Or the assignment being past due
	
	//Check if the assignment is completed
	if ([assignment.completionStatus intValue] > 95)
		return 3;
	
	//Check if we are past the due date
	if ([today earlierDate:dueDate] == dueDate)
		return 1;
	
	//If the assignment is not overdue or complete, we need to see what its status is
	switch ([reminderSetting intValue]) {
		case 8001:
		{
			NSDate *tomorrow = [today addTimeInterval:60*60*24];
			
			if ([tomorrow earlierDate:dueDate] == dueDate)
			{
				return 0;
			}
			
			if ([tomorrow earlierDate:dueDate] == tomorrow)
			{
				return 2;
			}
			
			kWLog(@"Did not return from -dueStatusForAssignment:8001");

			break;
		}
		case 8002:
		{			
			NSDate *weekOut = [today addTimeInterval:60*60*24*7];
			if ([weekOut earlierDate:dueDate] == dueDate)
				return 0;
			
			if ([weekOut earlierDate:dueDate] == weekOut)
				return 2;
			
			kWLog(@"Did not return from -dueStatusForAssignment:8002");
			break;
		}
		case 8003:
		{			
			NSDate *monthOut = [today addTimeInterval:60*60*24*7*31];
			if ([monthOut earlierDate:dueDate] == dueDate)
				return 0;
			
			if ([monthOut earlierDate:dueDate] == monthOut)
				return 2;
			
			kWLog(@"Did not return from -dueStatusForAssignment:8003");
			break;
		}
		case 8004:
		{			
			return 0;
			
			break;
		}
		case 8005:
		{			
			return 2;
			
			break;
		}
			
		default:
			break;
	}
	
	
	return 0;
}

@end

