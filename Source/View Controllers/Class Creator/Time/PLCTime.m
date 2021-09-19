//
//  PLCTime.m
//  Planner
//
//  Created by Kevin Ferguson on 7/13/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

#import "Constants.h"
#import "PLCTime.h"

@implementation PLCTime
@synthesize plClass;

#pragma mark View Loading
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.title = @"Class Time";
    }
    return self;
}

-(void)viewDidLoad
{
	//Set up a formatter we will use for displaying dates
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterNoStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	[formatter setDateFormat:kClassDateFormat];
}

-(void)viewDidAppear:(BOOL)animated
{
	//Select the top cell
	//We need to add a method to prevent the user from unselecting a cell
	[timeTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
	[(UIDatePicker *)[self.view viewWithTag:9] setDate:[NSDate date] animated:YES];
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
	[formatter release];
	
	self.plClass = nil;
	
    [super dealloc];
}

#pragma mark Methods
-(IBAction)timePicked:(UIDatePicker *)sender
{
	//Get the selected cell
	NSIndexPath *indexPath = [timeTable indexPathForSelectedRow];
	UITableViewCell *cell = [timeTable cellForRowAtIndexPath:indexPath];
	
	//Set the color to black
	cell.textLabel.textColor = [UIColor blackColor];
	
	//Set the text
	cell.textLabel.text = [formatter stringFromDate:[sender date]];
	
	//Set the property
	if (indexPath.section == 0) //Starting Time
		self.plClass.startTime = [sender date];
	else if (indexPath.section == 1) //Ending Time
		self.plClass.endTime = [sender date];
}

#pragma mark UITableViewDataSource/UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellDefault];
	
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellDefault] autorelease];
    }
	
	
	//Cell Settings
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	
	switch (indexPath.section) 
	{
		case 0: //Starting Time
		{
			if (self.plClass.startTime)
			{
				cell.textLabel.textColor = [UIColor blackColor];
				cell.textLabel.text = [formatter stringFromDate:self.plClass.startTime];
			}
			else
			{
				cell.textLabel.textColor = [UIColor grayColor];
				cell.textLabel.text = @"Starting Time";
			}
			
			break;
		}
		case 1: //Ending Time
		{
			if (self.plClass.startTime)
			{
				cell.textLabel.textColor = [UIColor blackColor];
				cell.textLabel.text = [formatter stringFromDate:self.plClass.endTime];
			}
			else
			{
				cell.textLabel.textColor = [UIColor grayColor];
				cell.textLabel.text = @"Ending Time";
			}
		}
		default:
			break;
	}
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) 
	{
		case 0:
			return @"Starting Time";
			break;
		case 1:
			return @"Ending Time";
			break;
		default:
			break;
	}
	return nil;
}

@end
