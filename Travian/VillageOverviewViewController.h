//
//  VillageOverviewViewController.h
//  Travian
//
//  Created by Matej Kramny on 16/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedStorageDelegateProtocol.h"

@class DetailedMovementObject;

@interface VillageOverviewViewController : UITableViewController <SharedStorageDelegateProtocol>

@property (nonatomic, strong) DetailedMovementObject *selectedMovement;

- (void)timeWatchingAlert;

@end
