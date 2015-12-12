//
//  User.m
//  EventPlanner
//
//  Created by Xin Suo on 12/10/15.
//  Copyright © 2015 Thunder Labs. All rights reserved.
//

#import "User.h"

@interface User()

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation User

static User *_currentUser = nil;

NSString * const eventPlannerCurrentUserKey = @"eventPlannerCurrentUserKey";

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.username = dictionary[@"username"];
        self.userType = [[dictionary valueForKey:@"userType"] integerValue];
    }
    return self;
}

+ (User *)currentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:eventPlannerCurrentUserKey];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    
    return _currentUser;
}

+ (void)setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;
    
    if (_currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:eventPlannerCurrentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:eventPlannerCurrentUserKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[@"username"] = self.username;
    [dictionary setValue:@(self.userType) forKey:@"userType"];
    return dictionary;
}

+ (BOOL)hasProfileImage {
    if (_currentUser != nil && _currentUser.userType == FACEBOOK) {
        return true;
    } else {
        return false;
    }
}

+ (void)logout {
    [User setCurrentUser:nil];
}

@end
