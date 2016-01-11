//
//  QRCodeModel.h
//  Carte
//
//  Created by zln on 15/1/7.
//
//

#import "BaseModelObject.h"

@interface QRCodeModel : BaseModelObject

@property (nonatomic,retain) NSString *img;
@property (nonatomic,retain) NSString *brand_name;
@property (nonatomic,retain) NSString *share_content;

@end
