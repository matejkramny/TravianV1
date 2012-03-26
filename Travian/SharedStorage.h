//
//  SharedStorage.h
//  Travian
//
//  Created by Matej Kramny on 09/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;
@class CacheController;

@interface SharedStorage : NSObject

@property (nonatomic, strong) Account *activeAccount;
@property (nonatomic, strong) NSMutableArray *accounts;
@property (nonatomic, strong) CacheController *cacheController;
@property (nonatomic, strong) NSDictionary *movementTypes;

@end
