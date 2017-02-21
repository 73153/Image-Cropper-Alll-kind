//
//  EDGFeaturesViewController.h
//  EDG3
//
//  Created by Patrick Adams on 4/30/14.
//  Copyright (c) 2014 Patrick Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDGBaseViewController.h"

@interface EDGFeaturesViewController : EDGBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *results;
@property (nonatomic, strong) NSMutableArray *posts;

@end
