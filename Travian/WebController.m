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
	NSLog(@"URL %@", url);
	
	NSData *myRequestData = [NSData dataWithBytes: [postData UTF8String] length: [postData length]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: url] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:60];
	
	// Set POST HTTP Headers if necessary
	if (self.postData && self.postData.length > 0)
	{
		[request setHTTPMethod: @"POST"];
		[request setHTTPBody: myRequestData];
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
	}
    
    [request setHTTPShouldHandleCookies:YES];
	
	return [[NSURLConnection alloc] initWithRequest:request delegate:delegate startImmediately:YES];
}

@end
