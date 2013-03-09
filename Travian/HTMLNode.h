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
#import <libxml/HTMLparser.h>
#import "HTMLParser.h"

@class HTMLParser;

#define ParsingDepthUnlimited 0
#define ParsingDepthSame -1
#define ParsingDepth size_t

typedef enum
{
	HTMLHrefNode,
	HTMLTextNode,
	HTMLUnkownNode,
	HTMLCodeNode,
	HTMLSpanNode,
	HTMLPNode,
	HTMLLiNode,
	HTMLUlNode,
	HTMLImageNode,
	HTMLOlNode,
	HTMLStrongNode,
	HTMLPreNode,
	HTMLBlockQuoteNode,
} HTMLNodeType;

@interface HTMLNode : NSObject 
{
@public
	xmlNode * _node;
}

//Init with a lib xml node (shouldn't need to be called manually)
//Use [parser doc] to get the root Node
-(id)initWithXMLNode:(xmlNode*)xmlNode;

//Returns a single child of class
-(HTMLNode*)findChildOfClass:(NSString*)className;

//Returns all children of class
-(NSArray*)findChildrenOfClass:(NSString*)className;

//Finds a single child with a matching attribute 
//set allowPartial to match partial matches 
//e.g. <img src="http://www.google.com> [findChildWithAttribute:@"src" matchingName:"google.com" allowPartial:TRUE]
-(HTMLNode*)findChildWithAttribute:(NSString*)attribute matchingName:(NSString*)className allowPartial:(BOOL)partial;

//Finds all children with a matching attribute
-(NSArray*)findChildrenWithAttribute:(NSString*)attribute matchingName:(NSString*)className allowPartial:(BOOL)partial;

//Gets the attribute value matching tha name
-(NSString*)getAttributeNamed:(NSString*)name;

//Find childer with the specified tag name
-(NSArray*)findChildTags:(NSString*)tagName;

//Looks for a tag name e.g. "h3"
-(HTMLNode*)findChildTag:(NSString*)tagName;

//Returns the first child element
-(HTMLNode*)firstChild;

//Returns the plaintext contents of node
-(NSString*)contents;

//Returns the plaintext contents of this node + all children
-(NSString*)allContents;

//Returns the html contents of the node 
-(NSString*)rawContents;

//Returns next sibling in tree
-(HTMLNode*)nextSibling;

//Returns previous sibling in tree
-(HTMLNode*)previousSibling;

//Returns the class name
-(NSString*)className;

//Returns the tag name
-(NSString*)tagName;

//Returns the parent
-(HTMLNode*)parent;

//Returns the first level of children
-(NSArray*)children;

//Returns the node type if know
-(HTMLNodeType)nodetype;


//C functions for minor performance increase in tight loops
NSString * getAttributeNamed(xmlNode * node, const char * nameStr);
void setAttributeNamed(xmlNode * node, const char * nameStr, const char * value);
HTMLNodeType nodeType(xmlNode* node);
NSString * allNodeContents(xmlNode*node);
NSString * rawContentsOfNode(xmlNode * node);


@end
