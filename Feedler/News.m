//
//  News.m
//  Feedler
//
//  Created by Yauheni Chasavitsin on 14/09/16.
//  Copyright © 2016 YC. All rights reserved.
//

#import "News.h"

@implementation News

+ (NSDictionary *)mappingDictionary
{
    static NSDictionary *_mappingDictionary = nil;
    if (!_mappingDictionary) {
        _mappingDictionary = @{
           @"title.__text" : @"title",
           @"link.__text" : @"newsLink",
           @"description.__text" : @"newsDescription",
           @"pubDate.__text" : @"publishDate",
           @"enclosure._url" : @"imageLink"
        };
    }
    return _mappingDictionary;
}

- (BOOL)validateNewsDescription:(id *)ioValue error:(NSError **)outError
{
    *ioValue = [((NSString *)*ioValue) stringByReplacingOccurrencesOfString:@"<[^>]+>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [(*ioValue) length])];
    return YES;
}

@end
