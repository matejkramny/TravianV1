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
