//
//  ViewController.m
//  Feedler
//
//  Created by Yauheni Chasavitsin on 14/09/16.
//  Copyright © 2016 YC. All rights reserved.
//

#import "FeedViewController.h"
#import "NewsTableViewCell.h"
#import "NewsViewController.h"
#import "News.h"
#import "APIManager.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *newsTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSArray<News *> *newsArray;

@end

@implementation FeedViewController

#pragma mark - VCL

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _refreshControl = [UIRefreshControl new];
    [_refreshControl addTarget:self action:@selector(updateData) forControlEvents:UIControlEventValueChanged];
    
    [self.newsTableView addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateData];
}

#pragma mark - Data Managing

- (void)updateData
{
    [self.refreshControl beginRefreshing];
    
    APIManager *manager = [APIManager sharedInstance];
    [manager newsFromDate:[NSDate dateWithTimeIntervalSinceNow:-24 * 60 * 60] success:^(NSArray<News *> *news) {
        self.newsArray = news;
        [self.refreshControl endRefreshing];
        [self.newsTableView reloadData];
    } error:^(NSString *errorText) {
        NSLog(@"Error: %@", errorText);
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NewsTableViewCell cellHeightForNews:self.newsArray[indexPath.row] cellWidth:tableView.bounds.size.width];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const cellIdentifier = @"NewsTableViewCell";
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    News *news = self.newsArray[indexPath.row];
    [cell updateWithNews:news];
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[NewsViewController class]]) {
        NewsViewController *nvc = segue.destinationViewController;
        nvc.news = self.newsArray[((UITableViewCell *)sender).tag];
    }
}

@end
