
//
//  HTMLParserController.m
//  Travian
//
//  Created by Matej Kramny on 10/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HTMLParserController.h"
#import "HTMLNode.h"
#import "HTMLParser.h"
#import "VillageObject.h"
#import "DetailedMovementObject.h"

@implementation HTMLParserController

- (id)init
{
	self = [super init];
	if (self)
	{
	}
	
	return self;
}

- (BOOL)accountIsLoggedIn:(HTMLNode *)node
{
	NSArray *forms = [node findChildTags:@"form"];
	
	for (HTMLNode *form in forms)
	{
		if ([[form getAttributeNamed:@"name"] isEqualToString:@"login"])
		{
			// Found a log in form
			
			// Not logged in
			return NO;
		}
	}
	
	return YES;
}

- (NSArray *)fetchVillagesFromNode:(HTMLNode *)node
{
	HTMLNode *villageList = [node findChildWithAttribute:@"id" matchingName:@"villageList" allowPartial:NO];
	NSArray *list = [[villageList findChildTag:@"ul"] findChildTags:@"a"];
	NSMutableArray *villagesArray = [NSMutableArray arrayWithCapacity:[list count]];
	
	for (HTMLNode *village in list)
	{
		VillageObject *villageObject = [[VillageObject alloc] init];
		
		villageObject.accessUrl = [village getAttributeNamed:@"href"];
		villageObject.name = [village contents];
		
		[villagesArray addObject:villageObject];
	}
	
	HTMLNode *tbody = [[node findChildWithAttribute:@"id" matchingName:@"villages" allowPartial:NO] findChildTag:@"tbody"];
	NSArray *trs = [tbody findChildTags:@"tr"];
	
	for (int i = 0; i < [trs count]; i++)
	{
		HTMLNode *tr = [trs objectAtIndex:i];
		
		VillageObject *village = [villagesArray objectAtIndex:i];
		
		NSString *population = [[[tr findChildWithAttribute:@"class" matchingName:@"inhabitants" allowPartial:NO] contents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		village.population = [population intValue];
	}
	
	return villagesArray;
}

- (VillageObject *)fetchVillage:(VillageObject *)village fromNode:(HTMLNode *)node page:(TravianPage)page
{
	if (page == Resources)
	{
		// Fetch Resources page
		HTMLNode *res = [node findChildWithAttribute:@"id" matchingName:@"res" allowPartial:NO];
		NSArray *li = [res findChildTags:@"li"];
		NSArray *lisWithTitle = [[NSArray alloc] initWithObjects:@"r1", @"r2", @"r3", @"r4", nil];
		NSArray *resourceNames = [[NSArray alloc] initWithObjects:@"wood", @"clay", @"iron", @"wheat", nil];
		NSMutableDictionary *resources = [[NSMutableDictionary alloc] initWithCapacity:4];
		NSMutableDictionary *maxResources = [[NSMutableDictionary alloc] initWithCapacity:4];
		NSMutableDictionary *resourcesProduction = [[NSMutableDictionary alloc] initWithCapacity:4];
		
		for (HTMLNode *a in li)
		{
			NSString *aClass = [a getAttributeNamed:@"class"];
			
			if ([lisWithTitle containsObject:aClass])
			{
				NSString *resourceName = [resourceNames objectAtIndex:[lisWithTitle indexOfObject:aClass]];
				
				// Resource production
				// Split title of this li element
				NSArray *splitTitle = [[a getAttributeNamed:@"title"] componentsSeparatedByString:@"production: "];
				int prod = [[splitTitle objectAtIndex:1] intValue];
				
				NSArray *splitRes = [[[a findChildTag:@"span"] contents] componentsSeparatedByString:@"/"];
				int res = [[splitRes objectAtIndex:0] intValue];
				int maxRes = [[splitRes objectAtIndex:1] intValue];
				
				[resources setObject:[NSNumber numberWithInt:res] forKey:resourceName];
				[maxResources setObject:[NSNumber numberWithInt:maxRes] forKey:resourceName];
				[resourcesProduction setObject:[NSNumber numberWithInt:prod] forKey:resourceName];
			}
			else
			{
				// Consumption li tag
				NSArray *splitRes = [[[a findChildTag:@"span"] contents] componentsSeparatedByString:@"/"];
				int consumption = [[splitRes objectAtIndex:0] intValue];
				
				village.consumption = [NSNumber numberWithInt:consumption];
			}
		}
		
		village.resources = resources;
		village.maxResources = maxResources;
		village.resourcesProduction = resourcesProduction;
		
		// Loyalty
		int loyalty = 0;
		HTMLNode *loyaltySpan = [node findChildWithAttribute:@"class" matchingName:@"loyalty" allowPartial:YES];
		NSString *loyaltyString = [loyaltySpan contents];
		NSArray *loyaltyStringComponents = [loyaltyString componentsSeparatedByString:@" "];
		loyaltyString = [loyaltyStringComponents objectAtIndex:[loyaltyStringComponents count]-1]; // Last object, which should be XXX%
		loyaltyString = [loyaltyString substringToIndex:[loyaltyString length] -1];
		loyalty = [loyaltyString intValue];
		
		// Movements
		HTMLNode *movementsID = [node findChildWithAttribute:@"id" matchingName:@"movements" allowPartial:NO];
		// movementsID can be nil because the html tag with id containing movements does not always exist
		
		village.notifications = [[NSMutableArray alloc] init];
		if (movementsID)
		{
			NSArray *trs = [movementsID findChildTags:@"tr"];
			NSDictionary *movementTypes = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt: IncomingAttack], @"a1",
										   [NSNumber numberWithInt: OutgoingAttack], @"a2",
										   [NSNumber numberWithInt: IncomingReinforcement], @"d1",
										   [NSNumber numberWithInt: OutgoingReinforcement], @"d2",
										   [NSNumber numberWithInt: Adventure], @"d3", nil];
			
			for (HTMLNode *tr in trs)
			{
				if ([tr findChildTag:@"th"])
					continue;
				
				NSArray *tds = [tr findChildTags:@"td"];
				HTMLNode *td2 = [tds objectAtIndex:1];
				
				HTMLNode *mov = [td2 findChildWithAttribute:@"class" matchingName:@"mov" allowPartial:NO];
				HTMLNode *movSpan = [mov findChildTag:@"span"];
				HTMLNode *dur_r = [td2 findChildWithAttribute:@"class" matchingName:@"dur_r" allowPartial:NO];
				HTMLNode *dur_timer = [dur_r findChildTag:@"span"];
				NSArray *times = [[dur_timer contents] componentsSeparatedByString:@":"];
				// 1:11:11 // HH:MM:SS
				int hour = [[times objectAtIndex:0] intValue];
				int minute = [[times objectAtIndex:1] intValue];
				int second = [[times objectAtIndex:2] intValue];
				int duration = second + (minute * 60) + ((hour * 60) * 60);
				
				NSArray *movSpanContentsSplit = [[movSpan contents] componentsSeparatedByString:@"&nbsp"];
				int amount = [[movSpanContentsSplit objectAtIndex:0] intValue];
				
				MovementObject *movement = [[MovementObject alloc] init];
				movement.arrivalTimeString = [dur_timer contents];
				movement.arrivalTimeSeconds = duration;
				movement.manyMovements = amount;
				movement.movementType = [[movementTypes objectForKey:[movSpan getAttributeNamed:@"class"]] intValue];
				[movement activateTiming];
				
				[village.notifications addObject:movement];
			}
		}
		
		// Troops
		// Currently building
		
		village.loyalty = loyalty;
	}
	else if (page == Buildings)
	{
		// Fetch buildings page
	}
	
	return village;
}

- (int)fetchAccountIDFromNode:(HTMLNode *)node
{
	HTMLNode *a = [node findChildWithAttribute:@"href" matchingName:@"spieler.php?uid=" allowPartial:YES];
	return [[[[a getAttributeNamed:@"href"] componentsSeparatedByString:@"uid="] objectAtIndex:1] intValue];
}

@end
