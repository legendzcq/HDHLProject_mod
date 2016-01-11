//
//  SearchViewOrder.h
//  Carte
//
//  Created by ligh on 14-12-16.
//
//

#import "XibView.h"

@protocol SearchViewOrderDelegate <NSObject>
- (void)finishButtonClicked;
- (void)textFieldChangedWithText:(NSString *)text; //时时检索
@end

@interface SearchViewOrder : XibView

@property (nonatomic, assign) id <SearchViewOrderDelegate> delegate;
- (void)showInView:(UIView *)inView;
//透明层设定
- (void)searchBGViewHidden;
//视图位置设定
- (void)changeSearchViewFrame:(UIView *)contentView;

@end
