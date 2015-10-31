//
//  WalmartcolorTheme.h
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/23/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+BFPaperColors.h"
#import "Theme.h"

@interface WalmartcolorTheme : NSObject<Theme>

-(UIColor *)primaryColor;
-(UIColor *)secondaryPrimaryColor;

-(UIColor *)primaryTextColor;
-(UIColor *)secondaryTextColor;


-(UIColor *)primaryBlueColor;
-(UIColor *)primaryDarkBlueColor;
-(UIColor *)primaryGreyColor;
-(UIColor *)primaryYellowColor;

- (void)themeForTitleLabels:(UILabel *)label;
- (void)themeForSubTitleLabels:(UILabel *)label;
- (void)themeForContentView:(UIView *)view;
- (void)themeForSecondaryContentView:(UIView *)view;
- (void)themeForCourseCollectionView:(UICollectionView *)courseCollectionView forView:(UIView *)view forRow:(long)row;


@end
