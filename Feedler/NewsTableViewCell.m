//
//  NewsTableViewCell.m
//  Feedler
//
//  Created by Yauheni Chasavitsin on 14/09/16.
//  Copyright © 2016 YC. All rights reserved.
//

#import "NewsTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface NewsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsHeadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortDescriptionLabel;

@end

@implementation NewsTableViewCell

#pragma mark - Formatters

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *_dateFormatter = nil;
    if (!_dateFormatter) {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateFormat = @"HH:mm dd-MM-yyyy";
    }
    return _dateFormatter;
}

#pragma mark - Update

- (void)updateWithNews:(News *)news
{
    [self.newsImageView setImageWithURL:[NSURL URLWithString:news.imageLink] placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    self.newsHeadlineLabel.text = news.title;
    self.publishDateLabel.text = [[NewsTableViewCell dateFormatter] stringFromDate:news.publishDate];
    self.shortDescriptionLabel.text = news.newsDescription;
}

#pragma mark - Helpers

+ (UIFont *)headlineFont
{
    static UIFont *_headlineFont = nil;
    if (!_headlineFont) {
        _headlineFont = [UIFont boldSystemFontOfSize:15.0f];
    }
    return _headlineFont;
}

+ (UIFont *)dateFont
{
    static UIFont *_dateFont = nil;
    if (!_dateFont) {
        _dateFont = [UIFont italicSystemFontOfSize:14.0f];
    }
    return _dateFont;
}

+ (UIFont *)descriptionFont
{
    static UIFont *_descriptionFont = nil;
    if (!_descriptionFont) {
        _descriptionFont = [UIFont systemFontOfSize:14.0f];
    }
    return _descriptionFont;
}

+ (CGFloat)labelHeightForText:(NSString *)text font:(UIFont *)font width:(CGFloat)width
{
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font}];
    
    CGRect rect = [as boundingRectWithSize:CGSizeMake(width, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return CGRectGetHeight(CGRectIntegral(rect));
}

static const CGFloat VIEW_OFFSET = 8.0f;
static const CGFloat IMAGE_SIDE = 64.0f;

+ (CGFloat)cellHeightForNews:(News *)news cellWidth:(CGFloat)width
{
    CGFloat givenWidth = width - VIEW_OFFSET * 3 - IMAGE_SIDE;
    
    CGFloat textHeight = 0.0f;
    
    textHeight += [NewsTableViewCell labelHeightForText:news.title
                                                   font:[NewsTableViewCell headlineFont]
                                                  width:givenWidth];
    
    textHeight += [NewsTableViewCell labelHeightForText:[[NewsTableViewCell dateFormatter] stringFromDate:news.publishDate]
                                                   font:[NewsTableViewCell dateFont]
                                                  width:givenWidth];
    
    textHeight += VIEW_OFFSET;
    
    textHeight += [NewsTableViewCell labelHeightForText:news.newsDescription
                                                   font:[NewsTableViewCell descriptionFont]
                                                  width:givenWidth];
    
    return ceil(VIEW_OFFSET * 2 + MAX(IMAGE_SIDE, textHeight));
}

@end
	