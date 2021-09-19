//
//  PLAssignment.h
//  Planner
//
//  Created by Kevin Ferguson on 7/19/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//
//PLAssignment Class Description
//Like PLClass, this class serves to track an individual assignment
//Within a given class. PLAssignment retains a reference to the class that
//It came from in order to save any changes back to the responsible class

#import <Foundation/Foundation.h>
#import "PLClass.h" //We use PLClass since PLKit has a reference to this class

@interface PLAssignment : NSObject 
{
	//Class Ref
	PLClass *plClass;
	
	//Strings
	NSString *assignmentName;
	NSString *additionalInfo;
	
	//Numbers
	NSNumber *reminderSetting;
	
	//Dates
	NSDate *dueDate;
	
	//Done Status
	NSNumber *completionStatus;
}

//Initialization
-(id)initWithClass:(PLClass *)theClass usingAssignment:(id)nameOrDict;

//Saving
-(BOOL)canSave;
-(void)saveAssignment;

//Convenience
-(NSString *)reminderSettingAsString;
-(NSDictionary *)dictionaryRepresentation;
-(NSInteger)dueStatus;

//Properties
@property (nonatomic, retain) PLClass *plClass;
@property (nonatomic, retain) NSString *assignmentName;
@property (nonatomic, retain) NSString *additionalInfo;
@property (nonatomic, retain) NSNumber *reminderSetting;
@property (nonatomic, retain) NSDate *dueDate;
@property (nonatomic, retain) NSNumber *completionStatus;
@end
