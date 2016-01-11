//
//  SearchView.h
//  Carte
//
//  Created by ligh on 14-12-11.
//
//

#import "XibView.h"

typedef enum
{
    ShowSearchTextYES = 0,//显示右边搜索文字
    ShowSearchTextNO, //不显示
}ShowSearchTextType;


@protocol SearchViewDelegate <NSObject>

@optional
- (void)searchResultAction:(NSString *)searchText;
- (void)textFieldTextChangedWithText:(NSString *)text; //时时检索
- (void)clickedBGViewAction:(NSString *)searchText;

@end

@interface SearchView : XibView
@property (retain, nonatomic) IBOutlet UITextField *searchTextField;
@property (retain, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIView *searchView;


@property (nonatomic, assign) ShowSearchTextType showSearchType;
@property (nonatomic, assign) id <SearchViewDelegate> delegate;
- (NSString *)searchText;
- (void)hiddenSearchView;

@end
