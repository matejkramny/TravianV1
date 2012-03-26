//
//  VillageTableViewController.h
//  Travian
//
//  Created by Matej Kramny on 11/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VillageObject;

typedef enum
{
	Overview = 0,
	Movements = 1,
	Resources = 2,
	Buildings = 3,
	Troops = 4,
	Reports = 5
} TableSectionIdentifier;

@interface VillageTableViewController : UITableViewController

@property (nonatomic, strong) VillageObject *village;
@property (nonatomic, strong) NSMutableArray *resources;

@end
