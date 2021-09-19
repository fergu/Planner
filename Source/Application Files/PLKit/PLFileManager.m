//
//  PLFileManager.m
//  Planner
//
//  Created by Kevin Ferguson on 7/8/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

#import "Constants.h"

#import "PLFileManager.h"


@implementation PLFileManager
#pragma mark Initializers
+(id)fileManager //This is a conveinence method to return an autoreleased instance of this class
{
	return [[[self alloc] init] autorelease];
}

#pragma mark File Operators
#pragma mark Class Operators
-(NSArray *)allClassNames:(BOOL)asFilename //This returns an array of class names, optionally as filenames
{
	//Get all of the contents of the documents directory
	NSArray *allClassesArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:kDocumentsFolder error:nil];
	NSMutableArray *allClasses = [[allClassesArr mutableCopy] autorelease]; //This makes the array mutable (able to be edited)
	
	//Filter out all non class files
	for (int i = 0; i < [allClasses count]; i++)
	{
		if (![[allClasses objectAtIndex:i] hasSuffix:@".kclass"])
			[allClasses removeObjectAtIndex:i];
	}
	
	//If the method wants the result as filenames, we can return here
	if (asFilename)
		return allClasses;
	
	//If not, we need to cycle through one more time to remove them
	for (int k = 0; k < [allClasses count]; k++)
	{
		[allClasses replaceObjectAtIndex:k 
							  withObject:[[allClasses objectAtIndex:k] stringByReplacingOccurrencesOfString:@".kclass" withString:@""]];
	}
	
	//Return the array
	return allClasses;
}

-(NSInteger)numberOfClasses //This just returns the count of the allClassNames: method
{
	return [[self allClassNames:YES] count];
}
@end
