// This code is distributed under the terms and conditions of the MIT license.

/* * Copyright (C) 2011 - 2013 Matej Kramny <matejkramny@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
 * associated documentation files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge, publish, distribute,
 * sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial
 * portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
 * NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
 * OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "AppDelegate.h"
#import "CacheController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize sharedStorage;
@synthesize timer;
@synthesize timeWatchers;
@synthesize HUD;
@synthesize activeView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Initialize properties
	sharedStorage = [[SharedStorage alloc] init];
	timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
	timeWatchers = [[NSMutableArray alloc] init];
	[sharedStorage.cacheController addAccountWatcher:self];
	
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

#pragma mark - Timer fired!

- (void)timerFired:(NSTimer *)timer
{
	[self notifyTimeWatchers];
}

#pragma mark - Notify time watchers.

- (void) notifyTimeWatchers
{
	[timeWatchers makeObjectsPerformSelector:@selector(timeWatchingAlert)];
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
	HUD = nil;
}

#pragma mark - Notifications from CacheController

- (void)accountNotification:(NSNumber *)notificationObject
{
	int notificationInt = [notificationObject intValue];
	
	if (notificationInt == DataSourceRefreshing)
	{
		if (HUD)
		{
			HUD.labelText = @"Reloading";
			return;
		}
	}
	
	switch (notificationInt) {
		case AccountLoggedIn:
			HUD.labelText = @"Reloading";
			break;
		case DataSourceRefreshing:
			HUD = [MBProgressHUD showHUDAddedTo:self.activeView animated:YES];
			HUD.labelText = @"Reloading";
			break;
		case DataSourceRefreshed:
			[HUD hide:YES];
			break;
		case AccountCannotLogIn: // Same as below, display a notification
		case AccountLoggedOut: // Display root view controller and disregard any current views
		case NewAccountReport: // Display badge?
		case NewAccountMessage: // Display badge?
			break;
	}
}

#pragma mark - Logout

- (void)logout
{
	[sharedStorage.cacheController removeAccountWatcher:self];
	self.sharedStorage = [[SharedStorage alloc] init];
	
	[sharedStorage.cacheController addAccountWatcher:self];
}

@end
