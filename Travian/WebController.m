//
//  WebController.m
//  Travian
//
//  Created by Matej Kramny on 06/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebController.h"

@implementation WebController

@synthesize postData, url;

- (id)init
{
	self = [super init];
    if (self)
	{
		
    }
    
	return self;
}
- (id)initWithUrl:(NSString *)requestURL postData:(NSString *)requestData
{
	self = [super init];
	if (self)
	{
		postData = [[NSString alloc] initWithString:requestData];
		url = [[NSString alloc] initWithString:requestURL];
	}
	
	return self;
}

- (NSURLConnection *)startRequest:(id)delegate
{
	NSData *myRequestData = [NSData dataWithBytes: [postData UTF8String] length: [postData length]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: url] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:60];
	
	// Set POST HTTP Headers if necessary
	if (self.postData && self.postData.length > 0)
	{
		[request setHTTPMethod: @"POST"];
		[request setHTTPBody: myRequestData];
	}
	
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
	
	return [[NSURLConnection alloc] initWithRequest:request delegate:delegate startImmediately:YES];
}

@end
