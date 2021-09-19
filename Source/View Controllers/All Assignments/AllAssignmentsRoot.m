//
//  AllAssignmentsRoot.m
//  Planner
//
//  Created by Kevin on 3/18/10.
//  Copyright 2010 University of Arizona. All rights reserved.
//

//Constants
#import "Constants.h"

//Headers/Views
#import "AllAssignmentsRoot.h"
#import "AllAssignmentCell.h"

#import "PLVAssignment.h"

//Other
#import "PLKit.h"

@implementation AllAssignmentsRoot

#pragma mark View Loading
-(void)viewDidLoad
{
	self.title = @"All Assignments";
	[super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{	
	//Hide the navigation item
	[self.navigationItem setHidesBackButton:YES];
	
	//Sign up for shaking notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceShaken) name:@"PLShake_Note" object:nil];
	
	//Reload
	[self.tableView reloadData];
	[super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
	initialized = NO;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark Memory Management
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	[due release];
	[pastDue release];
	[upcoming release];
	[complete release];
	
    [super dealloc];
}

#pragma mark UITableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (!initialized) {
		[self setupView];
	}
	
	switch (section) {
		case 0: //Due
		{
			return [due count];
			break;
		}
		case 1: //Past due
		{
			return [pastDue count];
			break;
		}
		case 2: //Upcoming
		{
			return [upcoming count];
			break;
		}
		case 3: //Complete
		{
			return [complete count];
			break;
		}
		default:
			break;
	}
	
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
	AllAssignmentCell *cell = (AllAssignmentCell *)[tableView dequeueReusableCellWithIdentifier:kCellSubtitle];
	
    if (cell == nil) {
        cell = [[[AllAssignmentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellSubtitle] autorelease];
    }
	
	switch (indexPath.section) 
	{
		case 0:
		{
			PLAssignment *_assn = [[due objectAtIndex:indexPath.row] objectAtIndex:0];
			PLClass *_class = [[due objectAtIndex:indexPath.row] objectAtIndex:1];
			
			cell.textLabel.text = [NSString stringWithFormat:@"%@ - %d%%", _assn.assignmentName, [_assn.completionStatus intValue]];
			cell.detailTextLabel.text = [NSString stringWithFormat:@"In Class: %@", _class.className];
			
			cell.plClass = _class;
			cell.plAssignment = _assn;
			break;
		}
		case 1:
		{
			PLAssignment *_assn = [[pastDue objectAtIndex:indexPath.row] objectAtIndex:0];
			PLClass *_class = [[pastDue objectAtIndex:indexPath.row] objectAtIndex:1];
			
			cell.textLabel.text = [NSString stringWithFormat:@"%@ - %d%%", _assn.assignmentName, [_assn.completionStatus intValue]];
			cell.detailTextLabel.text = [NSString stringWithFormat:@"In Class: %@", _class.className];
			
			cell.plClass = _class;
			cell.plAssignment = _assn;
			
			break;
		}
		case 2:
		{
			PLAssignment *_assn = [[upcoming objectAtIndex:indexPath.row] objectAtIndex:0];
			PLClass *_class = [[upcoming objectAtIndex:indexPath.row] objectAtIndex:1];
			
			cell.textLabel.text = [NSString stringWithFormat:@"%@ - %d%%", _assn.assignmentName, [_assn.completionStatus intValue]];
			cell.detailTextLabel.text = [NSString stringWithFormat:@"In Class: %@", _class.className];
			
			cell.plClass = _class;
			cell.plAssignment = _assn;
			
			break;
		}
		case 3:
		{
			PLAssignment *_assn = [[complete objectAtIndex:indexPath.row] objectAtIndex:0];
			PLClass *_class = [[complete objectAtIndex:indexPath.row] objectAtIndex:1];
			
			cell.textLabel.text = [NSString stringWithFormat:@"%@ - %d%%", _assn.assignmentName, [_assn.completionStatus intValue]];
			cell.detailTextLabel.text = [NSString stringWithFormat:@"In Class: %@", _class.className];
			
			cell.plClass = _class;
			cell.plAssignment = _assn;
			
			break;
		}
		default:
			break;
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) 
	{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	//Get the cell that was pressed
    AllAssignmentCell *cell = (AllAssignmentCell *)[self.tableView cellForRowAtIndexPath:indexPath];
	
	//Set up the view controller
	PLVAssignment *controller = [[PLVAssignment alloc] initWithStyle:UITableViewStyleGrouped];
	controller.plClass = cell.plClass;
	controller.plAssignment = cell.plAssignment;
	
	[self.navigationController pushViewController:controller animated:YES];
	
	[controller release];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		
		AllAssignmentCell *cell = (AllAssignmentCell *)[self.tableView cellForRowAtIndexPath:indexPath];
		[cell.plClass removeAssignmentWithName:cell.plAssignment.assignmentName];
		
		initialized = NO;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }  
}

#pragma mark Other Methods
-(void)deviceShaken
{
	[self.navigationController popViewControllerAnimated:NO];
}

-(void)setupView
{	
	if (!due) due = [[NSMutableArray alloc] init];
	[due removeAllObjects];
	
	if (!pastDue) pastDue = [[NSMutableArray alloc] init];
	[pastDue removeAllObjects];
	
	if (!upcoming) upcoming = [[NSMutableArray alloc] init];
	[upcoming removeAllObjects];
	
	if (!complete) complete = [[NSMutableArray alloc] init];
	[complete removeAllObjects];
	
	//We will use this to get all of the assignments
	//As it it is more efficent than calling it in cellForRow...
	PLFileManager *manager = [PLFileManager fileManager];
	NSInteger numberOfClasses = [manager numberOfClasses];
	NSMutableArray *allClasses = [NSMutableArray array];
	NSArray *filenames = [manager allClassNames:NO];
	for (int i = 0; i < numberOfClasses; i++) 
	{
		PLClass *_theClass = [[PLClass alloc] initWithClassName:[filenames objectAtIndex:i]];
		[allClasses addObject:_theClass];
		[_theClass release];
	}
	
	for (PLClass *class in allClasses)
	{
		for (NSDictionary *assn in class.assignments)
		{
			PLAssignment *assignment = [[PLAssignment alloc] initWithClass:class usingAssignment:assn];
			NSMutableArray *_assnArray = [NSArray arrayWithObjects:assignment, class, nil];
			
			switch ([assignment dueStatus]) {
				case 0: //Due
					[due addObject:_assnArray];
					break;
				case 1: //Past Due
					[pastDue addObject:_assnArray];
					break;
				case 2: //Upcoming
					[upcoming addObject:_assnArray];
					break;
				case 3: //Complete
					[complete addObject:_assnArray];
					break;
				default:
					break;
			}
			
			[assignment release];
		}
	}
	
	initialized = YES;
}

@end

