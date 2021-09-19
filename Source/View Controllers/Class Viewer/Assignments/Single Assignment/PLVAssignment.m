//
//  PLVAssignment.m
//  Planner
//
//  Created by Kevin Ferguson on 7/18/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

#import "PLVAssignment.h"

#import "PLVCAssignmentRoot.h"

#define kNibSliderCellLabel 1
#define kNibSliderCellSlider 2
#define kNibTextViewCellTextView 3

@implementation PLVAssignment
@synthesize plClass, plAssignment, textViewCell, sliderCell;

#pragma mark View Loading
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(enterEditMode)];
	[self.navigationItem setRightBarButtonItem:button];
	[button release];
}

-(void)viewWillAppear:(BOOL)animated
{
	self.title = self.plAssignment.assignmentName;
	[self.tableView reloadData];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	self.textViewCell = nil;
	self.sliderCell = nil;
}

#pragma mark Memory Management
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc 
{
	self.plClass = nil;
	self.plAssignment = nil;
	
    [super dealloc];
}

#pragma mark UITableViewDelegate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UITableViewCell *cell;
	
    switch (indexPath.section) 
	{
		case 0:
			cell = [tableView dequeueReusableCellWithIdentifier:kCellDefault];
			break;
		case 1:
			cell = [tableView dequeueReusableCellWithIdentifier:kCellTextView];
			break;
		case 2:
			cell = [tableView dequeueReusableCellWithIdentifier:kCellSlider];
			break;
		default:
			break;
	}
	
    if (cell == nil) 
	{
		switch (indexPath.section) 
		{
			case 0:
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellDefault] autorelease];
				break;
			case 1:
			{
				[[NSBundle mainBundle] loadNibNamed:@"PLVAssignmentTextViewCell" owner:self options:nil];
				cell = textViewCell;
				self.textViewCell = nil;
						
				break;
			}
			case 2:
			{
				[[NSBundle mainBundle] loadNibNamed:@"PLVAssignmentSliderCell" owner:self options:nil];
				cell = sliderCell;
				self.sliderCell = nil;
				break;
			}
			default:
				break;
		}
    }
	switch (indexPath.section) 
	{
		case 0:
		{
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setDateStyle:NSDateFormatterMediumStyle];
			[formatter setTimeStyle:NSDateFormatterNoStyle];
			[formatter setDateFormat:@"EEEE MMM d, YYYY"]; //Weekday Month Day Year
			cell.textLabel.text = [formatter stringFromDate:self.plAssignment.dueDate];
			[formatter release];
			break;
		}
		case 1:
		{
			UITextView *textView = (UITextView *)[cell viewWithTag:kNibTextViewCellTextView];
			
			if (self.plAssignment.additionalInfo) {
				textView.text = self.plAssignment.additionalInfo;
			}
			else {
				textView.text = @"";
			}

			break;
		}
		case 2:
		{
			UILabel *sliderLabel = (UILabel *)[cell viewWithTag:kNibSliderCellLabel];
			float completionStatus = [self.plAssignment.completionStatus floatValue];
			if (completionStatus < 5) //Not started
				[sliderLabel setText:@"Not Started"];
			else if (completionStatus > 5 && completionStatus < 95) //In progress
				[sliderLabel setText:@"In Progress"];
			else if (completionStatus > 95) //Done
				[sliderLabel setText:@"Completed"];
			
			[(UISlider *)[cell viewWithTag:kNibSliderCellSlider] setValue:completionStatus];
			[(UISlider *)[cell viewWithTag:kNibSliderCellSlider] addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
			
			break;
		}
		default:
			break;
	}
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return @"Due Date";
			break;
		case 1:
			return @"Additional Info";
			break;
		case 2:
			return @"Completion Status";
			break;
		default:
			break;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section) 
	{
		case 1:
			return 160;
			break;
		default:
			break;
	}
	return 44;
}

#pragma mark UISlider
-(void)sliderChanged:(UISlider *)slider
{
	//Get the current value
	int value = [slider value];
	
	self.plAssignment.completionStatus = [NSNumber numberWithFloat:value];
	
	[self.plAssignment saveAssignment];
	
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
	UILabel *sliderLabel = (UILabel *)[cell viewWithTag:kNibSliderCellLabel];
	
	if (value < 5) //Not started
		[sliderLabel setText:@"Not Started"];
	else if (value > 5 && value < 95) //In progress
		[sliderLabel setText:@"In Progress"];
	else if (value > 95) //Done
		[sliderLabel setText:@"Completed"];
}

#pragma mark Other Methods
-(void)enterEditMode
{
	//Create the editor
	PLVCAssignmentRoot *controller = [[PLVCAssignmentRoot alloc] initWithStyle:UITableViewStyleGrouped];
	
	controller.plClass = self.plClass;
	controller.plAssignment = self.plAssignment;
	
	[self.navigationController pushViewController:controller animated:YES];
	
	[controller release];
	
	//Remove the old entry
	[self.plClass removeAssignmentWithName:self.plAssignment.assignmentName];
}

@end

