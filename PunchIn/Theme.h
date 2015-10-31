//
//  Theme.h
//  HomeMonkApplication
//
//  Created by Nilesh Agrawal on 7/16/15.
//  Copyright (c) 2015 Nilesh Agrawal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BFPaperButton.h"
#import "BFPaperTabBarController.h"

@protocol Theme <NSObject>

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
- (void)themeForCourseCollectionView:(UICollectionView *)courseCollectionView forView:(UIView *)view;
- (void)themeForCourseCollectionView:(UICollectionView *)courseCollectionView forView:(UIView *)view forRow:(long)row;

@end
