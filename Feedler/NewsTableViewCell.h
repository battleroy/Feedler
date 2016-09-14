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

@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsHeadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortDescriptionLabel;

- (void)updateWithNews:(News *)news;
+ (CGFloat)cellHeightForNews:(News *)news cellWidth:(CGFloat)width;

@end
