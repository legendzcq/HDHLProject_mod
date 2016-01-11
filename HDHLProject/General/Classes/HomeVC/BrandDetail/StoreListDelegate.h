//
//  StroeListDelegate.h
//  Carte
//
//  Created by ligh on 14-9-15.
//
//

#import <Foundation/Foundation.h>
#import "StoreModel.h"

//当商家被选中时 调用此delegate
@protocol StoreListDelegate <NSObject>

-(void) didSelectedStoreModel:(StoreModel *) storeModel;

@end
