//
//  VersionModel.h
//  Carte
//
//  Created by user on 14-5-12.
//
//

#import "BaseModelObject.h"
/**
 *  版本检测model
 */

@interface VersionModel : BaseModelObject

PROPERTY_STRONG NSString *up;      //是否强制更新 ，1强制，0不强制
PROPERTY_STRONG NSString *isnew;   //是否有新版本，1 有
PROPERTY_STRONG NSString *version; //版本号
PROPERTY_STRONG NSString *desc;    //新版描述

@end
