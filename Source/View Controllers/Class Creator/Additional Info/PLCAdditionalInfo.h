//
//  PLCAdditionalInfo.h
//  Planner
//
//  Created by Kevin Ferguson on 7/13/09.
//  Copyright 2009 Kevin Ferguson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLKit.h"

@interface PLCAdditionalInfo : UIViewController {
	PLClass *plClass;
}

@property (nonatomic, retain) PLClass *plClass;
@end
