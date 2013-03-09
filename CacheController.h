// This code is distributed under the terms and conditions of the MIT license.

/* * Copyright (C) 2011 - 2013 Matej Kramny <matejkramny@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
 * associated documentation files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge, publish, distribute,
 * sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial
 * portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
 * NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
 * OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

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
