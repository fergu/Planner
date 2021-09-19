//
//  PLCreatorRoot.m
//  Planner
//
//  Created by Kevin Ferguson on 7/15/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

#import "Constants.h"

//View Controllers
#import "PLCRoot.h"
#import "PLCTime.h"
#import "PLCDays.h"
#import "PLCAdditionalInfo.h"

#define kNibTextCellLabel 1
#define kNibTextCellTextField 2
#define kNibAltCellSegCtrl 3

@implementation PLCRoot
@synthesize plClass, textFieldCell, addAltCell;

#pragma mark View Loading
- (id)initWithStyle:(UITableViewStyle)style 
{
    if (self = [super initWithStyle:style]) 
	{
		self.title = @"New Class"; //The title shown in the Navigation Bar
    }
    return self;
}

-(void)viewDidLoad {
	//Set up a formatter we will use for displaying dates
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterNoStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	[formatter setDateFormat:kClassDateFormat];
}

-(void)viewWillAppear:(BOOL)animated
{
	//Determine what the back bar item needs to be
	UIBarButtonItem *backItem;
	
	if ([self.plClass canSave])
		backItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonPressed)];
	else
		backItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonPressed)];
	
	self.navigationItem.leftBarButtonItem = backItem;
	[backItem release];
	
	[self.tableView reloadData];
}

#pragma mark Memory Management
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	[formatter release];
	
	self.plClass = nil;
	self.textFieldCell = nil;
	self.addAltCell = nil;
    [super dealloc];
}

#pragma mark Methods
-(void)backButtonPressed
{
	if ([self.navigationItem.leftBarButtonItem.title isEqual:@"Save"]) //Save the class
	{
		[self.plClass saveToFile];
		[self.navigationController popViewControllerAnimated:YES];
	}
	else //Display an alert to cancel class creation
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cancel" message:@"Are you sure you want to cancel?\nThe class will not be saved." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay", nil];
		[alert show];
		[alert release];
	}
}

-(IBAction)altTimeSegmentedControlChanged:(id)sender
{
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
	
	if ([sender selectedSegmentIndex] == 0) //YES
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	else
		cell.accessoryType = UITableViewCellAccessoryNone;
	
	[cell setNeedsDisplay];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1)
		[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField 
{
	//Get references to the text fields so we can determine which field is ending editing
	UITextField *classNameTextField = (UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] viewWithTag:kNibTextCellTextField];
	UITextField *classLocationTextField = (UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] viewWithTag:kNibTextCellTextField];
	
	if (textField == classNameTextField) //If the text field is the one in the class name cell
	{
		if (classNameTextField.text)
			self.plClass.className = textField.text;
		else
			self.plClass.className = nil;
	}
	else if (textField == classLocationTextField) //If the text field is the one in the class location cell
	{
		if (classLocationTextField.text)
			self.plClass.classLocation = textField.text;
		else
			self.plClass.classLocation = nil;
	}
	
	//Determine what the back bar item needs to be
	UIBarButtonItem *leftItem;
	
	if ([self.plClass canSave])
		leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonPressed)];
	else
		leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonPressed)];
	
	//Only change the left item if it's not the same as it was
	if (![[self.navigationItem.leftBarButtonItem title] isEqual:[leftItem title]])
		[self.navigationItem setLeftBarButtonItem:leftItem animated:YES];
	[leftItem release];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark UITableViewDataSource/UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) 
	{
		case 0:
			return 2;
			break;
		case 1:
			return 2;
			break;
		case 2:
			return 1;
			break;
		default:
			break;
	}
	
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
    UITableViewCell *cell;
	switch (indexPath.section) 
	{
		case 0:
			cell = [tableView dequeueReusableCellWithIdentifier:kCellTextField];
			break;
		case 2:
			cell = [tableView dequeueReusableCellWithIdentifier:kCellDefault];
			break;
		default:
			cell = [tableView dequeueReusableCellWithIdentifier:kCellSubtitle];
			break;
	}
	
    if (cell == nil) {
		switch (indexPath.section) {
			case 0:
			{
				[[NSBundle mainBundle] loadNibNamed:@"PLCRootTextFieldCell" owner:self options:nil];
				cell = textFieldCell;
				self.textFieldCell = nil;
				break;
			}
			case 2:
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellDefault] autorelease];
				break;
			default:
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellSubtitle] autorelease];
				break;
		}
    }
    
	switch (indexPath.section) 
	{
		case 0: //Class Information
		{
			
			if (indexPath.row == 0) //Class Name
			{
				[(UILabel *)[cell viewWithTag:kNibTextCellLabel] setText:@"Class Name:"];
				
				//Populate the text field if we know the name of the class
				if (self.plClass.className)
					[(UITextField *)[cell viewWithTag:kNibTextCellTextField] setText:self.plClass.className];
			}
			else if (indexPath.row == 1) //Class Location
			{
				[(UILabel *)[cell viewWithTag:kNibTextCellLabel] setText:@"Class Location:"];
				
				//Populate the text field if we know the location of the class
				if (self.plClass.classLocation)
					[(UILabel *)[cell viewWithTag:kNibTextCellTextField] setText:self.plClass.classLocation];
			}
			
			break;
		}
		case 1: //Schedule Information
		{
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			
			if (indexPath.row == 0) //Class Name
			{
				cell.textLabel.text = @"Time:";
				
				//Display the cell differently if the class time vars are set
				if (!self.plClass.startTime && !self.plClass.endTime)
				{
					cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
					cell.detailTextLabel.textColor = [UIColor grayColor];
					cell.detailTextLabel.text = @"Start to End";
				}
				else
				{
					cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
					cell.detailTextLabel.textColor = [UIColor blackColor];
					cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ to %@", [formatter stringFromDate:self.plClass.startTime], [formatter stringFromDate:self.plClass.endTime]];
				}
			}
			else if (indexPath.row == 1) //Class Location
			{
				cell.textLabel.text = @"On Days:";
				
				//Display the cell differently if the class days var is set
				if ([self.plClass.daysOfWeek count] < 1)
				{
					cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
					cell.detailTextLabel.textColor = [UIColor grayColor];
					cell.detailTextLabel.text = @"Select Days";
				}
				else
				{
					cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
					cell.detailTextLabel.textColor = [UIColor blackColor];
					cell.detailTextLabel.text = [self.plClass daysOfWeekAsString:self.plClass.daysOfWeek];
				}
			}
			
			break;
		}
		case 2: //Additional Information
		{
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.textLabel.text = @"Additional Information";
		}
		default:
			break;
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) 
	{
		case 0:
		{
			UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
			//Select the text field in the cell
			[[(UITextField *)cell viewWithTag:kNibTextCellTextField] becomeFirstResponder];
			break;
		}
		case 1:
		{
			if (indexPath.row == 0)
			{
				PLCTime *controller = [[PLCTime alloc] initWithNibName:@"PLCTime" bundle:nil];
				controller.plClass = self.plClass;
				[self.navigationController pushViewController:controller animated:YES];
				[controller release];
			}
			else if (indexPath.row == 1)
			{
				PLCDays *controller = [[PLCDays alloc] initWithStyle:UITableViewStyleGrouped];
				controller.plClass = self.plClass;
				[self.navigationController pushViewController:controller animated:YES];
				[controller release];
			}
			break;
		}
		case 2:
		{
			PLCAdditionalInfo *controller = [[PLCAdditionalInfo alloc] initWithNibName:@"PLCAdditionalInfo" bundle:nil];
			controller.plClass = self.plClass;
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
		}
		default:
			break;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return @"Class Information";
			break;
		case 1:
			return @"Sechedule Information";
			break;
		case 2:
			return @"Additional Information:";
			break;
		default:
			break;
	}
	return nil;
}

@end

