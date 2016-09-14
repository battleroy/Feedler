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
        
        AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://news.tut.by/"]];
        httpClient.parameterEncoding = AFFormURLParameterEncoding;
        RKObjectManager *objManager = [[RKObjectManager alloc] initWithHTTPClient:httpClient];
        [objManager setAcceptHeaderWithMIMEType:RKMIMETypeXML];
        
//        RKObjectMapping *newsMapping = [RKObjectMapping mappingForClass:[News class]];
//        [newsMapping addAttributeMappingsFromDictionary:[News mappingDictionary]];
//        
//        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:newsMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:nil];
//        
//        [objManager addResponseDescriptor:responseDescriptor];
        
        RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithPersistentStoreCoordinator:[NSPersistentStoreCoordinator MR_defaultStoreCoordinator]];
        [managedObjectStore createManagedObjectContexts];
        
        objManager.managedObjectStore = managedObjectStore;
        
        RKEntityMapping *newsMapping = [RKEntityMapping mappingForEntityForName:@"News" inManagedObjectStore:managedObjectStore];
        [newsMapping addAttributeMappingsFromDictionary:[News mappingDictionary]];
        newsMapping.identificationAttributes = @[@"newsLink"];
        
        	
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:newsMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"rss.channel.item" statusCodes:nil];
        [objManager addResponseDescriptor:responseDescriptor];

        
        _sharedInstance.newsObjectManager = objManager;
    });
    return _sharedInstance;
}

- (NSURLRequest *)newsURLRequest
{
    static NSURLRequest *_newsURLRequest = nil;
    if (!_newsURLRequest) {
        _newsURLRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://news.tut.by/rss/all.rss"]] ;
    }
    return _newsURLRequest;
}

- (void)newsFromDate:(NSDate *)from
             success:(void(^)(NSArray<News *> *news))successBlock
               error:(void(^)(NSString *errorText))errorBlock
{
    if (self.newsObjectManager.HTTPClient.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        errorBlock(@"No Internet");
    }
    
    [self.newsObjectManager getObjectsAtPath:@"rss/all.rss" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        successBlock([mappingResult array]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        errorBlock(error.localizedDescription);
    }];
}

@end
