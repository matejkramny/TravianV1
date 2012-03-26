//
//  Account.m
//  Travian
//
//  Created by Matej Kramny on 07/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Account.h"
#import "WebController.h"

@implementation Account

@synthesize name;
@synthesize loginName;
@synthesize loginPassword;
@synthesize world;
@synthesize location;
@synthesize speedServer;
@synthesize tribe;
@synthesize villages;
@synthesize activeVillage;

- (id)init
{
	self = [super init];
	
	if (self)
	{
		// Initialise properties to default
		tribe = Gaul;
		speedServer = NO;
	}
	
	return self;
}

- (BOOL)isIncomplete
{
	if (self.name.length == 0 || self.loginName.length == 0 || self.loginPassword.length == 0 || self.world.length == 0 || self.location.length == 0)
		return YES;
	
	return NO;
}

@end
