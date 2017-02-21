//
//  EDGPodDetailViewController.h
//  EDG3
//
//  Created by Patrick Adams on 4/30/14.
//  Copyright (c) 2014 Patrick Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Socialize/Socialize.h>
#import "EDGPost.h"
#import "MBProgressHUD.h"

@interface EDGPodDetailViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString *mp3URL;
@property (nonatomic, strong) NSString *entityKey;
@property (nonatomic, strong) NSString *postTitle;
@property (nonatomic, retain) SZActionBar *actionBar;
@property (nonatomic, retain) id<SZEntity> entity;
@property (nonatomic, strong) NSString *postWebViewString;
@property (nonatomic, strong) EDGPost *post;
@property (nonatomic, weak) IBOutlet UINavigationBar *navBar;


@end
