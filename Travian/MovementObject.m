//
//  MovementObject.m
//  Travian
//
//  Created by Matej Kramny on 16/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovementObject.h"
#import "CacheController.h"

@implementation MovementObject

@synthesize movementType;
@synthesize arrivalTimeString;
@synthesize arrivalTimeSeconds;
@synthesize manyMovements;

- (void)activateTiming
{
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[[appDelegate timeWatchers] addObject:self];
	
	arrivalTimeSeconds = 20;
}
- (void)deactivateTiming
{
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[[appDelegate timeWatchers] removeObjectIdenticalTo:self];
}

- (void)timeWatchingAlert
{
	// arrivalTimeSeconds--
	// update arrivalTimeString
	
	if (arrivalTimeSeconds <= 0)
	{
		// Tell CacheController to reload
		AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
		[[appDelegate.sharedStorage cacheController] reload];
		
		[self deactivateTiming];
		
		return;
	}
	
	self.arrivalTimeSeconds -= 1;
}

@end
