//
//  LoginObserverManager.h
//  Carte
//
//  Created by ligh on 14-5-10.
//
//

#import <Foundation/Foundation.h>

typedef enum
{
    LoginSuccess,//登录成功
    LoginFailed,//登录失败
    LoginOut,//登出
    
}AcconutStatusType;

typedef void(^AccountStatusObserverBlock)(AcconutStatusType statusType);

/**
 *  登录观察者管理
 */
@interface AccountStatusObserverManager : NSObject


+ (id)shareManager;

//添加观察者
- (void)addObserverBlock:(AccountStatusObserverBlock )block;

//移除登录状态观察者
- (void)removeObserverBlcok:(AccountStatusObserverBlock)block;
- (void)removeAllObserver;

- (BOOL)postNotifyWithAcconutStatusType:(AcconutStatusType)statusType;

@end
