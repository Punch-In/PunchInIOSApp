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

/*Colors*/
//main color of the app.
- (UIColor *)primaryColor;

//Dark version of the primary colors
- (UIColor *)primaryColorDark;

//Light version of the primary colors
- (UIColor *)primaryColorLight;

//Color to be used for text which is present on the main window.
- (UIColor *)textPrimaryColor;

//Color to be used for text which is present on the navigation bar controller.
- (UIColor *)textSecondaryColor;

//Color of the textfield
- (UIColor *)textFieldPrimaryColor;

//WindowBackgroundColor
- (UIColor *)windowBackgroundColor;

//Highlighted Color of the views.
-(UIColor *)viewContentColor;

//Default Color which is used to hide the views which are supposed to be ignored
-(UIColor *)ignoreViewColor;

//Color of the tab bars.
- (UIColor *)tabBarColor;

/*Views*/
- (void)themeForBackgroundView:(UIView *)view;
- (void)themeForIgnoreView:(UIView *)view;
- (void)themeForContentView:(UIView *)view;
- (void)themeForTitleView:(UIView *)view;

/*
-(void)setFloatingTextField:(MKTextField *)textField withPlaceHolder:(NSString *)placeHolder;
*/

/*Tab bar controller*/
- (void)themeForTabBarController:(BFPaperTabBarController *)tabController;

/*Buttons*/
- (void)themeForButtons:(BFPaperButton *)button;
- (void)themeBorderLessButton:(UIButton *)button;
- (void)themeForWhiteBackgroundButtons:(UIButton *)button;

/*Theme for UINavigationBar*/
- (void)themeForNavigationBar:(UINavigationController *)navigationBarController;

/*Labels*/
- (void)themeForTitleLabels:(UILabel *)label;
- (void)themeForLightTitleLabels:(UILabel *)label;
- (void)themeForSubTitleLabels:(UILabel *)label;
- (void)themeForWhiteBackGroundLabels:(UILabel *)label;
- (void)themeForGrayBackGroundLabeels:(UILabel *)label;

/*ThemeForCollectionViews*/
- (void)themeForLocationCollectionView:(UICollectionView *)locationCollectionView forView:(UIView *)view;
- (void)themeForAppliancesCollectionView:(UICollectionView *)appliancesCollectionView forView:(UIView *)view;
- (void)themeForCoursesCollectionView:(UICollectionView *)coursesCollectionView forSuperView:(UIView *)view;


-(void)themeForCollectionViewCellLabels:(UILabel *)label;
//Service Man Specific
-(void)themeForServiceManListTitleLabel:(UILabel *)label;
-(void)themeForServiceManListSubTitleLabel:(UILabel *)label;
-(void)themeForServiceManListsSmalltextLabel:(UILabel *)label;

//ServiceMan Labels.
-(void)themeForServiceManListYearLabel:(UILabel *)label;
-(void)themeForServiceManListMonthLabel:(UILabel *)label;
-(void)themeForServiceManListDayLabel:(UILabel *)label;
-(void)themeForServiceManListTimeLabel:(UILabel *)label;
-(void)themeForServiceManDetailTitleLabel:(UILabel *)label;
-(void)themeForServiceManDetailSubTitleLabel:(UILabel *)label;
-(void)themeForServiceManDetailSmalltextLabel:(UILabel *)label;


/*Date Picker*/
-(void)themeForDatePicker:(UIDatePicker *)datePicker;
-(void)themeForCollectionViewCell:(UICollectionViewCell *)cell;

@end
