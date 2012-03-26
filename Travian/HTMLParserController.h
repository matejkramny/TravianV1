//
//  HTMLParserController.h
//  Travian
//
//  Created by Matej Kramny on 10/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTMLParser;
@class HTMLNode;
@class VillageObject;

typedef enum
{
	Resources,
	Buildings,
	Messages,
	Reports,
	Hero,
	Hero_auctions,
	Hero_adventures,
	Profile
} TravianPage;

@interface HTMLParserController : NSObject

- (BOOL)accountIsLoggedIn:(HTMLNode *)node;
- (NSArray *)fetchVillagesFromNode:(HTMLNode *)node; // Returns active village
- (VillageObject *)fetchVillage:(VillageObject *)village fromNode:(HTMLNode *)node page:(TravianPage)page;
- (int)fetchAccountIDFromNode:(HTMLNode *)node; // Returns this account's UID

@end
