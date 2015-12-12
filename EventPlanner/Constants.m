//
//  Constants.m
//  EventPlanner
//
//  Created by Xin Suo on 12/10/15.
//  Copyright © 2015 Thunder Labs. All rights reserved.
//

#import "Constants.h"

@implementation Constants

+ (Constants *)sharedInstance {
    static Constants *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[Constants alloc] init];
        }
    });
    
    return instance;
}

- (UIColor *)themeColor {
    return [UIColor colorWithRed:1/255.0 green:186/255.0 blue:215/255.0 alpha:1];
}

- (UIColor *)facebookColor {
    return [UIColor colorWithRed:82/255.0 green:104/255.0 blue:185/255.0 alpha:1];
}

@end
