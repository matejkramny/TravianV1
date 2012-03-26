//
//  VillageResourcesViewController.m
//  Travian
//
//  Created by Matej Kramny on 18/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VillageResourcesViewController.h"
#import "VillageObject.h"
#import "Account.h"

@implementation VillageResourcesViewController
@synthesize woodLabel;
@synthesize clayLabel;
@synthesize ironLabel;
@synthesize wheatLabel;
@synthesize warehouseLabel;
@synthesize granaryLabel;
@synthesize consumingLabel;
@synthesize producingLabel;

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
}

- (void)viewDidUnload
{
    [self setWoodLabel:nil];
    [self setClayLabel:nil];
    [self setIronLabel:nil];
    [self setWheatLabel:nil];
    [self setWarehouseLabel:nil];
    [self setGranaryLabel:nil];
    [self setConsumingLabel:nil];
    [self setProducingLabel:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    VillageObject *vil = appDelegate.sharedStorage.activeAccount.activeVillage;
    
    woodLabel.text = [NSString stringWithFormat:@"%@ (%@)", [[vil.resources objectForKey:@"wood"] stringValue], [[vil.resourcesProduction objectForKey:@"wood"] stringValue]];
    clayLabel.text = [NSString stringWithFormat:@"%@ (%@)", [[vil.resources objectForKey:@"clay"] stringValue], [[vil.resourcesProduction objectForKey:@"clay"] stringValue]];
    ironLabel.text = [NSString stringWithFormat:@"%@ (%@)", [[vil.resources objectForKey:@"iron"] stringValue], [[vil.resourcesProduction objectForKey:@"iron"] stringValue]];
    wheatLabel.text = [NSString stringWithFormat:@"%@ (%@)", [[vil.resources objectForKey:@"wheat"] stringValue], [[vil.resourcesProduction objectForKey:@"wheat"] stringValue]];
    
    warehouseLabel.text = [[vil.maxResources objectForKey:@"wood"] stringValue];
    granaryLabel.text = [[vil.maxResources objectForKey:@"wheat"] stringValue];
    
    consumingLabel.text = [vil.consumption stringValue];
    producingLabel.text = [[vil.resourcesProduction objectForKey:@"wheat"] stringValue];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
