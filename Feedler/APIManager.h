//
//  APIManager.h
//  Feedler
//
//  Created by Yauheni Chasavitsin on 14/09/16.
//  Copyright © 2016 YC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "News.h"

@interface APIManager : NSObject

+ (instancetype)sharedInstance;

- (void)refreshNewsWithSuccess:(void(^)(NSArray<News *> *news))successBlock
                         error:(void(^)(NSString *errorText))errorBlock;

@end
