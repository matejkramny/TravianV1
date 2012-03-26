//
//  AccountsViewController.h
//  Travian
//
//  Created by Matej Kramny on 07/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountDetailsViewController.h"

@class Account;

@interface AccountsViewController : UITableViewController <AccountDetailsViewControllerDelegate, SharedStorageDelegateProtocol, MBProgressHUDDelegate>
{
	Account *selectedAccount;
}

- (IBAction)editButtonClicked:(id)sender;
- (IBAction)addAccount:(id)sender;
- (void)setEditingMode:(BOOL)status animated:(BOOL)animated;
- (void)accountNotification:(NSNumber *)notificationObject;

@end
