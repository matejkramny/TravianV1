//
//  Account.h
//  Travian
//
//  Created by Matej Kramny on 07/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tribes.h"

@class WebController;
@class VillageObject;

@interface Account : NSObject

// Account information
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *loginPassword;
@property (nonatomic, copy) NSString *world; // tsX
@property (nonatomic, copy) NSString *location; // com, co.uk etc
@property BOOL speedServer;
@property Tribes tribe;
@property (nonatomic, strong) NSMutableArray *villages;
@property (nonatomic, strong) VillageObject *activeVillage;

- (BOOL)isIncomplete;

@end
