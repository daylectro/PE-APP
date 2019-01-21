//
//  SocialFetcher.h
//
//  Copyright (c) 2018 Sherdle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocialFetcher : NSObject

+ (NSDictionary *)executeFetch:(NSString *)query;

@end
