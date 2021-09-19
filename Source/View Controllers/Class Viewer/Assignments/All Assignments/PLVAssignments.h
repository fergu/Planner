//
//  PLVAssignments.h
//  Planner
//
//  Created by Kevin Ferguson on 7/17/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLKit.h"

@interface PLVAssignments : UITableViewController {
	PLClass *plClass;
}

-(NSInteger)dueStatusForAssignment:(PLAssignment *)assignment;

@property (nonatomic, retain) PLClass *plClass;
@end
