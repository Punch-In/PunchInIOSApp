//
//  WalmartcolorTheme.m
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/23/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

#import "WalmartcolorTheme.h"

@implementation WalmartcolorTheme

-(UIColor *)primaryColor{
    return UIColorFromRGB(0x21a1f4);
}


-(UIColor *)secondaryPrimaryColor{
    return UIColorFromRGB(0xf4a921);
}

-(UIColor *)primaryTextColor{
    return UIColorFromRGB(0x21a1f4);
}

-(UIColor *)secondaryTextColor{
    return UIColorFromRGB(0xffffff);
}

-(UIColor *)primaryBlueColor{
    return [UIColor colorWithRed:68 green:127 blue:168 alpha:1.0];
}

-(UIColor *)primaryDarkBlueColor{
    return [UIColor colorWithRed:69 green:128 blue:162 alpha:1.0];
}


-(UIColor *)primaryGreyColor{
    return [UIColor colorWithRed:165 green:165 blue:165 alpha:1.0];
}


-(UIColor *)primaryYellowColor{
    return [UIColor colorWithRed:215 green:156 blue:71 alpha:1.0];
}










- (void)themeForTitleLabels:(UILabel *)label{
    label.textColor = [self secondaryTextColor];
    label.font = [UIFont fontWithName:@"Avenir Next" size:17.00];
}

- (void)themeForSubTitleLabels:(UILabel *)label{
    label.textColor = [self primaryColor];
    label.font = [UIFont fontWithName:@"Avenir Next" size:14.00];
}

- (void)themeForContentView:(UIView *)view{
    view.backgroundColor =[self secondaryPrimaryColor];
    view.layer.shadowRadius = 2.0;
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowOffset = CGSizeZero;
}

- (void)themeForSecondaryContentView:(UIView *)view{
    view.backgroundColor =[self primaryColor];
    view.layer.shadowRadius = 2.0;
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowOffset = CGSizeZero;
}

-(void)themeForCourseCollectionView:(UICollectionView *)courseCollectionView forView:(UIView *)view forRow:(long)row{
    
    if(row %2 == 0){
    CGFloat width = (CGRectGetWidth(view.frame));
    CGFloat height = CGRectGetHeight(view.frame);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(width/2-20, height/5)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 10.0f;
    flowLayout.minimumLineSpacing=10.0f;
    [courseCollectionView setCollectionViewLayout:flowLayout];
    courseCollectionView.backgroundColor = [UIColor whiteColor];
    }else{
        CGFloat width = (CGRectGetWidth(view.frame));
        CGFloat height = CGRectGetHeight(view.frame);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(width/2-20, height/5)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumInteritemSpacing = 10.0f;
        flowLayout.minimumLineSpacing=10.0f;
        [courseCollectionView setCollectionViewLayout:flowLayout];
    }
    
}






@end
