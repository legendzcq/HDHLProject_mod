//
//  PicturePreviewVC.h
//  Carte
//
//  Created by ligh on 14-4-16.
//
//

#import "BetterVC.h"
#import "ImageModel.h"

@interface PicturePreviewVC : BetterVC

-(id) initWithImageModelArray:(NSArray *) imageModelArray selectedIndex:(NSInteger) index;

@end
