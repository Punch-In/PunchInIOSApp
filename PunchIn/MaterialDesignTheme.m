//
//  MaterialDesignTheme.m
//  HomeMonkApplication
//
//  Created by Nilesh Agrawal on 7/16/15.
//  Copyright (c) 2015 Nilesh Agrawal. All rights reserved.
//

#import "MaterialDesignTheme.h"


@implementation MaterialDesignTheme

/*Colors*/
//main color of the app.
- (UIColor *)primaryColor{
    return UIColorFromRGB(0xEF6D65);
}

//Dark version of the primary colors
- (UIColor *)primaryColorDark{
    return UIColorFromRGB(0xBF5750);
}

//Light version of the primary colors
- (UIColor *)primaryColorLight{
    return UIColorFromRGB(0xF28A83);
}

//Color to be used for text which is present on the main window.
- (UIColor *)textPrimaryColor{
    return UIColorFromRGB(0x9b9b9b);
}

//Color to be used for text which is present on the navigation bar controller.
- (UIColor *)textSecondaryColor{
    return [UIColor whiteColor];
}

//Color of the textfield
- (UIColor *)textFieldPrimaryColor{
    return [UIColor blackColor];
}

//WindowBackgroundColor
- (UIColor *)windowBackgroundColor{
    return UIColorFromRGB(0xfcb314);
}

//Highlighted Color of the views.
-(UIColor *)viewContentColor{
    return [UIColor whiteColor];
}

//Default Color which is used to hide the views which are supposed to be ignored
-(UIColor *)ignoreViewColor{
    return [UIColor whiteColor];
}

//Color of the tab bars.
- (UIColor *)tabBarColor{
    return UIColorFromRGB(0x9b9b9b);
}

/*Views*/
- (void)themeForBackgroundView:(UIView *)view{
    view.backgroundColor = [self windowBackgroundColor];
}

- (void)themeForIgnoreView:(UIView *)view{
    view.backgroundColor = [self windowBackgroundColor];
}

- (void)themeForContentView:(UIView *)view{
    view.backgroundColor = UIColorFromRGB(0x145dfc);
    view.layer.shadowRadius = 2.0;
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowOffset = CGSizeZero;
}

-(void)themeForTitleView:(UIView *)view{
    view.backgroundColor = [self primaryColor];
}

/*TextField*/

/*
 -(void)setFloatingTextField:(MKTextField *)textField withPlaceHolder:(NSString *)placeHolder{
        textField.layer.borderColor = [UIColor clearColor].CGColor;
       // textField.floatingPlaceholderEnabled = YES;
        textField.placeholder = placeHolder;
        textField.cornerRadius = 0;
        textField.bottomBorderEnabled = YES;
        [textField setFont:[UIFont fontWithName:"Avenir Next" size:18.00]];
        [textField setTintColor:[self primaryColor]];
        [textField setTextColor:[self textFieldPrimaryColor]];
}*/

/*Tab bar controller*/
- (void)themeForTabBarController:(BFPaperTabBarController *)tabController{
    tabController.tapCircleColor = UIColorFromRGB(0xEF6D65);
    tabController.underlineColor = UIColorFromRGB(0xEF6D65);
    tabController.backgroundFadeColor = UIColorFromRGB(0xEF6D65);
    tabController.tabBar.tintColor = UIColorFromRGB(0xEF6D65);
}

/*Buttons*/
- (void)themeForButtons:(BFPaperButton *)button{
        [button setBackgroundColor:[self primaryColor]];
        [button setTintColor:[self textSecondaryColor]];
}
- (void)themeBorderLessButton:(UIButton *)button{
        [button setBackgroundColor:[self windowBackgroundColor]];
        [button setTintColor:[self primaryColor]];
        [button setTitleColor:[self primaryColor] forState:UIControlStateNormal];
}
- (void)themeForWhiteBackgroundButtons:(UIButton *)button{
        [button setBackgroundColor:[self viewContentColor]];
        [button setTintColor:[self primaryColor]];
}

/*Theme for UINavigationBar*/
- (void)themeForNavigationBar:(UINavigationController *)navigationBarController{
        navigationBarController.navigationBar.barTintColor = [self primaryColor];
        navigationBarController.navigationBar.tintColor = [self textSecondaryColor];
    navigationBarController.navigationItem.titleView.tintColor = [UIColor whiteColor];
    navigationBarController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor textPrimaryColor] forKey:NSForegroundColorAttributeName];
    navigationBarController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor textPrimaryColor] forKey:NSForegroundColorAttributeName];
}

/*Labels*/
- (void)themeForTitleLabels:(UILabel *)label{
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Avenir Next" size:17.00];
}

- (void)themeForLightTitleLabels:(UILabel *)label{
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Avenir Next" size:17.00];
}

- (void)themeForSubTitleLabels:(UILabel *)label{
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Avenir Next" size:14.00];
}

- (void) themeForWhiteBackGroundLabels:(UILabel*)label{
    label.textColor = [self textFieldPrimaryColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Avenir Next" size:14.00];
}

- (void) themeForGrayBackGroundLabels:(UILabel*)label{
    label.textColor = [self textFieldPrimaryColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Avenir Next" size:14.00];
}

- (void)themeForAppliancesCollectionView:(UICollectionView *)appliancesCollectionView forView:(UIView *)view{
    
}

-(void)themeForLocationCollectionView:(UICollectionView *)locationCollectionView forView:(UIView *)view{    
    CGFloat width = (CGRectGetWidth(view.frame));
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(width, 64)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.minimumLineSpacing=0.0f;
    [locationCollectionView setCollectionViewLayout:flowLayout];
    locationCollectionView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - ServiceManListDisplay Methods
-(void)themeForServiceManListTitleLabel:(UILabel *)label{
    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16.00]];
    [label setTextColor:[self textPrimaryColor]];
    
}
-(void)themeForServiceManListSubTitleLabel:(UILabel *)label{
    [label setFont:[UIFont fontWithName:@"Avenir Next" size:14.00]];
    [label setTextColor:[self textPrimaryColor]];
}
-(void)themeForServiceManListsSmalltextLabel:(UILabel *)label{
    [label setFont:[UIFont fontWithName:@"Avenir Next" size:10.00]];
    [label setTextColor:[self textPrimaryColor]];
}

-(void)themeForServiceManListYearLabel:(UILabel *)label{
    [label setFont:[UIFont fontWithName:@"Avenir Next" size:11.00]];
    [label setTextColor:[self textPrimaryColor]];
}
-(void)themeForServiceManListMonthLabel:(UILabel *)label{
    [label setFont:[UIFont fontWithName:@"Avenir Next" size:13.00]];
    [label setTextColor:[self textPrimaryColor]];
}
-(void)themeForServiceManListDayLabel:(UILabel *)label{
    [label setFont:[UIFont fontWithName:@"Avenir Next" size:20.00]];
    [label setTextColor:[self textPrimaryColor]];
}
-(void)themeForServiceManListTimeLabel:(UILabel *)label{
    [label setFont:[UIFont fontWithName:@"Avenir Next" size:14.00]];
    [label setTextColor:[self textPrimaryColor]];
}

#pragma mark - ServiceManListDisplayDetail Method
-(void)themeForServiceManDetailTitleLabel:(UILabel *)label{
    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16.00]];
    [label setTextColor:[self textPrimaryColor]];
}
-(void)themeForServiceManDetailSubTitleLabel:(UILabel *)label{
    [label setFont:[UIFont fontWithName:@"Avenir Next" size:14.00]];
    [label setTextColor:[self textPrimaryColor]];
}
-(void)themeForServiceManDetailSmalltextLabel:(UILabel *)label{
    [label setFont:[UIFont fontWithName:@"Avenir Next" size:12.00]];
    [label setTextColor:[self textPrimaryColor]];
}
@end
