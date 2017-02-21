//
//  EDGPodcastsViewController.h
//  EDG3
//
//  Created by Patrick Adams on 4/30/14.
//  Copyright (c) 2014 Patrick Adams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDGBaseViewController.h"
#import "AFSoundManager.h"
#import "MBProgressHUD.h"

@interface EDGPodcastsViewController : EDGBaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    BOOL didLoadMP3;
    BOOL isPlaying;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *results;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, weak) IBOutlet UILabel *currentlyPlayingTitle;
@property (nonatomic, weak) IBOutlet UILabel *currentlyPlayingDate;
@property (nonatomic, weak) IBOutlet UIImageView *currentlyPlayingImage;
@property (nonatomic, strong) NSString *mp3URL;

//Audio Player Properties
@property (nonatomic, strong) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet UILabel *elapsedTime;
@property (nonatomic, strong) IBOutlet UILabel *timeRemaining;
@property (nonatomic, strong) IBOutlet UISlider *slider;

@end
