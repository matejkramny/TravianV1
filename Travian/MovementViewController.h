//
//  MovementViewController.h
//  Travian
//
//  Created by Matej Kramny on 16/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailedMovementObject.h"

@interface MovementViewController : UITableViewController

@property (nonatomic, strong) DetailedMovementObject *selectedMovement;

@end
