//
//  EDGAboutViewController.h
//  EDG3
//
//  Created by Patrick Adams on 4/30/14.
//  Copyright (c) 2014 Patrick Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDGBaseViewController.h"
#import <MessageUI/MessageUI.h>

@interface EDGAboutViewController : EDGBaseViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSDictionary *results;
@property (nonatomic, strong) NSMutableArray *posts;

@end
