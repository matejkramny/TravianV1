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

#import "VillageOverviewViewController.h"
#import "VillageObject.h"
#import "Account.h"
#import "MovementViewController.h"
#import "MovementsViewController.h"
#import "DetailedMovementObject.h"
#import "CacheController.h"

@implementation VillageOverviewViewController

@synthesize selectedMovement;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.getSharedStorageObject.cacheController addAccountWatcher:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.tabBarController.navigationItem setTitle:@"Overview"];
	
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	// Add self to timeWatchers array
	[[appDelegate timeWatchers] addObject:self];
	
	[[self tableView] reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	[[appDelegate timeWatchers] removeObjectIdenticalTo:self]; // Remove self from timeWatchers
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0)
		return 2;
	else
	{
		int notifications = [self.getSharedStorageObject.activeAccount.activeVillage.notifications count];
		
		if (notifications == 0)
			return 1;
		else
			return notifications;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int section = indexPath.section;
	int row = indexPath.row;
	VillageObject *village = self.getSharedStorageObject.activeAccount.activeVillage;
	
	if (section == 0)
	{
		// Population & Loyalty
		NSString *cellIdentifier = [NSString stringWithString:@"VillageOverviewRightDetail"];
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		
		if (row == 0)
		{
			cell.textLabel.text = @"Population";
			cell.detailTextLabel.text = [[NSNumber numberWithInt:village.population] stringValue];
		}
		else {
			cell.textLabel.text = @"Loyalty";
			cell.detailTextLabel.text = [[NSNumber numberWithInt:village.loyalty] stringValue];
		}
		
		return cell;
	}
	else
	{
		// Movements
		if ([village.notifications count] == 0)
		{
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VillageOverviewBasic"];
			
			cell.textLabel.text = @"No movements";
			
			return cell;
		}
		else
		{
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VillageOverviewMovement"];
			
			MovementObject *movement = [village.notifications objectAtIndex:row];
			int total = movement.arrivalTimeSeconds;
			int hours = total / (60 * 60);
			NSString *hoursString = hours < 10 ? [NSString stringWithFormat:@"0%d", hours] : [NSString stringWithFormat:@"%d", hours];
			total -= hours * (60 * 60);
			int minutes = total / 60;
			NSString *minutesString = minutes < 10 ? [NSString stringWithFormat:@"0%d", minutes] : [NSString stringWithFormat:@"%d", minutes];
			total -= minutes * 60;
			int seconds = total;
			NSString *secondsString = seconds < 10 ? [NSString stringWithFormat:@"0%d", seconds] : [NSString stringWithFormat:@"%d", seconds];
			
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%d %@", movement.manyMovements, [self.getSharedStorageObject.movementTypes objectForKey:[NSNumber numberWithInt:movement.movementType]]];
			cell.textLabel.text = [NSString stringWithFormat:@"%@:%@:%@", hoursString, minutesString, secondsString];
			
			return cell;
		}
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0)
		return @"Overview";
	else
		return @"Movements";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 1)
	{
		if ([self.getSharedStorageObject.activeAccount.activeVillage.notifications count] > 0) {
			selectedMovement = [self.getSharedStorageObject.activeAccount.activeVillage.notifications objectAtIndex:indexPath.row];
			
			if (selectedMovement.manyMovements == 1)
				[self performSegueWithIdentifier:@"OpenMovement" sender:self];
			else
				[self performSegueWithIdentifier:@"OpenMovements" sender:self];
		}
	}
}

#pragma mark - Perform segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if (segue.identifier == @"OpenMovement")
	{
		//MovementViewController *vc = segue.destinationViewController;
		
	}
	else if (segue.identifier == @"OpenMovements")
	{
		//MovementsViewController *vc = segue.destinationViewController;
		
	}
}

#pragma mark - Timer

- (void)timeWatchingAlert
{
	[[self tableView] reloadData];
}

#pragma mark - Account Notification

- (void)accountNotification:(NSNumber *)notificationObject
{
	int notificationInt = [notificationObject intValue];
	
	switch (notificationInt) {
		case DataSourceRefreshed:
			[[self tableView] reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
			[[self tableView] reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
	}
}

@end
