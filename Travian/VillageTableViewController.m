//
//  VillageTableViewController.m
//  Travian
//
//  Created by Matej Kramny on 11/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VillageTableViewController.h"
#import "Account.h"
#import "VillageObject.h"

@implementation VillageTableViewController

@synthesize village;
@synthesize resources;

- (SharedStorage *)getSharedStorageObject
{
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
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
    VillageObject *vil = [[self getSharedStorageObject].activeAccount.villages objectAtIndex:0];
	
	self.navigationItem.title = vil.name;
	
	NSArray *resourceKeys = [[NSArray alloc] initWithObjects:@"wood", @"clay", @"iron", @"wheat", nil];
	resources = [[NSMutableArray alloc] init];
	for (NSString *key in resourceKeys) {
		NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
							  [key capitalizedString], @"name",
							  [NSString stringWithFormat:@"%@ (%@)", [[vil.resources objectForKey:key] stringValue], [[vil.resourcesProduction objectForKey:key] stringValue]], @"value",
							  nil];
		
		[resources addObject:dict];
	}
	
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.activeView = self.tabBarController.navigationController.view;
	
	[super viewWillAppear:animated];
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
	return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case Overview:
			return 2;
		case Movements:
			return [village.notifications count] == 0 ? 1 : [village.notifications count];
		case Resources:
			return [resources count]+1; // +1 for a 'More' button
		case Buildings:
		case Troops:
		case Reports:
			return 1;
		default:
			return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	TableSectionIdentifier section = indexPath.section;
	int row = indexPath.row;
	
	if (section == Overview)
	{
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VillageCellRightDetailNoSelection"];
		
		if (row == 0)
		{
			cell.textLabel.text = @"Population";
			cell.detailTextLabel.text = [[NSNumber numberWithInt:village.population] stringValue];
		}
		else if (row == 1)
		{
			cell.textLabel.text = @"Loyalty";
			cell.detailTextLabel.text = [[NSNumber numberWithInt:village.loyalty] stringValue];
		}
		
		return cell;
	}
	if (section == Movements)
	{
		if ([village.notifications count] == 0)
		{
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VillageCellBasic"];
			
			cell.textLabel.text = @"No movements";
			
			return cell;
		}
		else
		{
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VillageCellLeftDetailSelection"];
			
			NSDictionary *dict = [village.notifications objectAtIndex:row];
			cell.textLabel.text = @"Time left..";
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", [dict objectForKey:@"value"], [dict objectForKey:@"name"]];
			
			return cell;
		}
	}
	if (section == Resources)
	{
		if (row > [resources count]-1)
		{
			// Last object, non-existing in [resources]
			// Button
			
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VillageCellButton"];
			cell.textLabel.text = [resources count] > 4 ? @"Hide" : @"Show all";
			
			return cell;
		}
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VillageCellRightDetailNoSelection"];
		
		NSMutableDictionary *value = [resources objectAtIndex:row];
		cell.textLabel.text = [value objectForKey:@"name"];
		cell.detailTextLabel.text = [value objectForKey:@"value"];
		
		return cell;
	}
	if (section == Buildings)
	{
		
	}
	if (section == Troops)
	{
		
	}
	if (section == Reports)
	{
		
	}
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VillageCellRightDetailNoSelection"];
	
	cell.textLabel.text = @"Some cell";
	cell.detailTextLabel.text = @"HAHAHA";
	//NSNumber *resourceValue = [village.resourcesProduction objectForKey:[resourceKeys objectAtIndex:indexPath.row]];
	//cell.detailTextLabel.text = [resourceValue stringValue];
	
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case Overview:
			return @"Overview";
		case Movements:
			return @"Movements";
		case Resources:
			return @"Resources";
		case Buildings:
			return @"Buildings";
		case Troops:
			return @"Troops";
		case Reports:
			return @"Reports";
		default:
			return nil;
	}
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if (section == Resources)
		return @"Resource name - Resource (Production)";
		
	return @"";
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	int section = indexPath.section;
	int row = indexPath.row;
	
	if (section == Resources)
	{
		if (row != [resources count]) return;
		
		VillageObject *vil = [[self getSharedStorageObject].activeAccount.villages objectAtIndex:0];
		NSArray *resourceKeys = [[NSArray alloc] initWithObjects:@"wood", @"clay", @"iron", @"wheat", nil];
		
		int cycles = 1;
		if ([resources count] == 4)
		{
			// Show max resources
			cycles = 2;
		}
		
		resources = [[NSMutableArray alloc] init];
		int i;
		for (i = 0; i < cycles; i++)
		{
			if (i == 1)
			{
				// Show max resources
				NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Warehouse", @"name", [[vil.maxResources objectForKey:@"wood"] stringValue], @"value", nil];
				[resources addObject:dict];
				
				dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Granary", @"name", [[vil.maxResources objectForKey:@"wheat"] stringValue], @"value", nil];
				[resources addObject:dict];
				
				continue;
			}
			
			for (NSString *key in resourceKeys) {
				NSString *value = [NSString stringWithFormat:@"%@ (%@)", [[vil.resources objectForKey:key] stringValue], [[vil.resourcesProduction objectForKey:key] stringValue]];
				
				NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
									  [key capitalizedString], @"name",
									  value, @"value",
									  nil];
				
				[resources addObject:dict];
			}
		}
		
		[[self tableView] reloadSections:[[NSIndexSet alloc] initWithIndex:Resources] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
}

#pragma mark - Header methods


@end
