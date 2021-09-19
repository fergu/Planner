//
//  PLClass.h
//  Planner
//
//  Created by Kevin Ferguson on 7/8/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

//PLClass Description:
//This class holds the information on a single class
//Upon instantiation using -initWithClassName
//This class assigns all of its properties
//It can then be passed from view to view
//Without having to reload

//PLClass Notes:
//This should only have to be instantiated once
//Release the object before creating a new one
//Any vars ending in Alt are for a seperate time/location
//Of a given class, though this is not yet implemented

#import <Foundation/Foundation.h>

@interface PLClass : NSObject 
{
	//Dictionaries
	NSMutableDictionary *classDictionary;
	NSMutableDictionary *assignments; //Assignments for the class
	
	//Strings
	NSString *className; //Name of the class
	NSString *classLocation; //Location of the class
	NSString *additionalInfo; //Additional Info about the class
	
	//Dates
	NSDate *startTime; //Time that the class starts
	NSDate *endTime; //Time that the class ends
	
	//Arrays
	NSMutableArray *daysOfWeek; //The days that the class meets
}

//Methods
//Initialization
-(id)initWithClassName:(NSString *)name;

//Loading
-(void)reloadFromFile;

//Saving
-(BOOL)canSave;
-(void)saveToFile;
-(void)addAssignment:(NSDictionary *)assignment;
-(void)removeAssignmentWithName:(NSString *)assnName;

//Convenience
-(NSString *)daysOfWeekAsString:(NSArray *)usingArray;
-(NSString *)classTimesAsString:(NSDate *)startingTime endTime:(NSDate *)endingTime;

//Properties
//Dictionaries
@property (nonatomic, retain) NSMutableDictionary *classDictionary;
@property (nonatomic, retain) NSMutableDictionary *assignments;

//Strings
@property (nonatomic, retain) NSString *className;
@property (nonatomic, retain) NSString *classLocation;
@property (nonatomic, retain) NSString *additionalInfo;

//Dates
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSDate *endTime;

//Arrays
@property (nonatomic, retain) NSMutableArray *daysOfWeek;
@end
