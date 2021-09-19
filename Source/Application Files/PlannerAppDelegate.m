//
//  PlannerAppDelegate.m
//  Planner
//
//  Created by Kevin Ferguson on 7/8/09.
//  Copyright Kevin Ferguson 2009. All rights reserved.
//

#import "Constants.h"
#import "PlannerAppDelegate.h"
#import "RootViewController.h"


@implementation PlannerAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber *lastVersion = [defaults objectForKey:@"LastVersion"];
	
	if (!lastVersion || [lastVersion intValue] < 200)
	{		
		NSNumber *version = lastVersion;
		if (!version) version = [NSNumber numberWithInt:191];
		
		[self runUpdaterFromVersion:version];
	}
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}

#pragma mark Error Handler
-(void)unhandledErrorLogging
{
}

#pragma mark Other Methods
-(void)runUpdaterFromVersion:(NSNumber *)version
{
	if ([version intValue] < 200) 
	{
		kDLog(@"Updating from earlier than 2.0");
		
		NSFileManager *manager = [NSFileManager defaultManager];
		
		NSString *_docPath = kDocumentsFolder;
		NSArray *_contents = [manager contentsOfDirectoryAtPath:_docPath error:NULL];
		
		NSLog(@"Contents are %@", _contents);
		for (NSString *filename in _contents) {
			[manager removeItemAtPath:[_docPath stringByAppendingPathComponent:filename] error:NULL];
		}
		
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:200] forKey:@"LastVersion"];
		
		if ([_contents count] > 0)
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Updated" message:@"Thank you for updating to Planner 2.\nDue to the update, your classes and assignments were lost.\nWe apologize for the inconvenience" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}
	if ([version intValue] < 201)
	{
		kDLog(@"Updating from earlier than 2.01");
		
		[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:201] forKey:@"LastVersion"];
		
	}
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

