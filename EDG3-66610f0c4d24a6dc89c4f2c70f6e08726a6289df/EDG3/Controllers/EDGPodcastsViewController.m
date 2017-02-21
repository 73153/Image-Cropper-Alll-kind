//
//  EDGPodcastsViewController.m
//  EDG3
//
//  Created by Patrick Adams on 4/30/14.
//  Copyright (c) 2014 Patrick Adams. All rights reserved.
//

#import "EDGPodcastsViewController.h"

@interface EDGPodcastsViewController ()

@end

@implementation EDGPodcastsViewController

- (void)viewDidLoad
{
    [self parseJSON:@"https://public-api.wordpress.com/rest/v1/sites/everydaygamers.com/posts/?category=%22podcasts%22&number=25" forCategory:@"podcasts"];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grey.png"]];
    
    //Audio controls
    [self setNeedsStatusBarAppearanceUpdate];
    
    [_slider addTarget:self action:@selector(backOrForwardAudio:) forControlEvents:UIControlEventValueChanged];
    _slider.value = 0;
    
    didLoadMP3 = NO;
    isPlaying = NO;
    
    [self.slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EDGPost *post;
    if (!self.archivedPosts)
    {
        post = [self.posts objectAtIndex:[indexPath row]];
    }
    else
    {
        post = [self.archivedPosts objectAtIndex:[indexPath row]];
    }
    
    self.currentlyPlayingTitle.text = post.postTitle;
    self.currentlyPlayingDate.text = post.postDate;
    self.currentlyPlayingImage.image = [super imageByScalingAndCroppingForSize:CGSizeMake(480, 480) resizedImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:post.postImageURL]]]];
    
    //scan for mp3 in html
    NSString * aString = post.postContent;
    NSMutableArray *substrings = [NSMutableArray new];
    NSScanner *scanner = [NSScanner scannerWithString:aString];
    [scanner scanUpToString:@"soundFile:\"http%3A%2F%2F" intoString:nil];
    while(![scanner isAtEnd])
    {
        NSString *substring = nil;
        [scanner scanString:@"soundFile:\"http%3A%2F%2F" intoString:nil];
        if([scanner scanUpToString:@"\"}" intoString:&substring])
        {
            [substrings addObject:substring];
        }
        
        [scanner scanUpToString:@"soundFile:\"http%3A%2F%2F" intoString:nil];
        //Take the newly parsed URL and run it through the scrubber and make it usable
        NSString *theSubstrings = substrings[0];
        NSString *cleanURL = [theSubstrings stringByReplacingOccurrencesOfString:@"%2F" withString:@"/"];
        NSString *cleanURL2 = [cleanURL stringByReplacingOccurrencesOfString:@"25" withString:@""];
        NSString *finalURL = [NSString stringWithFormat:@"http://%@", cleanURL2];
        self.mp3URL = finalURL;
    }
    
    [[AFSoundManager sharedManager]startStreamingRemoteAudioFromURL:self.mp3URL andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
        

        _elapsedTime.text = [self timeFormatted:elapsedTime];
        _timeRemaining.text = [self timeFormatted:timeRemaining];
        
        _slider.value = percentage * 0.01;
        
    }];
    
    [self.playButton setEnabled:YES];
    [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    
    isPlaying = YES;
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

- (IBAction)playPodcast
{
    if (isPlaying == YES)
    {
        [[AFSoundManager sharedManager]pause];
        isPlaying = NO;
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    else if (isPlaying == NO)
    {
        [[AFSoundManager sharedManager]resume];
        isPlaying = YES;
        [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EDGPodDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"podDetailView"];
    
    if (vc != nil)
    {
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
        
        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(void)backOrForwardAudio:(UISlider *)sender
{
    [[AFSoundManager sharedManager]moveToSection:sender.value];
}

-(void)pauseAudio
{
    [[AFSoundManager sharedManager]pause];
}

-(void)resumeAudio
{
    [[AFSoundManager sharedManager]resume];
}

//Setting cell row height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD)
    {
        return 91;
    }
    else
    {
        return 60;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
