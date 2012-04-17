//
//  AppDelegate.h
//  Travian
//
//  Created by Matej Kramny on 06/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, MBProgressHUDDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SharedStorage *sharedStorage;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *timeWatchers;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) UIView *activeView;

- (void)timerFired:(NSTimer *)timer;
- (void)notifyTimeWatchers;
- (void)logout;

@end
