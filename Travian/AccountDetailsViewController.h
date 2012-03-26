//
//  AccountDetailsViewController.h
//  Travian
//
//  Created by Matej Kramny on 07/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"
#import "TribeTableViewController.h"

@class AccountDetailsViewController;

@protocol AccountDetailsViewControllerDelegate <NSObject>
- (void)accountDetailsViewControllerDidCancel:(AccountDetailsViewController *)controller;
- (void)accountDetailsViewController:(AccountDetailsViewController *)controller didAddAccount:(Account *)account;
- (void)accountDetailsViewController:(AccountDetailsViewController *)controller didEditAccount:(Account *)oldAccount newAccount:(Account *)newAccount;
@end

@interface AccountDetailsViewController : UITableViewController <TribeTableViewControllerDelegate, UIAlertViewDelegate>
{
	NSString *tribe;
	UIAlertView *missingInformationAlert;
}

@property (nonatomic, weak) id <AccountDetailsViewControllerDelegate> delegate;
@property (nonatomic, weak) Account *editingAccount;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *accountNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *worldTextField;
@property (strong, nonatomic) IBOutlet UITextField *domainTextField;
@property (strong, nonatomic) IBOutlet UISwitch *speedServerSwitch;
@property (strong, nonatomic) IBOutlet UILabel *tribeLabel;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)hideKeyboard:(id)sender;

@end
