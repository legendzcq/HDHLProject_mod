//
//  PageModel.m
//  Carte
//
//  Created by ligh on 14-4-29.
//
//

#import "PageModel.h"

@implementation PageModel

- (void)dealloc
{
    RELEASE_SAFELY(_totalpage);
    RELEASE_SAFELY(_pagenow);
    RELEASE_SAFELY(_listArray);
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.pagenow   = [dict stringForKey:@"pagenow"];
        self.totalpage = [dict stringForKey:@"totalpage"];
    }
    return self;
}

- (BOOL)isMoreData
{
    return _pagenow.intValue < _totalpage.intValue;
}

@end
