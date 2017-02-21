//
//  EDGFeaturesViewController.m
//  EDG3
//
//  Created by Patrick Adams on 4/30/14.
//  Copyright (c) 2014 Patrick Adams. All rights reserved.
//

#import "EDGFeaturesViewController.h"

@interface EDGFeaturesViewController ()

@end

@implementation EDGFeaturesViewController

- (void)viewDidLoad
{
    [self parseJSON:@"https://public-api.wordpress.com/rest/v1/sites/everydaygamers.com/posts/?category=%22features-all%22&number=25" forCategory:@"features"];
    
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
