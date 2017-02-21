//
//  EDGDetailViewController.h
//  EDG3
//
//  Created by Patrick Adams on 4/30/14.
//  Copyright (c) 2014 Patrick Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Socialize/Socialize.h>
#import "EDGPost.h"

@interface EDGDetailViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *postTitle;
@property (nonatomic, weak) IBOutlet UILabel *postDate;
@property (nonatomic, weak) IBOutlet UILabel *postAuthor;
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString *entityKey;
@property (nonatomic, retain) SZActionBar *actionBar;
@property (nonatomic, retain) id<SZEntity> entity;
@property (nonatomic, strong) EDGPost *post;

@end
