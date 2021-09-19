//
//  AllAssignmentsRoot.h
//  Planner
//
//  Created by Kevin on 3/18/10.
//  Copyright 2010 University of Arizona. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AllAssignmentsRoot : UITableViewController 
{
	BOOL initialized;
	
	NSMutableArray *due, *pastDue, *upcoming, *complete;
}

-(void)setupView;

@end
