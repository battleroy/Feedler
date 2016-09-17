//
//  NewsViewController.m
//  Feedler
//
//  Created by Yauheni Chasavitsin on 14/09/16.
//  Copyright © 2016 YC. All rights reserved.
//

#import "NewsViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface NewsViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *newsHeadlineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *publishDateLabel;
@property (weak, nonatomic) IBOutlet UIWebView *newsPageWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadSpinner;
@property (nonatomic, assign) BOOL allowLoad;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation NewsViewController

#pragma mark - Properties

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateFormat = @"HH:mm dd-MM-yyyy";
    }
    return _dateFormatter;
}

#pragma mark - VCL

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.newsPageWebView.delegate = self;    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self update];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.newsPageWebView stopLoading];
}

#pragma mark - Update

- (void)update
{
    self.allowLoad = YES;
    
    self.newsHeadlineLabel.text = self.news.title;
    [self.newsImageView setImageWithURL:[NSURL URLWithString:self.news.imageLink] placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    self.publishDateLabel.text = [self.dateFormatter stringFromDate:self.news.publishDate];
    [self.newsPageWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.news.newsLink]]];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    return self.allowLoad;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.loadSpinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    [self.loadSpinner stopAnimating];
    self.allowLoad = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"NewsWebView load fail: %@", error.localizedDescription);
}

@end
