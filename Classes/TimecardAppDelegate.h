//
//  TimecardAppDelegate.h
//  Timecard
//
//  Created by Jacob Rhoden on 10/07/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@interface TimecardAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

