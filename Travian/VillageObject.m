//
//  VillageObject.m
//  Travian
//
//  Created by Matej Kramny on 10/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VillageObject.h"

@implementation VillageObject

@synthesize loyalty;
@synthesize population;
@synthesize name;
@synthesize villageId;
@synthesize resources;
@synthesize maxResources;
@synthesize resourcesProduction;
@synthesize consumption;
@synthesize notifications;
@synthesize soldiers;
@synthesize accessUrl;

- (NSString *)describe
{
	return [[NSString alloc] initWithFormat:@"Loyalty: %d\nPopulation: %d\nName: %@\nResources: %@\nmaxResources: %@\nresourcesProduction: %@\nconsumption: %@\nNotifications: nil\nSoldiers: nil\nAccess URL: %@", loyalty, population, name, resources, maxResources, resourcesProduction, consumption, accessUrl];
}

@end
