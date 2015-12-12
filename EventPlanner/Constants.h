//
//  Constants.h
//  EventPlanner
//
//  Created by Xin Suo on 12/10/15.
//  Copyright © 2015 Thunder Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Constants : NSObject

+ (Constants *)sharedInstance;

- (UIColor *)themeColor;
- (UIColor *)facebookColor;

@end
