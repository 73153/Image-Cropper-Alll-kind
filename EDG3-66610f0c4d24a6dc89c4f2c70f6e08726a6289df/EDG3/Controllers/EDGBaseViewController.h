//
//  EDGBaseViewController.h
//  EDG3
//
//  Created by Patrick Adams on 4/30/14.
//  Copyright (c) 2014 Patrick Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EDGNormalCell.h"
#import "EDGFeaturedCell.h"
#import "EDGPost.h"
#import "EDGDetailViewController.h"
#import "EDGPodDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface EDGBaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *results;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) NSMutableArray *archivedPosts;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *categoryString;

- (NSString*)formatTheDate:(NSString *)theString;
- (void)parseJSON:(NSString *)fromURLString forCategory:(NSString *)category;
- (void)refresh;
- (NSString*)cleanUpTheTitleString:(NSString *)titleString;
- (NSString*)scrubForAnImgURL:(NSString *)thePostContent;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize resizedImage:(UIImage*)resizedImage;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;


@end
