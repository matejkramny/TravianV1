//
//  WebController.h
//  Travian
//
//  Created by Matej Kramny on 06/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebController : NSObject

@property (copy) NSString *postData;
@property (copy) NSString *url;

- (id)initWithUrl:(NSString *)requestURL postData:(NSString *)requestData;
- (NSURLConnection *)startRequest:(id)delegate;

@end
