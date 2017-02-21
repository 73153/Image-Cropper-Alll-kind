//
//  EDGFeaturedCell.h
//  EDG3
//
//  Created by Patrick Adams on 4/30/14.
//  Copyright (c) 2014 Patrick Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDGFeaturedCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *featuredTitle;
@property (nonatomic, weak) IBOutlet UILabel *featuredDate;
@property (nonatomic, weak) IBOutlet UIImageView *featuredImage;

@end
