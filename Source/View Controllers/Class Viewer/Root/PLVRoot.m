//
//  PLVRoot.m
//  Planner
//
//  Created by Kevin Ferguson on 7/16/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

#import "Constants.h"

//View Controllers
#import "PLVRoot.h"
#import "PLVAssignments.h"
#import "PLCRoot.h"

#define kNibClassInfoCellTimeLabel 1
#define kNibClassInfoCellLocationLabel 2
#define kNibClassInfoCellDaysLabel 3
#define kNibClassInfoCellTextView 4
@implementation PLVRoot
@synthesize plClass, classInfoCell, textViewCell;

#pragma mark View Loading
-(void)viewDidLoad
{	
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(enterEditMode)];
	[self.navigationItem setRightBarButtonItem:button];
	[button release];
}

-(void)viewWillAppear:(BOOL)animated
{
	self.title = self.plClass.className;
	[self.tableView reloadData];
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
	[self.plClass release];
    [super dealloc];
}

#pragma mark UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell;
	
	switch (indexPath.section) {
		case 0:
			cell = [tableView dequeueReusableCellWithIdentifier:kCellValue1];
			break;
		case 1:
			cell = [tableView dequeueReusableCellWithIdentifier:kCellClassInfo];
			break;
		case 2:
			cell = [tableView dequeueReusableCellWithIdentifier:kCellDefault];
			break;
		case 3:
			cell = [tableView dequeueReusableCellWithIdentifier:kCellTextView];
			break;
		default:
			break;
	}
	
    if (cell == nil) 
	{
		switch (indexPath.section) {
			case 0:
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellValue1] autorelease];
				break;
			case 1:
			{
				[[NSBundle mainBundle] loadNibNamed:@"PLVRootClassInfoCell" owner:self options:nil];
				cell = classInfoCell;
				self.classInfoCell = nil;
				break;
			}
			case 2:
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellDefault] autorelease];
				break;
			case 3:
			{
				[[NSBundle mainBundle] loadNibNamed:@"PLVRootTextViewCell" owner:self options:nil];
				cell = textViewCell;
				self.textViewCell = nil;
				break;
			}
			default:
				break;
		}
    }
    
	switch (indexPath.section) {
		case 0: //Class Name
		{
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.text = @"Class Name:";
			cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
			cell.detailTextLabel.textColor = [UIColor blackColor];
			cell.detailTextLabel.text = self.plClass.className;
			break;
		}
		case 1: //General Info
		{
			[(UILabel *)[cell viewWithTag:kNibClassInfoCellTimeLabel] setText:[self.plClass classTimesAsString:self.plClass.startTime endTime:self.plClass.endTime]];
			[(UILabel *)[cell viewWithTag:kNibClassInfoCellDaysLabel] setText:[self.plClass daysOfWeekAsString:self.plClass.daysOfWeek]];
			[(UILabel *)[cell viewWithTag:kNibClassInfoCellLocationLabel] setText:self.plClass.classLocation];
			break;
		}
		case 2: //Assignments
		{
			cell.textLabel.text = @"Assignments";
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		case 3: //Additional Info
		{
			[(UITextView *)[cell viewWithTag:kNibClassInfoCellTextView] setFrame:[[cell contentView] frame]];
			[(UITextView *)[cell viewWithTag:kNibClassInfoCellTextView] setText:self.plClass.additionalInfo];
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
			return @"Class Name";
			break;
		case 1:
			return @"Meeting Information";
			break;
		case 2:
			return @"Assignments";
			break;
		case 3:
			return @"Additional Information";
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
			return 73;
			break;
		case 3:
			return 160;
			break;
		default:
			break;
	}
	return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PLVAssignments *controller = [[PLVAssignments alloc] initWithStyle:UITableViewStylePlain];
	controller.plClass = self.plClass;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

#pragma mark Other Methods
-(void)enterEditMode
{
	//Create the editor
	PLCRoot *controller = [[PLCRoot alloc] initWithStyle:UITableViewStyleGrouped];
	
	controller.plClass = self.plClass;
	
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	
	//Remove the file reference
	NSString *saveName = [self.plClass.className stringByReplacingOccurrencesOfString:@"/" withString:@"kFwdSlash"];
	[[NSFileManager defaultManager] removeItemAtPath:[kDocumentsFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", saveName, @".kclass"]] error:NULL];
}

@end

