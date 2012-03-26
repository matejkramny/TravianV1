//
//  TestViewController.h
//  Travian
//
//  Created by Matej Kramny on 06/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebController;

@interface TestViewController : UIViewController
{
	WebController *web;
	
	NSMutableData *receivedData;
	NSDictionary *receivedHeaders;
}

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordFIeld;
- (IBAction)buttonPressed:(id)sender;

@end
