//
//  VillageObject.h
//  Travian
//
//  Created by Matej Kramny on 10/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VillageObject : NSObject

@property int loyalty;
@property int population;
@property (copy) NSString *name;
@property int villageId;

@property (nonatomic, strong) NSDictionary *resources;
@property (nonatomic, strong) NSDictionary *maxResources;
@property (nonatomic, strong) NSDictionary *resourcesProduction;
@property (nonatomic, strong) NSNumber *consumption;
@property (nonatomic, strong) NSMutableArray *notifications;
@property (nonatomic, strong) NSMutableArray *soldiers;
@property (copy) NSString *accessUrl;

- (NSString *)describe;

@end
