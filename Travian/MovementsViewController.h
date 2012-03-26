//
//  MovementsViewController.h
//  Travian
//
//  Created by Matej Kramny on 16/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovementObject.h"

@interface MovementsViewController : UITableViewController

@property (nonatomic, strong) MovementObject *selectedMovement;

@end
