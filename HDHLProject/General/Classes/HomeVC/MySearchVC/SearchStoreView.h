//
//  SearchStoreView.h
//  HDHLProject
//
//  Created by liu on 15/8/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "XibView.h"

typedef void (^StartSearchBlock)();
typedef void (^EndSearchBlock)();
@interface SearchStoreView : XibView<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextFeild;

- (void)textFeildChangeStateWithStartBlock:(void(^)())startBlock EndBlock:(void(^)())endBlock;

@property (nonatomic,copy)StartSearchBlock starSearchBlock;
@property (nonatomic,copy)EndSearchBlock endSearchBlock;


@end
