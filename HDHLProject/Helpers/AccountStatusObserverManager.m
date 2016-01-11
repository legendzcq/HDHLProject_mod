 //
//  LoginObserverManager.m
//  Carte
//
//  Created by ligh on 14-5-10.
//
//

#import "AccountStatusObserverManager.h"

@interface AccountStatusObserverManager ()
{
    NSMutableArray *_oberverBlockArray;
}
@end

@implementation AccountStatusObserverManager

-(void)dealloc
{
    RELEASE_SAFELY(_oberverBlockArray);
}

static id instance;
+ (id)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
        _oberverBlockArray = [NSMutableArray array];
    }
    
    return self;
}


- (void)addObserverBlock:(AccountStatusObserverBlock)block
{
    AccountStatusObserverBlock copyBlock = [block copy];
    [_oberverBlockArray addObject:copyBlock];
}

- (void)removeObserverBlcok:(AccountStatusObserverBlock)block
{
    [_oberverBlockArray removeObject:block];
}

- (void)removeAllObserver
{
    [_oberverBlockArray removeAllObjects];
}

- (BOOL)postNotifyWithAcconutStatusType:(AcconutStatusType)statusType
{
    for (AccountStatusObserverBlock observerBlock in _oberverBlockArray)
    {
        if (observerBlock)
        {
            observerBlock(statusType);
        }
        
    }
    
    BOOL isProcessed = _oberverBlockArray.count > 0;
    
    [self removeAllObserver];
    
    return isProcessed;
}

@end
