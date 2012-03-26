//
//  VillagesTableViewController.m
//  Travian
//
//  Created by Matej Kramny on 09/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VillagesTableViewController.h"
#import "Account.h"
#import "VillageObject.h"
#import "VillageTableViewController.h"

@implementation VillagesTableViewController

- (SharedStorage *)getSharedStorageObject
{
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	return [appDelegate sharedStorage];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	self.tabBarController.title = @"Villages";
	self.tabBarController.navigationItem.hidesBackButton = YES;
	//self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(nothing)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getSharedStorageObject].activeAccount.villages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VillageCell"];
	
	VillageObject *village = [[self getSharedStorageObject].activeAccount.villages objectAtIndex:indexPath.row];
	cell.textLabel.text = village.name;
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.getSharedStorageObject.activeAccount setActiveVillage:[self.getSharedStorageObject.activeAccount.villages objectAtIndex:indexPath.row]];
	
	[self performSegueWithIdentifier:@"OpenVillage" sender:self];
}

#pragma mark - prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

@end
