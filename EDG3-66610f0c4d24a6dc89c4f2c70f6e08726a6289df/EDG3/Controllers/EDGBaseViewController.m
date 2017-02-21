//
//  EDGBaseViewController.m
//  EDG3
//
//  Created by Patrick Adams on 4/30/14.
//  Copyright (c) 2014 Patrick Adams. All rights reserved.
//

#import "EDGBaseViewController.h"

@interface EDGBaseViewController ()

@end

@implementation EDGBaseViewController

- (void)viewDidLoad
{
    //Create the profile button in the corner
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"contact"] style:UIBarButtonItemStylePlain target:self action:@selector(profileButtonPressed)];
    //Creat the reload button in the corner
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(refresh)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.leftBarButtonItem = leftButton;

    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Avenir-Heavy" size:21], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
}

- (void)refresh
{
    [self parseJSON:self.urlString forCategory:self.categoryString];
    [self.tableView reloadData];
}

//Load the users profile when the button is pushed
- (void)profileButtonPressed
{
    _SZUserProfileViewController *profileView = [[_SZUserProfileViewController alloc] init];
    if (profileView !=nil)
    {
        [SZUserUtils showUserProfileInViewController:self user:nil completion:nil];
    }
}

- (void)parseJSON:(NSString *)fromURLString forCategory:(NSString *)category
{
    self.urlString = fromURLString;
    self.categoryString = category;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSURL *url = [NSURL URLWithString:fromURLString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *results = (NSDictionary *)responseObject;
            self.posts = [[NSMutableArray alloc] init];
            
            for (EDGPost *post in [results objectForKey:@"posts"])
            {
                EDGPost *newPost = [[EDGPost alloc] initWithPostTitle:[self cleanUpTheTitleString:[post valueForKey:@"title"]]];
                
                newPost.postDate = [self formatTheDate:[post valueForKey:@"date"]];
                newPost.postAuthor = [[post valueForKey:@"author"] objectForKey:@"name"];
                newPost.postContent = [post valueForKey:@"content"];
                newPost.postURL = [post valueForKey:@"URL"];
                newPost.postID = [post valueForKey:@"ID"];
                newPost.postImageURL = [self scrubForAnImgURL:[post valueForKey:@"content"]];
                
                [self.posts addObject:newPost];
            }
            
            NSString *path = [self postsArchivePath:category];
            [NSKeyedArchiver archiveRootObject:self.posts toFile:path];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            });
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            });
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving JSON" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alertView show];
        }];
        
        [operation start];
        
    });
    
}

- (NSString *)postsArchivePath:(NSString *)forCategory
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archive", forCategory]];
}

//Method to clean up the title string
- (NSString*)cleanUpTheTitleString:(NSMutableString *)titleString
{
    NSString *parsedTitleStep1 = [titleString stringByReplacingOccurrencesOfString:@"Review: " withString:@""];
    NSString *parsedTitleStep2 = [parsedTitleStep1 stringByReplacingOccurrencesOfString:@"&#8211;" withString:@"-"];
    NSString *parsedTitleStep3 = [parsedTitleStep2 stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"];
    NSString *parsedTitleStep4 = [parsedTitleStep3 stringByReplacingOccurrencesOfString:@"&#038;" withString:@"&"];
    
    return parsedTitleStep4;
}

//Method to look through an HTML string and find the first image url
- (NSString*)scrubForAnImgURL:(NSString *)thePostContent
{
    //scan for image in html
    NSString *url = nil;
    NSString *htmlString = thePostContent;
    NSScanner *theScanner = [NSScanner scannerWithString:htmlString];
    // find start of IMG tag
    [theScanner scanUpToString:@"<img" intoString:nil];
    if (![theScanner isAtEnd])
    {
        [theScanner scanUpToString:@"src" intoString:nil];
        NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
        [theScanner scanUpToCharactersFromSet:charset intoString:nil];
        [theScanner scanCharactersFromSet:charset intoString:nil];
        [theScanner scanUpToCharactersFromSet:charset intoString:&url];
    }
    return url;
}

//Scale and crop the image to fit inside the UIImageView the best it can
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize resizedImage:(UIImage*)resizedImage
{
    UIImage *sourceImage = resizedImage;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

//Format the date to something more readable
- (NSString*)formatTheDate:(NSString *)theDate
{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-M-d'T'H:m:sZ"];
    NSDate *date = [dateFormat dateFromString:theDate];
    [dateFormat setDateFormat:@"MMMM d, YYYY"];
    NSString *newDate = [dateFormat stringFromDate:date];
    
    return newDate;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *path = [self postsArchivePath:self.categoryString];
    self.archivedPosts = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    if (!self.archivedPosts)
    {
        return self.posts.count;
    }
    else
    {
        return self.archivedPosts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier;
    
    if ([indexPath row] > 0)
    {
        cellIdentifier = @"NormalCell";
        EDGNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[EDGNormalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        NSString *path = [self postsArchivePath:self.categoryString];
        self.archivedPosts = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        EDGPost *post;
        
        if (!self.archivedPosts)
        {
            post = [self.posts objectAtIndex:[indexPath row]];
        }
        else
        {
            post = [self.archivedPosts objectAtIndex:[indexPath row]];
        }
        
        cell.normalTitle.text = post.postTitle;
        cell.normalDate.text = post.postDate;
        cell.normalAuthor.text = post.postAuthor;
        
        NSURL *url = [NSURL URLWithString:post.postImageURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder.jpg"];
        
        __weak EDGNormalCell *weakCell = cell;
        
        [cell.normalImage setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            weakCell.normalImage.image = [self imageByScalingAndCroppingForSize:CGSizeMake(100, 100) resizedImage:image];
            [weakCell setNeedsLayout];
            
        } failure:nil];
        
        return cell;
    }
    else
    {
        cellIdentifier = @"FeaturedCell";
        EDGFeaturedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[EDGFeaturedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        NSString *path = [self postsArchivePath:self.categoryString];
        self.archivedPosts = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        EDGPost *post;
        
        if (!self.archivedPosts)
        {
            post = [self.posts objectAtIndex:[indexPath row]];
        }
        else
        {
            post = [self.archivedPosts objectAtIndex:[indexPath row]];
        }
        
        cell.featuredTitle.text = post.postTitle;
        
        if (self.tabBarController.tabBar.selectedItem.tag == 3)
        {
            cell.featuredDate.text = post.postDate;
        }
        else
        {
            cell.featuredDate.text = post.postAuthor;
        }
        
        NSURL *url = [NSURL URLWithString:post.postImageURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder2.jpg"];
        
        __weak EDGFeaturedCell *weakCell = cell;
        
        [cell.featuredImage setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            if (IS_IPAD)
            {
                weakCell.featuredImage.image = [self imageByScalingAndCroppingForSize:CGSizeMake(1536, 698) resizedImage:image];
            }
            else
            {
                weakCell.featuredImage.image = [self imageByScalingAndCroppingForSize:CGSizeMake(640, 400) resizedImage:image];
            }
            
            [weakCell setNeedsLayout];
            
        } failure:nil];
        return cell;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard;
    
    if (IS_IPAD)
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main-iPad" bundle:nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    
    if (self.tabBarController.tabBar.selectedItem.tag == 3)
    {
        EDGPodDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"podDetailView"];
        
        if (vc != nil)
        {
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
            
            EDGPost *post;
            if (!self.archivedPosts)
            {
                post = [self.posts objectAtIndex:[indexPath row]];
            }
            else
            {
                post = [self.archivedPosts objectAtIndex:[indexPath row]];
            }
            
            vc.post = post;
        }
    }
    else
    {
        EDGDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"detailView"];
        
        if (vc != nil)
        {
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
            
            EDGPost *post;
            if (!self.archivedPosts)
            {
                post = [self.posts objectAtIndex:[indexPath row]];
            }
            else
            {
                post = [self.archivedPosts objectAtIndex:[indexPath row]];
            }
            
            vc.post = post;
        }
    }
}

//Setting cell row height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == 0)
    {
        if (IS_IPAD)
        {
            return 350;
        }
        else
        {
            return 200;
        }
        
    }
    else
    {
        if (IS_IPAD)
        {
            return 91;
        }
        else
        {
            return 74;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
