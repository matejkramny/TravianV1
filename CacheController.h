//
//  CacheController.h
//  Travian
//
//  Created by Matej Kramny on 09/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebController;
@class HTMLParserController;

typedef enum {
	DataSourceRefreshing,
	DataSourceRefreshed,
	AccountLoggedOut,
	AccountLoggedIn,
	AccountCannotLogIn,
	NewAccountMessage,
	NewAccountReport
} Notifications;

@interface CacheController : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate, SharedStorageDelegateProtocol>

@property BOOL loggedIn;

@property (nonatomic, strong) WebController *web;
@property (nonatomic, strong) HTMLParserController *parserController;
@property (nonatomic, strong) NSURLConnection *initialConnection;
@property (nonatomic, strong) NSMutableData *initialConnectionData;
@property (nonatomic, strong) NSURLConnection *loginConnection;
@property (nonatomic, strong) NSMutableData *loginConnectionData;
@property (nonatomic, strong) NSMutableArray *villageConnections;
@property (nonatomic, strong) NSMutableArray *villageConnectionsData;
@property (nonatomic, strong) NSMutableArray *fetchingVillages;

- (void)login;
- (void)reload;
- (NSMutableData *)getConnectionData:(NSURLConnection *)connection;

// Data source watcher
- (void)addAccountWatcher:(id)watcher;
- (void)removeAccountWatcher:(id)watcher;
- (void)notifyAccountWatchersWithNotification:(Notifications)notification;

@end
