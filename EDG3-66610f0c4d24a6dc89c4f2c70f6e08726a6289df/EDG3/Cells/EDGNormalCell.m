//
//  EDGNormalCell.m
//  EDG3
//
//  Created by Patrick Adams on 4/30/14.
//  Copyright (c) 2014 Patrick Adams. All rights reserved.
//

#import "EDGNormalCell.h"

@implementation EDGNormalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}

- (void)awakeFromNib
{
//    self.normalImage.layer.cornerRadius = self.normalImage.frame.size.height /2;
//    self.normalImage.layer.masksToBounds = YES;
//    self.normalImage.layer.borderWidth = 1.0f;
//    self.normalImage.layer.borderColor = [[UIColor colorWithRed:0.14 green:0.39 blue:0.51 alpha:1] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
