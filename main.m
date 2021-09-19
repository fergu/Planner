//
//  main.m
//  Planner
//
//  Created by Kevin Ferguson on 7/8/09.
//  Copyright Kevin Ferguson 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	/*
	NSLog(@"=============================================");
	NSLog(@"Starting Application: Planner");
	NSLog(@"Current Version: 2.0a");
	NSLog(@"Created by Kevin Ferguson");
	NSLog(@"Device Information:");
	UIDevice *device = [UIDevice currentDevice];
	NSLog(@"Device Name: %@", device.name);
	NSLog(@"Device OS: %@ - %@", device.systemName, device.systemVersion);
	NSLog(@"Device Type: %@", device.model);
	NSLog(@"=============================================");
    */
	
	int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
