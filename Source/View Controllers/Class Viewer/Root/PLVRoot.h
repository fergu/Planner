//
//  PLVRoot.h
//  Planner
//
//  Created by Kevin Ferguson on 7/16/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLKit.h"

@interface PLVRoot : UITableViewController 
{
	PLClass *plClass;
	
	UITableViewCell *classInfoCell;
	UITableViewCell *textViewCell;
}

@property (nonatomic, retain) PLClass *plClass;

@property (nonatomic, assign) IBOutlet UITableViewCell *classInfoCell;
@property (nonatomic, assign) IBOutlet UITableViewCell *textViewCell;
@end
