//
//  News.h
//  Feedler
//
//  Created by Yauheni Chasavitsin on 14/09/16.
//  Copyright © 2016 YC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface News : NSManagedObject

+ (NSDictionary *)mappingDictionary;

@end

NS_ASSUME_NONNULL_END

#import "News+CoreDataProperties.h"
