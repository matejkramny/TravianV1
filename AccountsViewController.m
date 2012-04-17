//
//  AccountsViewController.m
//  Travian
//
//  Created by Matej Kramny on 07/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountsViewController.h"
#import "Account.h"
#import "CacheController.h"

@implementation AccountsViewController

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
	
	[self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonClicked:)]];
	[self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAccount:)]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
	return [self.getSharedStorageObject.accounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountCell"];
    Account *account = [self.getSharedStorageObject.accounts objectAtIndex:indexPath.row];
    
	cell.textLabel.text = account.name;
	cell.detailTextLabel.text = account.loginName;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self.getSharedStorageObject.accounts removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	selectedAccount = [self.getSharedStorageObject.accounts objectAtIndex:indexPath.row];
	
    if ([self isEditing])
	{
		// Editing account
		[self performSegueWithIdentifier:@"NewAccount" sender:self];
	}
	else
	{
		// Open selected account
		
		// Save the account into shared storage
		self.getSharedStorageObject.activeAccount = [self.getSharedStorageObject.accounts objectAtIndex:indexPath.row];
		
		[self.getSharedStorageObject.cacheController addAccountWatcher:self];
		[self.getSharedStorageObject.cacheController login];
		
		AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
		
		appDelegate.HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
		appDelegate.HUD.labelText = @"Logging in";
	}
}

- (void)accountNotification:(NSNumber *)notificationObject
{
	int notificationInt = [notificationObject intValue];
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	
	switch (notificationInt) {
		case DataSourceRefreshed:
			[self performSegueWithIdentifier:@"OpenAccount" sender:self];
			[self.getSharedStorageObject.cacheController removeAccountWatcher:self];
			
			break;
		case AccountCannotLogIn:
			appDelegate.HUD.labelText = @"Cannot log in";
			[appDelegate.HUD hide:YES afterDelay:0.3];
			
			NSIndexPath *path = [NSIndexPath indexPathForRow:[self.getSharedStorageObject.accounts indexOfObjectIdenticalTo:selectedAccount] inSection:0];
			
			[[self tableView] deselectRowAtIndexPath:path animated:YES];
			
			selectedAccount = nil;
			break;
	}
}

#pragma mark - IBActions

- (IBAction)editButtonClicked:(id)sender
{
	if ([super isEditing])
	{
		[self setEditingMode:NO animated:YES];
	}
	else
	{
		[self setEditingMode:YES animated:YES];
	}
}
- (IBAction)addAccount:(id)sender
{
	[self performSegueWithIdentifier:@"NewAccount" sender:self];
}

- (void)setEditingMode:(BOOL)status animated:(BOOL)animated
{
	[super setEditing:status animated:animated];
	
	if (status)
	{
		[self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editButtonClicked:)] animated:animated];
	}
	else
	{
		[self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonClicked:)] animated:animated];
	}
}

#pragma mark - prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"NewAccount"])
	{
		UINavigationController *navigationController = 
		segue.destinationViewController;
		AccountDetailsViewController 
		*accountDetailsViewController = 
		[[navigationController viewControllers] 
		 objectAtIndex:0];
		
		accountDetailsViewController.delegate = self;
		accountDetailsViewController.editingAccount = selectedAccount;
	}
}

#pragma mark - AccountDetailsViewControllerDelegate

- (void)accountDetailsViewController:(AccountDetailsViewController *)controller didAddAccount:(Account *)account
{
	// Add the account
	[self.getSharedStorageObject.accounts addObject:account];
	
	// Tell table to add row
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.getSharedStorageObject.accounts count] - 1 inSection:0];
	[self.tableView insertRowsAtIndexPaths: [NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	
	// Remove the view
	[self dismissViewControllerAnimated:YES completion:nil];
	
	selectedAccount = nil;
	[self setEditingMode:NO animated:NO];
}
- (void)accountDetailsViewController:(AccountDetailsViewController *)controller didEditAccount:(Account *)oldAccount newAccount:(Account *)newAccount
{
	int location = [self.getSharedStorageObject.accounts indexOfObjectIdenticalTo:oldAccount];
	if(location != NSNotFound)
	{
		// Replace old account with new
		[self.getSharedStorageObject.accounts replaceObjectAtIndex:location withObject:newAccount];
		
		// Reload table source
		[self.tableView reloadData];
	}
	
	// Dismiss view
	[self dismissViewControllerAnimated:YES completion:nil];
	
	selectedAccount = nil;
	[self setEditingMode:NO animated:NO];
}
- (void)accountDetailsViewControllerDidCancel:(AccountDetailsViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
	selectedAccount = nil;
	[self setEditingMode:NO animated:NO];
}

@end
