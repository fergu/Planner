//
//  PLAssignment.m
//  Planner
//
//  Created by Kevin Ferguson on 7/19/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

#import "Constants.h"
#import "PLAssignment.h"

//Assignment Object Definitions
#define kAssignmentName							@"Name"
#define kAssignmentDueDate						@"Date Due"
#define kAssignmentReminderSetting				@"Reminder Setting"
#define kAssignmentAdditionalInfo				@"Additional Info"
#define kAssignmentCompletionStatus				@"Completion Status"

//Assignment completion settings
#define kAssignmentCompletionStatusNotStarted	4001
#define kAssignmentCompletionStatusInProgress	4002
#define kAssignmentCompletionStatusDone			4003

//Reminder Status
#define kAssignmentReminderOneDay				8001
#define kAssignmentReminderOneWeek				8002
#define kAssignmentReminderOneMonth				8003
#define kAssignmentReminderAlways				8004
#define kAssignmentReminderNone					8005

@implementation PLAssignment
@synthesize plClass, assignmentName, additionalInfo, reminderSetting, dueDate, completionStatus;

-(id)initWithClass:(PLClass *)theClass usingAssignment:(id)nameOrDict
{
	self.plClass = theClass;
		
	NSDictionary *assignment = nameOrDict;
	
	if ([nameOrDict isKindOfClass:[NSString class]]) 
	{
		kDLog(@"Fetching Assignment using string");
		assignment = [self.plClass.assignments objectForKey:nameOrDict];
	}
	
	self.assignmentName = [assignment objectForKey:kAssignmentName];
	self.additionalInfo = [assignment objectForKey:kAssignmentAdditionalInfo];
	self.dueDate = [assignment objectForKey:kAssignmentDueDate];
	self.completionStatus = [assignment objectForKey:kAssignmentCompletionStatus];
	self.reminderSetting = [assignment objectForKey:kAssignmentReminderSetting];
	
	if (!self.reminderSetting) {
		self.reminderSetting = [NSNumber numberWithInt:kAssignmentReminderOneWeek];
		
	}
	return self;
}

#pragma mark Saving
-(BOOL)canSave
{
	if (self.plClass && self.assignmentName && self.dueDate && self.reminderSetting)
		return YES;
	
	return NO;
}

-(void)saveAssignment
{
	//Prevent this method from running if we cannot save
	if (![self canSave])
		return;
	
	[self.plClass addAssignment:self];
}

#pragma mark Other Methods
-(NSString *)reminderSettingAsString
{
	//We have to use -intValue because we need objects
	//To store, but integers for comparison
	switch ([self.reminderSetting intValue]) {
		case kAssignmentReminderOneDay:
			return @"One Day Out";
			break;
		case kAssignmentReminderOneWeek:
			return @"One Week Out";
			break;
		case kAssignmentReminderOneMonth:
			return @"One Month Out";
			break;
		case kAssignmentReminderNone:
			return @"No Reminder";
			break;
		case kAssignmentReminderAlways:
			return @"Always";
			break;
		default:
			return @"One Week Out";
			break;
	}
}

-(NSDictionary *)dictionaryRepresentation
{
	if (!self.completionStatus) {
		self.completionStatus = [NSNumber numberWithInt:0];
	}
	
	NSDictionary *_retDict = [NSDictionary dictionaryWithObjectsAndKeys:
							  self.assignmentName, kAssignmentName, 
							  self.dueDate, kAssignmentDueDate, 
							  self.completionStatus, kAssignmentCompletionStatus,
							  self.reminderSetting, kAssignmentReminderSetting,
							  self.additionalInfo, kAssignmentAdditionalInfo, nil];
	
	return _retDict;
}

-(NSInteger)dueStatus
{
	//Return 0 for due
	//Return 1 for past due
	//Return 2 for upcoming
	//Return 3 for completed
	
	NSNumber *reminder = self.reminderSetting;
	NSDate *due = self.dueDate;
	NSDate *today = [NSDate date];
	
	//8001 = day
	//8002 = week
	//8003 = month
	//8004 = always
	//8005 = never
	
	//Start off by eliminating the case of the assignment being completed
	//Or the assignment being past due
	
	//Check if the assignment is completed
	if ([self.completionStatus intValue] > 95)
		return 3;
	
	//Check if we are past the due date
	if ([today earlierDate:due] == due)
		return 1;
	
	//If the assignment is not overdue or complete, we need to see what its status is
	switch ([reminder intValue]) {
		case 8001:
		{
			NSDate *tomorrow = [today addTimeInterval:60*60*24];
			
			if ([tomorrow earlierDate:due] == due)
			{
				return 0;
			}
			
			if ([tomorrow earlierDate:due] == tomorrow)
			{
				return 2;
			}
			
			kWLog(@"Did not return from -dueStatusForAssignment:8001");
			
			break;
		}
		case 8002:
		{			
			NSDate *weekOut = [today addTimeInterval:60*60*24*7];
			if ([weekOut earlierDate:due] == due)
				return 0;
			
			if ([weekOut earlierDate:due] == weekOut)
				return 2;
			
			kWLog(@"Did not return from -dueStatusForAssignment:8002");
			break;
		}
		case 8003:
		{			
			NSDate *monthOut = [today addTimeInterval:60*60*24*7*31];
			if ([monthOut earlierDate:due] == due)
				return 0;
			
			if ([monthOut earlierDate:due] == monthOut)
				return 2;
			
			kWLog(@"Did not return from -dueStatusForAssignment:8003");
			break;
		}
		case 8004:
		{			
			return 0;
			
			break;
		}
		case 8005:
		{			
			return 2;
			
			break;
		}
			
		default:
			break;
	}
	
	
	return 0;
}

#pragma mark Memory Management
-(void)dealloc
{
	self.plClass = nil;
	self.assignmentName = nil;
	self.additionalInfo = nil;
	self.reminderSetting = nil;
	self.dueDate = nil;
	self.completionStatus = nil;
	
	[super dealloc];
}
@end
