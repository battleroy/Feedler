//
//  News+CoreDataProperties.h
//  Feedler
//
//  Created by Yauheni Chasavitsin on 14/09/16.
//  Copyright © 2016 YC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "News.h"

NS_ASSUME_NONNULL_BEGIN

@interface News (CoreDataProperties)

@property (nonnull, nonatomic, retain) NSString *title;
@property (nonnull, nonatomic, retain) NSString *newsLink;
@property (nullable, nonatomic, retain) NSString *newsDescription;
@property (nonnull, nonatomic, retain) NSDate *publishDate;
@property (nullable, nonatomic, retain) NSString *imageLink;

@end

NS_ASSUME_NONNULL_END
