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

#import "CacheController.h"
#import "WebController.h"
#import "Account.h"
#import "HTMLParserController.h"
#import "HTMLNode.h"
#import "HTMLParser.h"
#import "VillageObject.h"

@implementation CacheController
{
	int logInAttempts;
	int maxLogInAttempts;
	
	// Observers
	NSMutableArray *accountWatchers;
	BOOL reloading;
}

@synthesize loggedIn;

@synthesize initialConnection;
@synthesize initialConnectionData;
@synthesize loginConnection;
@synthesize loginConnectionData;
@synthesize villageConnections;
@synthesize villageConnectionsData;
@synthesize fetchingVillages;
@synthesize web;
@synthesize parserController;

- (id)init
{
	self = [super init];
	if (self)
	{
		// Init variables
		maxLogInAttempts = 3;
		logInAttempts = 0;
		initialConnectionData = [[NSMutableData alloc] init];
		loginConnectionData = [[NSMutableData alloc] init];
		web = [[WebController alloc] init];
		reloading = NO;
		
		accountWatchers = [NSMutableArray array];
		parserController = [[HTMLParserController alloc] init];
	}
	
	return self;
}

- (void)login
{
	// Log in
	if (logInAttempts >= maxLogInAttempts)
	{
		[self notifyAccountWatchersWithNotification:AccountCannotLogIn];
		logInAttempts = 0; // Reset
		return;
	}
	
	Account *account = self.getSharedStorageObject.activeAccount;
	NSString *url = [NSString stringWithFormat:@"http://%@.travian.%@/", account.world, account.location];
	web.url = [url stringByAppendingString:@"dorf1.php"];
    
	web.postData = [NSString stringWithFormat:@"name=%@&password=%@&lowRes=1&w=&login=1", account.loginName, account.loginPassword];
	
	loginConnectionData = [[NSMutableData alloc] init];
	loginConnection = [web startRequest:self];
}

- (void)reload
{
	Account *account = self.getSharedStorageObject.activeAccount;
	NSString *url = [NSString stringWithFormat:@"http://%@.travian.%@/", account.world, account.location];
    
	if (loggedIn)
	{
		if (reloading) return; // Don't reload twice.. useless
		
		// Reload the data
		reloading = YES;
		[self notifyAccountWatchersWithNotification:DataSourceRefreshing];
		
		web.url = [url stringByAppendingString:@"spieler.php"];
		web.postData = nil;
		
		initialConnectionData = [[NSMutableData alloc] init];
		initialConnection = [web startRequest:self];
	}
	else
	{
		[self login];
	}
}

- (NSMutableData *)getConnectionData:(NSURLConnection *)connection
{
	if (connection == loginConnection)
		return loginConnectionData;
	else if (connection == initialConnection)
		return initialConnectionData;
	else if ([villageConnections containsObject:connection])
		return [villageConnectionsData objectAtIndex:[villageConnections indexOfObjectIdenticalTo:connection]];
	else return nil;
}

#pragma mark - Delegates

#pragma mark SharedStorageDelegateProtocol

- (SharedStorage *)getSharedStorageObject
{
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	return [appDelegate sharedStorage];
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {}
- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection	{	return NO;	}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"Connection failed with error: %@. Fix error by: %@", [error localizedFailureReason], [error localizedRecoverySuggestion]);
	
}

#pragma mark NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[[self getConnectionData:connection] appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
	[[self getConnectionData:connection] setLength:0];
    [[self getConnectionData:connection] setData:[NSData data]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *html = [[NSString alloc] initWithData:[self getConnectionData:connection] encoding:NSUTF8StringEncoding];
	NSError *error;
    
	HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
	if (error)
	{
		NSLog(@"some weiiird error.");
		return;
	}
	
	HTMLNode *bodyNode = [parser body];
	
	self.loggedIn = [self.parserController accountIsLoggedIn:bodyNode];
	
	if (self.loggedIn == false)
	{
		// Logging in attempt failed. Try again
		
		logInAttempts++;
		[self login];
		return;
	}
	
	if ((self.loggedIn && connection == loginConnection) || connection == initialConnection)
	{
		if (connection == loginConnection)
		{
			// Success logging in
			[self notifyAccountWatchersWithNotification:AccountLoggedIn];
			[self reload];
            
            loginConnection = nil;
            
			return;
		}
		
		AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
		[appDelegate sharedStorage].activeAccount.activeVillage = nil;
		[appDelegate sharedStorage].activeAccount.villages = [[NSMutableArray alloc] init];
		
        initialConnection = nil;
        
		NSArray *villages = [self.parserController fetchVillagesFromNode:bodyNode];
		
		Account *account = self.getSharedStorageObject.activeAccount;
		NSString *url = [NSString stringWithFormat:@"http://%@.travian.%@/", account.world, account.location];
		fetchingVillages = [[NSMutableArray alloc] initWithCapacity:[villages count]];
		villageConnections = [[NSMutableArray alloc] initWithCapacity:[villages count] * 2];
		villageConnectionsData = [[NSMutableArray alloc] initWithCapacity:[villages count] * 2];
		
		for (int i = 0; i < [villages count] * 2; i++)
		{
			[villageConnectionsData addObject:[[NSMutableData alloc] init]];
		}
		
		// Empty account villages to refill them
		self.getSharedStorageObject.activeAccount.villages = [[NSMutableArray alloc] initWithCapacity:[villages count]];
		
		NSMutableArray *accountVillages = self.getSharedStorageObject.activeAccount.villages;
		for (VillageObject *village in villages)
		{
			[accountVillages addObject:village];
			
			web.url = [url stringByAppendingFormat:@"dorf1.php%@", [village accessUrl]];
			web.postData = nil;
			[villageConnections addObject:[web startRequest:self]];
			
			web.url = [url stringByAppendingFormat:@"dorf2.php%@", [village accessUrl]];
			[villageConnections addObject:[web startRequest:self]];
		}
		
	}
	else if ([villageConnections containsObject:connection])
	{
        // Fetch village
		int index = [villageConnections indexOfObjectIdenticalTo:connection];
		
		int villageIndex = 0;
		if (index != 0)
		{
			if (index == 1)
				villageIndex = 0;
			else if (index % 2 == 1)
				villageIndex = (index - 1) / 2;
			else
				villageIndex = index / 2;
		}
		
		VillageObject *village = [self.getSharedStorageObject.activeAccount.villages objectAtIndex:villageIndex];
		village = [self.parserController fetchVillage:village fromNode:bodyNode page:index % 2 == 0 ? Resources : Buildings];
		
		// Replace village at correct location
		[self.getSharedStorageObject.activeAccount.villages replaceObjectAtIndex:villageIndex withObject:village];
		
		if (index == [villageConnections count]-1)
		{
			reloading = NO; // Stopped reloading
            villageConnections = nil;
			[self notifyAccountWatchersWithNotification:DataSourceRefreshed];
		}
	}
}

#pragma mark - Watchers

#pragma mark Data Source Watcher
- (void)addAccountWatcher:(id)watcher
{
	[accountWatchers addObject:watcher];
}
- (void)removeAccountWatcher:(id)watcher
{
	[accountWatchers removeObjectIdenticalTo:watcher];
}
- (void)notifyAccountWatchersWithNotification:(Notifications)notification
{
	NSNumber *num = [NSNumber numberWithInt:notification];
	[accountWatchers makeObjectsPerformSelector:@selector(accountNotification:) withObject:num];
}

@end
