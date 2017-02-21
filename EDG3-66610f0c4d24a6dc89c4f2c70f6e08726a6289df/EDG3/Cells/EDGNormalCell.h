//
//  EDGNormalCell.h
//  EDG3
//
//  Created by Patrick Adams on 4/30/14.
//  Copyright (c) 2014 Patrick Adams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDGNormalCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *normalTitle;
@property (nonatomic, weak) IBOutlet UILabel *normalDate;
@property (nonatomic, weak) IBOutlet UILabel *normalAuthor;
@property (nonatomic, weak) IBOutlet UIImageView *normalImage;

@end
