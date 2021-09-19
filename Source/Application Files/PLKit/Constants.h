/*
 *  Constants.h
 *  Planner
 *
 *  Created by Kevin Ferguson on 7/8/09.
 *  Copyright 2009 Kevin Ferguson. All rights reserved.
 *
 */

//Documents Folder
#define kDocumentsFolder [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//Assignment Object Definitions
#define kAssignmentID @"kAssnID"

//UITableViewCell defintions
//Default Apple Cells
#define kCellDefault @"kCellDef_id"
#define kCellValue1 @"kCellV1_id"
#define kCellValue2 @"kCellV2_id"
#define kCellSubtitle @"kCellSub_id"
//Custom Cells
#define kCellTextField @"kTxtFldCell_id"
#define kCellTextView @"kTxtViewCell_id"
#define kCellSwitch @"kSwtchCell_id"
#define kCellSlider @"kSliderCell_id"
#define kCellClassInfo @"kClassCell_id"

//NSDateFormatter definitions
#define kClassDateFormat @"hh:mm a" //hour:minute am/pm

//Notifications
#define kViewWillDisappearNote @"kViewWillDisappear_note"

//Debugging
#ifdef DEBUG
#define kDLog(str) NSLog(@"DEBUG: %@", str) //Debug log message
#define kWLog(str) NSLog(@"WARNING: %@", str) //Warning log message
#define kFLog(str) NSLog(@"FATAL: %@", str) //Fatal Error message
#else
#define kDLog(str)  //Debug log message
#define kWLog(str)  //Warning log message
#define kFLog(str)  //Fatal Error message
#endif