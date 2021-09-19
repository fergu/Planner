//
//  AllAssignmentCell.h
//  Planner
//
//  Created by Kevin on 4/3/10.
//  Copyright 2010 University of Arizona. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLKit.h"

@interface AllAssignmentCell : UITableViewCell 
{
	PLClass *plClass;
	PLAssignment *plAssignment;
}

@property (nonatomic, retain) PLClass *plClass;
@property (nonatomic, retain) PLAssignment *plAssignment;
@end
