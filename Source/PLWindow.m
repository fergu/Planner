//
//  PLWindow.m
//  Planner
//
//  Created by Kevin on 3/12/10.
//  Copyright 2010 University of Arizona. All rights reserved.
//

#import "PLWindow.h"


@implementation PLWindow

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event 
{
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) 
	{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PLShake_Note" object:self];
    }
}


@end
