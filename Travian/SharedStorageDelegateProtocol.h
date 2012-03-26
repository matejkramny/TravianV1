//
//  SharedStorageDelegateProtocol.h
//  Travian
//
//  Created by Matej Kramny on 09/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SharedStorage;

@protocol SharedStorageDelegateProtocol <NSObject>

- (SharedStorage *)getSharedStorageObject;

@end