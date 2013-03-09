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

#import "AccountDetailsViewController.h"

@implementation AccountDetailsViewController

@synthesize delegate;
@synthesize editingAccount;
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize accountNameTextField;
@synthesize worldTextField;
@synthesize domainTextField;
@synthesize speedServerSwitch;
@synthesize tribeLabel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		tribe = @"Gaul";
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
	
	if (self.editingAccount != nil)
	{
		// Editing mode
		[[self navigationItem] setTitle:@"Edit account"];
		
		tribe = @"Gaul";
		if (self.editingAccount.tribe == Roman)
			tribe = @"Roman";
		else if (self.editingAccount.tribe == Teuton)
			tribe = @"Teuton";
		
		self.accountNameTextField.text = self.editingAccount.name;
		self.usernameTextField.text = self.editingAccount.loginName;
		self.passwordTextField.text = self.editingAccount.loginPassword;
		self.worldTextField.text = self.editingAccount.world;
		self.domainTextField.text = self.editingAccount.location;
		self.speedServerSwitch.on = self.editingAccount.speedServer;
	}
	self.tribeLabel.text = tribe;
}

- (void)viewDidUnload
{
	[self setUsernameTextField:nil];
	[self setPasswordTextField:nil];
    [self setAccountNameTextField:nil];
    [self setWorldTextField:nil];
    [self setDomainTextField:nil];
    [self setSpeedServerSwitch:nil];
	[self setTribeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section) {
		case 0:
			[accountNameTextField becomeFirstResponder];
			break;
		case 1:
			switch (indexPath.row) {
				case 0:
					[usernameTextField becomeFirstResponder];
					break;
				case 1:
					[passwordTextField becomeFirstResponder];
			}
			break;
		case 2:
			switch (indexPath.row) {
				case 0:
					[worldTextField becomeFirstResponder];
					break;
				case 1:
					[domainTextField becomeFirstResponder];
					break;
			}
		default:
			break;
	}
}

#pragma mark - Cancel and done actions

- (IBAction)cancel:(id)sender
{
	[self.delegate accountDetailsViewControllerDidCancel:self];
}
- (IBAction)done:(id)sender
{
	Account *account = [[Account alloc] init];
	
	// Get the enumerated value
	Tribes enumTribe = Gaul;
	if ([tribe isEqualToString:@"Roman"])
		enumTribe = Roman;
	else if ([tribe isEqualToString:@"Teuton"])
		enumTribe = Teuton;
	
	account.speedServer = self.speedServerSwitch.isOn;
	account.name = self.accountNameTextField.text;
	account.loginName = self.usernameTextField.text;
	account.loginPassword = self.passwordTextField.text;
	account.world = self.worldTextField.text;
	account.location = self.domainTextField.text;
	account.tribe = enumTribe;
	
	if (account.isIncomplete)
	{
		missingInformationAlert = [[UIAlertView alloc] initWithTitle:@"Incomplete account" message:@"This account has missing information" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles: nil];
		
		[missingInformationAlert show];
		
		return;
	}
	
	if (self.editingAccount == nil)
		[self.delegate accountDetailsViewController:self didAddAccount:account];
	else
		[self.delegate accountDetailsViewController:self didEditAccount:self.editingAccount newAccount:account];
}
- (IBAction)hideKeyboard:(id)sender
{
	[sender resignFirstResponder];
}

#pragma mark - Prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"PickTribe"])
	{
		[self.view endEditing:YES];
		
		TribeTableViewController *tribeTableViewController = segue.destinationViewController;
		
		tribeTableViewController.delegate = self;
		tribeTableViewController.tribe = tribe;
	}
}

#pragma mark - TribeTableViewControllerDelegate implementation

- (void)tribeTableViewController:(TribeTableViewController *)controller didSelectTribe:(NSString *)selectedTribe
{
	tribe = selectedTribe;
	self.tribeLabel.text = selectedTribe;
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	//if (alertView == missingInformationAlert)
}

@end
