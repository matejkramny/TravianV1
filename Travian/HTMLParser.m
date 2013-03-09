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

#import "HTMLParser.h"


@implementation HTMLParser

-(HTMLNode*)doc
{
	if (_doc == NULL)
		return NULL;
	
	return [[HTMLNode alloc] initWithXMLNode:(xmlNode*)_doc];
}

-(HTMLNode*)html
{
	if (_doc == NULL)
		return NULL;
	
	return [[self doc] findChildTag:@"html"];
}

-(HTMLNode*)head
{
	if (_doc == NULL)
		return NULL;

	return [[self doc] findChildTag:@"head"];
}

-(HTMLNode*)body
{
	if (_doc == NULL)
		return NULL;
	
	return [[self doc] findChildTag:@"body"];
}

-(id)initWithString:(NSString*)string error:(NSError**)error
{ 
	if (self = [super init])
	{
		_doc = NULL;
		
		if ([string length] > 0)
		{
			CFStringEncoding cfenc = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
			CFStringRef cfencstr = CFStringConvertEncodingToIANACharSetName(cfenc);
			const char *enc = CFStringGetCStringPtr(cfencstr, 0);
			// _doc = htmlParseDoc((xmlChar*)[string UTF8String], enc);
			int optionsHtml = HTML_PARSE_RECOVER;
			optionsHtml = optionsHtml | HTML_PARSE_NOERROR; //Uncomment this to see HTML errors
			optionsHtml = optionsHtml | HTML_PARSE_NOWARNING;
			_doc = htmlReadDoc ((xmlChar*)[string UTF8String], NULL, enc, optionsHtml);
		}
		else 
		{
			if (error) {
				*error = [NSError errorWithDomain:@"HTMLParserdomain" code:1 userInfo:nil];
			}
		}
	}
	
	return self;
}

-(id)initWithData:(NSData*)data error:(NSError**)error
{
	if (self = [super init])
	{
		_doc = NULL;

		if (data)
		{
			CFStringEncoding cfenc = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
			CFStringRef cfencstr = CFStringConvertEncodingToIANACharSetName(cfenc);
			const char *enc = CFStringGetCStringPtr(cfencstr, 0);
			//_doc = htmlParseDoc((xmlChar*)[data bytes], enc);
			
			_doc = htmlReadDoc((xmlChar*)[data bytes],
							 "",
							enc,
							XML_PARSE_NOERROR | XML_PARSE_NOWARNING);
		}
		else
		{
			if (error) 
			{
				*error = [NSError errorWithDomain:@"HTMLParserdomain" code:1 userInfo:nil];
			}

		}
	}
	
	return self;
}

-(id)initWithContentsOfURL:(NSURL*)url error:(NSError**)error
{
	
	NSData * _data = [[NSData alloc] initWithContentsOfURL:url options:0 error:error];

	if (_data == nil || *error)
	{
		return nil;
	}
	
	self = [self initWithData:_data error:error];
	
	return self;
}


-(void)dealloc
{
	if (_doc)
	{
		xmlFreeDoc(_doc);
	}
}

@end
