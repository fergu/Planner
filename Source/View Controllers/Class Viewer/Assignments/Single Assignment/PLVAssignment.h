//
//  PLVAssignment.h
//  Planner
//
//  Created by Kevin Ferguson on 7/18/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLKit.h"

@interface PLVAssignment : UITableViewController {
	PLClass *plClass;
	PLAssignment *plAssignment;
	
	UITableViewCell *textViewCell;
	UITableViewCell *sliderCell;
}

@property (nonatomic, retain) PLClass *plClass;
@property (nonatomic, retain) PLAssignment *plAssignment;

@property (nonatomic, assign) IBOutlet UITableViewCell *textViewCell;
@property (nonatomic, assign) IBOutlet UITableViewCell *sliderCell;
@end
