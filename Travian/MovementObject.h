//
//  MovementObject.h
//  Travian
//
//  Created by Matej Kramny on 16/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
	IncomingAttack,
	OutgoingAttack,
	IncomingReinforcement,
	OutgoingReinforcement,
	Adventure
} MovementType;

@interface MovementObject : NSObject

@property MovementType movementType;
@property (copy) NSString *arrivalTimeString;
@property int arrivalTimeSeconds;
@property int manyMovements;

- (void)timeWatchingAlert;
- (void)activateTiming;
- (void)deactivateTiming;

@end
