//
//  AppDelegate.m
//  Feedler
//
//  Created by Yauheni Chasavitsin on 14/09/16.
//  Copyright © 2016 YC. All rights reserved.
//

#import "AppDelegate.h"
#import <MagicalRecord/MagicalRecord.h>
#import "RKXMLDictionarySerialization.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#define FEEDLER_STORE_NAME @"Feedler.sqlite"
#define RSS_MIME_TYPE @"application/rss+xml"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStackWithStoreNamed:FEEDLER_STORE_NAME];
    [RKMIMETypeSerialization registerClass:[RKXMLDictionarySerialization class] forMIMEType:RSS_MIME_TYPE];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
}

@end
