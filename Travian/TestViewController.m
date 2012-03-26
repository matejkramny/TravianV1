//
//  TestViewController.m
//  Travian
//
//  Created by Matej Kramny on 06/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestViewController.h"
#import "WebController.h"


@implementation TestViewController
@synthesize usernameField;
@synthesize passwordFIeld;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	[super loadView];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[usernameField setText:@"Hello world"];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
	[self setUsernameField:nil];
	[self setPasswordFIeld:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)buttonPressed:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setValue:[usernameField text] forKey:@"username_preferences"];
	[defaults synchronize];
	
	if (!web)
	{
		web = [[WebController alloc] initWithUrl:@"http://xcodeapptesting/" postData:@"name=HelloMyWorld"];
	}
	else
	{
		[web setUrl:@"http://xcodeapptesting/"];
		[web setPostData:@"name=HelloMyWorld"];
	}
	
	receivedData = [NSMutableData data];
	
	if ([web startRequest:self])
	{
		
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
	[receivedData setLength:0];
	
	receivedHeaders = [response allHeaderFields];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"Connection failed");
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
}

@end
