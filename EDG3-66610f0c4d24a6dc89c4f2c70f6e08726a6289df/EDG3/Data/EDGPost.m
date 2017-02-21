//
//  BNRItem.m
//  RandomPossessions
//
//  Created by Joe Conway on 10/12/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "EDGPost.h"

@interface EDGPost ()

@end

@implementation EDGPost

- (instancetype)initWithPostTitle:(NSString *)postTitle
{
    
    self = [super init];
    
    if (self)
    {
        self.postTitle = postTitle;
    }
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if (self)
    {
        self.postTitle = [decoder decodeObjectForKey:@"title"];
        self.postAuthor = [decoder decodeObjectForKey:@"author"];
        self.postDate = [decoder decodeObjectForKey:@"date"];
        self.postContent = [decoder decodeObjectForKey:@"content"];
        self.postURL = [decoder decodeObjectForKey:@"url"];
        self.postID = [decoder decodeObjectForKey:@"id"];
        self.postImageURL = [decoder decodeObjectForKey:@"image"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.postTitle forKey:@"title"];
    [encoder encodeObject:self.postAuthor forKey:@"author"];
    [encoder encodeObject:self.postDate forKey:@"date"];
    [encoder encodeObject:self.postContent forKey:@"content"];
    [encoder encodeObject:self.postURL forKey:@"url"];
    [encoder encodeObject:self.postID forKey:@"id"];
    [encoder encodeObject:self.postImageURL forKey:@"image"];
}



@end
