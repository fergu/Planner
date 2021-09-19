//
//  PlannerAppDelegate.h
//  Planner
//
//  Created by Kevin Ferguson on 7/8/09.
//  Copyright Kevin Ferguson 2009. All rights reserved.
//

@interface PlannerAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

-(void)runUpdaterFromVersion:(NSNumber *)version;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

