//
//  APIManager.m
//  Feedler
//
//  Created by Yauheni Chasavitsin on 14/09/16.
//  Copyright © 2016 YC. All rights reserved.
//

#import "APIManager.h"
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>
#import <AFNetworking/AFNetworking.h>

@interface APIManager ()

@property (nonatomic, strong) RKObjectManager *newsObjectManager;

@end

@implementation APIManager

+ (instancetype)sharedInstance
{
    static APIManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [APIManager new];
    });
    return _sharedInstance;
}

#define NEWS_BASE_URL @"http://news.tut.by/"
#define NEWS_KEYPATH @"rss.channel.item"
#define NEWS_ID_KEY @"newsLink"
- (RKObjectManager *)newsObjectManager
{
    if (!_newsObjectManager) {
        AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:NEWS_BASE_URL]];
        RKObjectManager *objManager = [[RKObjectManager alloc] initWithHTTPClient:httpClient];
        [objManager setAcceptHeaderWithMIMEType:RKMIMETypeXML];
        
        RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithPersistentStoreCoordinator:[NSPersistentStoreCoordinator MR_defaultStoreCoordinator]];
        [managedObjectStore createManagedObjectContexts];
        
        objManager.managedObjectStore = managedObjectStore;
        
        RKEntityMapping *newsMapping = [RKEntityMapping mappingForEntityForName:@"News" inManagedObjectStore:managedObjectStore];
        [newsMapping addAttributeMappingsFromDictionary:[News mappingDictionary]];
        newsMapping.identificationAttributes = @[NEWS_ID_KEY];
        
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:newsMapping method:RKRequestMethodAny pathPattern:nil keyPath:NEWS_KEYPATH statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [objManager addResponseDescriptor:responseDescriptor];
        
        _newsObjectManager = objManager;
    }
    return _newsObjectManager;
}

#define NEWS_RSS_PATH @"rss/all.rss"
#define NEWS_SORT_KEY @"publishDate"
#define NEWS_FETCH_TIMEOUT 10.0f
- (void)refreshNewsWithSuccess:(void(^)(NSArray<News *> *news))successBlock
                         error:(void(^)(NSString *errorText))errorBlock
{
    if (self.newsObjectManager.HTTPClient.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        errorBlock(@"No Internet");
    }
    
    NSURL *requestURL = [NSURL URLWithString:NEWS_RSS_PATH relativeToURL:self.newsObjectManager.baseURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:NEWS_FETCH_TIMEOUT];
    RKObjectRequestOperation *fetchOperation = [self.newsObjectManager managedObjectRequestOperationWithRequest:request managedObjectContext:self.newsObjectManager.managedObjectStore.persistentStoreManagedObjectContext success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self removeOldNews];
        successBlock([News MR_findAllSortedBy:NEWS_SORT_KEY ascending:NO]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        errorBlock(error.localizedDescription);

    }];
    [fetchOperation start];
}

#define NEWS_LIMIT 100
- (void)removeOldNews
{
    NSArray<News *> *news = [News MR_findAllSortedBy:NEWS_SORT_KEY ascending:NO];
    for (NSInteger i = NEWS_LIMIT; i < news.count; ++i) {
        [news[i] MR_deleteEntity];
    }
}

@end
