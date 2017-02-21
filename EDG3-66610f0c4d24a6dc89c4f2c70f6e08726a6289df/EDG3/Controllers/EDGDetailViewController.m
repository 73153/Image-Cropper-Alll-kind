//
//  EDGDetailViewController.m
//  EDG3
//
//  Created by Patrick Adams on 4/30/14.
//  Copyright (c) 2014 Patrick Adams. All rights reserved.
//

#import "EDGDetailViewController.h"

@interface EDGDetailViewController ()

@end

@implementation EDGDetailViewController

- (void)viewDidLoad
{
    self.postTitle.text = self.post.postTitle;
    self.postDate.text = self.post.postDate;
    self.postAuthor.text = self.post.postAuthor;
    
    self.title = self.post.postTitle;
    
    if (IS_IPAD)
    {
        [self.webView loadHTMLString:[NSString stringWithFormat:@"<html><head><style>body {font-family:avenir; font-size:18px;} img {width:753px; height:350px} iframe {width:753px; height:350px;}</style></head><body>%@</body></html>", self.post.postContent] baseURL:nil];
    }
    else
    {
        [self.webView loadHTMLString:[NSString stringWithFormat:@"<html><head><style>body {font-family:avenir; font-size:14px;} img {width:305px; height:165px} iframe {width:305px; height:165px;}</style></head><body>%@</body></html>", self.post.postContent] baseURL:nil];
    }
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"grey.png"]];
    
    [super viewDidLoad];
}

//Force the webview to not be horizontally scrollable
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView.scrollView setContentSize: CGSizeMake(webView.frame.size.width, webView.scrollView.contentSize.height)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Set up the socialize actionbar
    if (self.actionBar == nil)
    {
        self.entity = [SZEntity entityWithKey:self.post.postURL name:self.post.postTitle];
        self.actionBar = [SZActionBarUtils showActionBarWithViewController:self entity:self.entity options:nil];
        
        SZShareOptions *shareOptions = [SZShareUtils userShareOptions];
        shareOptions.dontShareLocation = YES;
        
        SZActionButton *viewsButton = [SZActionButton viewsButton];
        
        viewsButton.actionBlock = ^(SZActionButton *button, SZActionBar *bar)
        {
            [SZUserUtils showUserProfileInViewController:bar.viewController user:nil completion:nil];
        };
        
        self.actionBar.itemsLeft = @[viewsButton];
        
        shareOptions.willAttemptPostingToSocialNetworkBlock = ^(SZSocialNetwork network, SZSocialNetworkPostData *postData) {
            if (network == SZSocialNetworkTwitter)
            {
                NSString *entityURL = [[postData.propagationInfo objectForKey:@"twitter"] objectForKey:@"entity_url"];
                NSString *displayName = [postData.entity displayName];
                SZShareOptions *shareOptions = (SZShareOptions*)postData.options;
                NSString *text = shareOptions.text;
                
                NSString *customStatus = [NSString stringWithFormat:@"%@ - %@ %@", text, displayName, entityURL];
                
                [postData.params setObject:customStatus forKey:@"status"];
                
            }
            else if (network == SZSocialNetworkFacebook)
            {
                NSString *entityURL = [[postData.propagationInfo objectForKey:@"facebook"] objectForKey:@"entity_url"];
                NSString *displayName = [postData.entity displayName];
                SZShareOptions *shareOptions = (SZShareOptions*)postData.options;
                NSString *text = shareOptions.text;
                
                NSString *customMessage = [NSString stringWithFormat:@"%@ - %@ %@", text, displayName, entityURL];;
                
                [postData.params setObject:customMessage forKey:@"message"];
                [postData.params setObject:entityURL forKey:@"link"];
                [postData.params setObject:@"A caption" forKey:@"caption"];
                [postData.params setObject:@"Custom Name" forKey:@"name"];
                [postData.params setObject:@"A Site" forKey:@"description"];
            }
        };
        
        self.actionBar.shareOptions = shareOptions;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
