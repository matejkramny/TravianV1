//
//  TribeTableViewConroller.h
//  Travian
//
//  Created by Matej Kramny on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TribeTableViewController;

@protocol TribeTableViewControllerDelegate <NSObject>
- (void)tribeTableViewController:
(TribeTableViewController *)controller 
				  didSelectTribe:(NSString *)selectedTribe;
@end

@interface TribeTableViewController : UITableViewController
{
	NSArray *tribes;
	NSUInteger selectedIndex;
}

@property (nonatomic, weak) id <TribeTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *tribe;

@end
