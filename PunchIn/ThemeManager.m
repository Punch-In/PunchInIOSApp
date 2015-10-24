//
//  ThemeManager.m
//  HomeMonkApplication
//
//  Created by Nilesh Agrawal on 7/16/15.
//  Copyright (c) 2015 Nilesh Agrawal. All rights reserved.
//

#import "ThemeManager.h"
#import "MaterialDesignTheme.h"
#import "WalmartcolorTheme.h"

@implementation ThemeManager

+(id<Theme>)theme{
    return [[WalmartcolorTheme alloc] init];
}
@end
