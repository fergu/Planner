//
//  PLClass.m
//  Planner
//
//  Created by Kevin Ferguson on 7/8/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

#import "Constants.h"
#import "PLClass.h"
#import "PLAssignment.h"

//Class Object Definitions
#define kClassName					@"Name" //The Name of the class
#define kClassLocation				@"Location" //The location that the class meets
#define kClassAdditionalInfo		@"Additional Info" //Additional Information about the class
#define kStartTime					@"Starting Time" //The time the class starts
#define kEndTime					@"Ending Time" //The time the class ends
#define kDaysOfWeek					@"Days of Week" //The days of the week that the class meets
#define kClassAssignments			@"Assignments"

@implementation PLClass
@synthesize classDictionary, className, classLocation, additionalInfo, startTime, endTime, daysOfWeek, assignments;

#pragma mark Initialization
-(id)initWithClassName:(NSString *)name
{
	NSString *saveName = [name stringByReplacingOccurrencesOfString:@"/" withString:@"kFwdSlash"];
	
	self.classDictionary =	[NSMutableDictionary dictionaryWithContentsOfFile:[kDocumentsFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", saveName, @".kclass"]]];
	self.className =		[self.classDictionary objectForKey:kClassName];
	self.classLocation =	[self.classDictionary objectForKey:kClassLocation];
	self.additionalInfo =	[self.classDictionary objectForKey:kClassAdditionalInfo];
	self.startTime =		[self.classDictionary objectForKey:kStartTime];
	self.endTime =			[self.classDictionary objectForKey:kEndTime];
	self.daysOfWeek =		[self.classDictionary objectForKey:kDaysOfWeek];
	self.assignments =		[self.classDictionary objectForKey:kClassAssignments];
	
	//If the days of week array is nil, we need to create it
	if (!self.daysOfWeek)
		self.daysOfWeek = [NSMutableArray array];
	
	return self;
}

-(void)dealloc
{
	kWLog(@"PLClass Dealloc");
	
	self.classDictionary = nil;
	self.className = nil;
	self.classLocation = nil;
	self.additionalInfo = nil;
	self.startTime = nil;
	self.endTime = nil;
	self.daysOfWeek = nil;
	self.assignments = nil;
	
	[super dealloc];
}

#pragma mark Loading
-(void)reloadFromFile
{
	//This method resets properties to the value from the file	
	self.classDictionary =	[NSMutableDictionary dictionaryWithContentsOfFile:[kDocumentsFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", self.className, @".kclass"]]];
	self.className =		[self.classDictionary objectForKey:kClassName];
	self.classLocation =	[self.classDictionary objectForKey:kClassLocation];
	self.additionalInfo =	[self.classDictionary objectForKey:kClassAdditionalInfo];
	self.startTime =		[self.classDictionary objectForKey:kStartTime];
	self.endTime =			[self.classDictionary objectForKey:kEndTime];
	self.daysOfWeek =		[self.classDictionary objectForKey:kDaysOfWeek];
	self.assignments =		[self.classDictionary objectForKey:kClassAssignments];
}

#pragma mark Saving
-(BOOL)canSave
{
	//If all properties are set, we can save
	if (self.className && self.classLocation && self.startTime && self.endTime && [self.daysOfWeek count] > 0)
		return YES;

	return NO;
}

-(void)saveToFile
{
	//Prevent this method from running if we can't save
	if (![self canSave])
		return;
	
	if (!self.additionalInfo)
		self.additionalInfo = @" ";
	
	
	NSMutableDictionary *_retDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.className, kClassName, 
							  self.classLocation, kClassLocation, 
							  self.startTime, kStartTime,
							  self.endTime, kEndTime,
							  self.daysOfWeek, kDaysOfWeek, 
							  self.additionalInfo, kClassAdditionalInfo, 
							  self.assignments, kClassAssignments,
							  nil];
	
	NSString *saveName = [self.className stringByReplacingOccurrencesOfString:@"/" withString:@"kFwdSlash"];
	[_retDict writeToFile:[kDocumentsFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", saveName, @".kclass"]] atomically:YES];
}

-(void)addAssignment:(PLAssignment *)assignment
{
	if (!self.assignments)
		self.assignments = [NSMutableDictionary dictionary];
	
	[self.assignments removeObjectForKey:assignment.assignmentName];
	[self.assignments setObject:[assignment dictionaryRepresentation] forKey:assignment.assignmentName];
	
	[self saveToFile];
	[self reloadFromFile];
}

-(void)removeAssignmentWithName:(NSString *)assnName
{
	//Remove the assignment from the assignment dictionary
	[self.assignments removeObjectForKey:assnName];
	
	//Commit the changes to file
	[self saveToFile];
}

#pragma mark Convenience
-(NSString *)daysOfWeekAsString:(NSArray *)usingArray
{
	//This is a method to return the daysOfWeek array (Normally an array of NSNumbers) as a string
	NSMutableArray *_array = [NSMutableArray array];
	NSArray *_weekdays = [NSArray arrayWithObjects:@"Mon", @"Tues", @"Weds", @"Thurs", @"Fri", @"Sat", @"Sun", nil];
	
	//Sort the array so we are sure to do this in order
	usingArray = [usingArray sortedArrayUsingSelector:@selector(compare:)];
		
	for (int i = 0; i < [usingArray count]; i++)
	{
		NSNumber *currentNumber = [usingArray objectAtIndex:i];
		[_array addObject:[_weekdays objectAtIndex:[currentNumber intValue]]];
	}
	
	return [_array componentsJoinedByString:@", "];
}

-(NSString *)classTimesAsString:(NSDate *)startingTime endTime:(NSDate *)endingTime
{
	//Set up a formatter we will use for displaying dates
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterNoStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	[formatter setDateFormat:kClassDateFormat];
	
	NSString *_retString = [NSString stringWithFormat:@"%@ to %@", [formatter stringFromDate:startingTime], [formatter stringFromDate:endingTime]];
	
	[formatter release];
	return _retString;
}
@end
