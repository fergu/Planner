//
//  PLFileManager.h
//  Planner
//
//  Created by Kevin Ferguson on 7/8/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

//PLFileManager Description:
//This class is used for loading routines
//That would not be appropriate for implementation
//Within individual classes
//This includes loading large amounts of data not
//Relevant to a single on-disk file.

#import <Foundation/Foundation.h>

@interface PLFileManager : NSObject {}

//Methods
//Initializers
+(id)fileManager;

//File Operators
//Class Operators
-(NSArray *)allClassNames:(BOOL)asFilename;
-(NSInteger)numberOfClasses;

@end
