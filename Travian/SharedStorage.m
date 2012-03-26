//
//  SharedStorage.m
//  Travian
//
//  Created by Matej Kramny on 09/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SharedStorage.h"
#import "Account.h"
#import "CacheController.h"
#import "MovementObject.h"

@implementation SharedStorage

@synthesize activeAccount;
@synthesize accounts;
@synthesize cacheController;
@synthesize movementTypes;

- (id)init
{
	self = [super init];
	if (self)
	{
		Account *acc = [[Account alloc] init];
		
		acc.name = @"Test account";
		acc.loginName = @"matejkramny";
		acc.loginPassword = @"41/_Winchester";
		acc.world = @"ts3";
		acc.location = @"co.uk";
		acc.speedServer = NO;
		acc.tribe = Teuton;
		
		self.activeAccount = nil;
		self.accounts = [[NSMutableArray alloc] initWithObjects:
						 acc,
						 nil];
		cacheController = [[CacheController alloc] init];
		
		movementTypes = [[NSDictionary alloc] initWithObjectsAndKeys:
									   @"Incoming Attack", [NSNumber numberWithInt:IncomingAttack],
									   @"Outgoing Attack", [NSNumber numberWithInt:OutgoingAttack],
									   @"Incoming Reinforcement", [NSNumber numberWithInt:IncomingReinforcement],
									   @"Outgoing Reinforcement", [NSNumber numberWithInt:OutgoingReinforcement],
									   @"Adventure", [NSNumber numberWithInt:Adventure],
									   nil];
	}
	
	return self;
}

@end
