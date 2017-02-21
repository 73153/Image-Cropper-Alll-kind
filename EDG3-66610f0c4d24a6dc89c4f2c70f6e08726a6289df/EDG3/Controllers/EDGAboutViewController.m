//
//  EDGAboutViewController.m
//  EDG3
//
//  Created by Patrick Adams on 4/30/14.
//  Copyright (c) 2014 Patrick Adams. All rights reserved.
//

#import "EDGAboutViewController.h"

@interface EDGAboutViewController ()

@end

@implementation EDGAboutViewController

- (void)viewDidLoad
{
    [self parseJSON];
    
    [super viewDidLoad];
    
    //Creat the reload button in the corner
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"message"] style:UIBarButtonItemStylePlain target:self action:@selector(contactUs)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)contactUs
{
    [self displayComposerSheet:[NSString stringWithFormat:@""]];
}

- (void)parseJSON
{
    //parse the data
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSError *error = nil;
        NSURL *url = [NSURL URLWithString:@"https://public-api.wordpress.com/rest/v1/sites/everydaygamers.com/posts/?category=%22about-us%22&number=1"];
        NSString *json = [NSString stringWithContentsOfURL:url
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
        
        if(!error)
        {
            NSData *jsonData = [json dataUsingEncoding:NSASCIIStringEncoding];
            self.results = [NSJSONSerialization JSONObjectWithData:jsonData
                                                           options:kNilOptions
                                                             error:&error];
            
            [self.view performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
            
            self.posts = [self.results objectForKey:@"posts"];
            
            NSDictionary *post = [self.posts objectAtIndex:0];
            
            if (IS_IPAD)
            {
                [self.webView loadHTMLString:[NSString stringWithFormat:@"<html><head><style>body {font-family:avenir; font-size:18px;} img {width:117px;} iframe {width:117px; height:117px;}</style></head><body>%@</body></html>", [post objectForKey:@"content"]] baseURL:nil];
            }
            else
            {
                [self.webView loadHTMLString:[NSString stringWithFormat:@"<html><head><style>body {font-family:avenir; font-size:14px;} img {width:117px;} iframe {width:117px; height:117px;}</style></head><body>%@</body></html>", [post objectForKey:@"content"]] baseURL:nil];
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView.scrollView setContentSize: CGSizeMake(webView.frame.size.width, webView.scrollView.contentSize.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Mail Composer Methods

// Displays an email composition interface inside the application. Populates all the Mail fields.
- (void)displayComposerSheet:(NSString *)body {
    
	MFMailComposeViewController *mailComposerView = [[MFMailComposeViewController alloc] init];
    
    if ([MFMailComposeViewController canSendMail])
    {
        mailComposerView.mailComposeDelegate = self;
        [mailComposerView setSubject:@"Message from the EDG iOS App"];
        [mailComposerView setToRecipients:@[@"contact@everydaygamers.com"]];
        [mailComposerView setMessageBody:body isHTML:YES];
        
        [self presentViewController:mailComposerView animated:YES completion:nil];
    }
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Result: canceled");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Result: saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Result: sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Result: failed");
			break;
		default:
			NSLog(@"Result: not sent");
			break;
	}
    
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
