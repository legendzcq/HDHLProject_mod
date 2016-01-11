//
//  SearchStoreView.m
//  HDHLProject
//
//  Created by liu on 15/8/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SearchStoreView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SearchStoreView

- (void)textFeildChangeStateWithStartBlock:(void(^)())startBlock EndBlock:(void(^)())endBlock
{
    self.starSearchBlock = startBlock ;
    self.endSearchBlock=  endBlock;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 0, 15,15)];
    imageView.image = [UIImage imageNamed:@"home_search_gay.png"];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
    [leftView addSubview:imageView];
    self.searchTextFeild.layer.masksToBounds = YES;
    self.searchTextFeild.layer.cornerRadius = 3;
    self.searchTextFeild.leftView = leftView;
    self.searchTextFeild.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextFeild.delegate =self ;
    self.searchTextFeild.returnKeyType = UIReturnKeyDone;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES ;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.starSearchBlock();
}


@end
