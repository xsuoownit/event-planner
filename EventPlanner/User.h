//
//  User.h
//  EventPlanner
//
//  Created by Xin Suo on 12/10/15.
//  Copyright © 2015 Thunder Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

typedef NS_ENUM(NSInteger, UserType) {
    PARSE = 0,
    FACEBOOK = 1
};

@property (nonatomic, strong) NSString *username;
@property (nonatomic) UserType userType;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;
+ (void)logout;

- (NSDictionary *)toDictionary;
+ (BOOL)hasProfileImage;

@end
