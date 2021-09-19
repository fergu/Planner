//
//  PLVCAssignment.m
//  Planner
//
//  Created by Kevin Ferguson on 7/19/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

#import "PLVCAssignmentRoot.h"

#define kNibTextFieldCellLabel 1
#define kNibTextFieldCellTextField 2

@implementation PLVCAssignmentRoot
@synthesize plClass, plAssignment, textFieldCell, textViewCell;

#pragma mark View Loading
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Create Assignment";
}

-(void)viewWillAppear:(BOOL)animated
{
	[self setLeftBarButtonItem];
	[self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kViewWillDisappearNote object:nil];
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
	[self.plAssignment release];
	[self.plClass release];
    [super dealloc];
}

#pragma mark UITableViewDelegate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	UITableViewCell *cell;
	
	switch (indexPath.section) {
		case 0:
			cell = [tableView dequeueReusableCellWithIdentifier:kCellTextField];
			break;
		case 1:
			cell = [tableView dequeueReusableCellWithIdentifier:kCellSubtitle];
			break;
		case 2:
			cell = [tableView dequeueReusableCellWithIdentifier:kCellSubtitle];
			break;
		case 3:
			cell = [tableView dequeueReusableCellWithIdentifier:kCellTextView];
			break;
		default:
			break;
	}
    if (cell == nil) {
		switch (indexPath.section) {
			case 0:
			{
				[[NSBundle mainBundle] loadNibNamed:@"PLVCAssignmentRootTextFieldCell" owner:self options:nil];
				cell = textFieldCell;
				self.textFieldCell = nil;
				break;
			}
			case 1:
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellSubtitle] autorelease];
				break;
			case 2:
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellSubtitle] autorelease];
				break;
			case 3:
			{
				[[NSBundle mainBundle] loadNibNamed:@"PLVCAssignmentRootTextViewCell" owner:self options:nil];
				cell = textViewCell;
				self.textViewCell = nil;
			}
			default:
				break;
		}
    }
    	
   switch (indexPath.section) 
	{
		case 0:
		{
			if (self.plAssignment.assignmentName)
			{
				UITextField *field = (UITextField *)[cell viewWithTag:kNibTextFieldCellTextField];
				field.text = self.plAssignment.assignmentName;
			}
			break;
		}
		case 1:
		{			
			cell.textLabel.text = @"Due Date";
			
			if (self.plAssignment.dueDate)
			{
				[cell.detailTextLabel setTextColor:[UIColor blackColor]];
				
				NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
				[formatter setDateStyle:NSDateFormatterMediumStyle];
				[formatter setTimeStyle:NSDateFormatterNoStyle];
				[formatter setDateFormat:@"EEEE MMM d, YYYY"]; //Weekday Month Day Year
				cell.detailTextLabel.text = [formatter stringFromDate:self.plAssignment.dueDate];
				[formatter release];
			}
			else
			{
				[cell.detailTextLabel setTextColor:[UIColor grayColor]];
				cell.detailTextLabel.text = @"Touch To Select";
			}
			break;
		}
		case 2:
		{			
			cell.textLabel.text = @"Reminder Setting";
			
			if (self.plAssignment.reminderSetting)
			{
				[cell.detailTextLabel setTextColor:[UIColor blackColor]];
				
				cell.detailTextLabel.text = [self.plAssignment reminderSettingAsString];
			}
			else
			{
				[cell.detailTextLabel setTextColor:[UIColor grayColor]];
				cell.detailTextLabel.text = @"Touch To Select";
			}
			break;
		}
		case 3:
		{
			UITextView *textView = (UITextView *)[cell viewWithTag:2];
			if (self.plAssignment.additionalInfo)
			{
				textView.text = self.plAssignment.additionalInfo;
			}
			else {
				textView.text = @"";
			}

		}
		default:
			break;
	}
	
	[self setLeftBarButtonItem];
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return @"Assignment Information";
			break;
		case 3:
			return @"Additional Information";
			break;
		default:
			return nil;
			break;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	switch (indexPath.section) {
		case 1: //Day Picker
		{
			PLSlideView *dateView = [[PLSlideView alloc] initWithNibName:@"PLDatePicker" inView:self.view];
			//Take ownership of the date picker
			UIDatePicker *picker = [dateView getSubviewOfClassType:[UIDatePicker class]];
			[picker addTarget:self action:@selector(datePickerDateChanged:) forControlEvents:UIControlEventValueChanged];
			[picker setDate:[NSDate date]];
			[dateView slideIn:20 disableInteraction:YES];
			[dateView release];
			break;
		}
		case 2:
		{			
			PLSlideView *reminderView = [[PLSlideView alloc] initWithNibName:@"PLPickerView" inView:self.view];
			UIPickerView *picker = [reminderView getSubviewOfClassType:[UIPickerView class]];
			[picker setDelegate:self]; [picker setDataSource:self];
			[reminderView slideIn:75 disableInteraction:YES];
			[reminderView release];
			break;
		}
		default:
			break;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 3)
		return 150;
	
	return 44;
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if ([textField.text isEqual:@""])
		self.plAssignment.assignmentName = NULL;
	else
		self.plAssignment.assignmentName = textField.text;
	
	[textField resignFirstResponder];
	[self setLeftBarButtonItem];
	return NO;
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	[self slideUp];
	return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{		
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneEditing)];
	[self.navigationItem setRightBarButtonItem:item animated:YES];
	[item release];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != 0)
	{
		[self.navigationController popViewControllerAnimated:YES];
	}
}

#pragma mark Class Methods
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSNumber *selection = [NSNumber numberWithInt:row + 8001]; //We need to add 8000 due to the naming convention
	
	self.plAssignment.reminderSetting = selection;
	[self.tableView reloadData];
}

-(void)datePickerDateChanged:(UIDatePicker *)picker
{
	NSDate *date = [picker date];
	
	NSLog(@"Date is %@", date);
	
	self.plAssignment.dueDate = date;
	[self.tableView reloadData];
}

-(void)setLeftBarButtonItem
{
	if ([self.plAssignment canSave])
	{
		UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Save" 
																   style:UIBarButtonItemStyleDone 
																  target:self 
																  action:@selector(backButtonPressed)];
		
		//We only need to animate if the button was not already "Save"
		if (![self.navigationItem.leftBarButtonItem.title isEqualToString:@"Save"])
		{
			[self.navigationItem setLeftBarButtonItem:NULL animated:YES];
			[self.navigationItem setLeftBarButtonItem:button animated:YES];
		}
		
		[button release];
	}
	else 
	{
		UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
																   style:UIBarButtonItemStyleDone 
																  target:self 
																  action:@selector(backButtonPressed)];
		
		//We only need to animate if the button was not already "Cancel"
		if (![self.navigationItem.leftBarButtonItem.title isEqualToString:@"Cancel"])
		{
			[self.navigationItem setLeftBarButtonItem:NULL animated:YES];
			[self.navigationItem setLeftBarButtonItem:button animated:YES];
		}
		
		[button release];
	}

}

-(void)backButtonPressed
{
	if ([self.navigationItem.leftBarButtonItem.title isEqual:@"Save"]) 
	{
		[self.plAssignment saveAssignment];
		[self.navigationController popViewControllerAnimated:YES];
	}
	else 
	{
		UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"Cancel" message:@"Are you sure you want to cancel?\nThe assignment will not be saved." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay", nil];
		[alert show];
		[alert release];
	}
}

-(void)doneEditing
{
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
	UITextView *view = (UITextView *)[cell viewWithTag:2];
	
	if ([view.text isEqual:@""])
		self.plAssignment.additionalInfo = NULL;
	else
		self.plAssignment.additionalInfo = view.text;
	
	[view resignFirstResponder];
	[self slideDown];
	[self.navigationItem setRightBarButtonItem:NULL animated:YES];
}

#pragma mark UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 5;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	switch (row) {
		case 0:
			return @"One Day Out"; 
			break;
		case 1:
			return @"One Week Out";
			break;
		case 2:
			return @"One Month Out";
			break;
		case 3:
			return @"Always Remind";
			break;
		case 4:
			return @"Never Remind";
			break;
		default:
			break;
	}
	return nil;
}

#pragma mark View Movement
-(void)slideUp
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    [self.view setFrame:CGRectMake(0, -215, self.view.frame.size.width, self.view.frame.size.height)];
	[UIView commitAnimations];

}

-(void)slideDown
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.30];
	[self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	[UIView commitAnimations];
}

@end

