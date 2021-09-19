//
//  RootViewController.m
//  Planner
//
//  Created by Kevin Ferguson on 7/8/09.
//  Copyright Kevin Ferguson 2009. All rights reserved.
//

//View Controllers
#import "RootViewController.h"
#import "AllAssignmentsRoot.h"
#import "PLCRoot.h"
#import "PLVRoot.h"


@implementation RootViewController
#pragma mark View Loading
-(void)viewDidLoad
{
	self.title = @"Planner";
	
	//Add the 'Add Class' button to the navigation bar
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self	action:@selector(addClass)];
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
}

- (void)viewWillAppear:(BOOL)animated 
{
	//Sign up for shaking notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceShaken) name:@"PLShake_Note" object:nil];
	
	[self.tableView reloadData];
	[super viewWillAppear:animated];
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Memory Management
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark Selectors
-(void)addClass
{
	PLCRoot *addClassView = [[PLCRoot alloc] initWithStyle:UITableViewStyleGrouped];
	[self.navigationController pushViewController:addClassView animated:YES];
	addClassView.plClass = [[[PLClass alloc] initWithClassName:@"TheName"] autorelease];
	[addClassView release];
}

#pragma mark UITableViewDataSource/UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[PLFileManager fileManager] numberOfClasses];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellValue1];
	
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellValue1] autorelease];
    }
    
	//Get the manager and the list of classes
	//Instantiate PLClass to handle operations
	PLFileManager *manager = [PLFileManager fileManager];
	NSArray *classes = [manager allClassNames:NO];
	PLClass *theClass = [[PLClass alloc] initWithClassName:[classes objectAtIndex:indexPath.row]];
	
	//Set up the cell
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = theClass.className;
	
	[theClass release];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	PLVRoot *controller = [[PLVRoot alloc] initWithStyle:UITableViewStyleGrouped];
	controller.plClass = [[PLClass alloc] initWithClassName:cell.textLabel.text];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
		//Remove the file reference
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		NSString *saveName = [cell.textLabel.text stringByReplacingOccurrencesOfString:@"/" withString:@"kFwdSlash"];
		[[NSFileManager defaultManager] removeItemAtPath:[kDocumentsFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", saveName, @".kclass"]] error:NULL];
		
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }     
}

#pragma mark Other Methods
-(void)deviceShaken
{
	AllAssignmentsRoot *controller = [[AllAssignmentsRoot alloc] initWithStyle:UITableViewStylePlain];
	[self.navigationController pushViewController:controller animated:NO];
	[controller release];
}

@end

