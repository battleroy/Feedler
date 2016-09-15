//
//  NewsTableViewCell.h
//  Feedler
//
//  Created by Yauheni Chasavitsin on 14/09/16.
//  Copyright © 2016 YC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface NewsTableViewCell : UITableViewCell

- (void)updateWithNews:(News *)news;
+ (CGFloat)cellHeightForNews:(News *)news cellWidth:(CGFloat)width;

@end
