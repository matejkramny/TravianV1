//
//  DetailedMovementObject.h
//  Travian
//
//  Created by Matej Kramny on 16/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovementObject.h"

@interface DetailedMovementObject : MovementObject

@property (copy) NSString *playerName;
@property (copy) NSString *playerTribe;
@property (nonatomic, strong) NSArray *troops;
@property (nonatomic, strong) NSDictionary *bounty;

@end
