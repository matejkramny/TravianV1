//
//  VillageResourcesViewController.h
//  Travian
//
//  Created by Matej Kramny on 18/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VillageResourcesViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *woodLabel;
@property (strong, nonatomic) IBOutlet UILabel *clayLabel;
@property (strong, nonatomic) IBOutlet UILabel *ironLabel;
@property (strong, nonatomic) IBOutlet UILabel *wheatLabel;
@property (strong, nonatomic) IBOutlet UILabel *warehouseLabel;
@property (strong, nonatomic) IBOutlet UILabel *granaryLabel;
@property (strong, nonatomic) IBOutlet UILabel *consumingLabel;
@property (strong, nonatomic) IBOutlet UILabel *producingLabel;

@end
