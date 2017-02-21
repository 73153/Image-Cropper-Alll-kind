//
//  BNRItem.h
//  RandomPossessions
//
//  Created by Joe Conway on 10/12/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface EDGPost : NSObject <NSCoding>

- (instancetype)initWithPostTitle:(NSString *)title;
 
@property (nonatomic, copy) NSString *postTitle;
@property (nonatomic, copy) NSString *postDate;
@property (nonatomic, copy) NSString *postAuthor;
@property (nonatomic, copy) NSString *postContent;
@property (nonatomic, copy) NSString *postMP3URL;
@property (nonatomic, copy) NSString *postURL;
@property (nonatomic, copy) NSString *postID;
@property (nonatomic, copy) NSString *postImageURL;

@end
