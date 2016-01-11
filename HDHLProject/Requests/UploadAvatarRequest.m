//
//  UploadAvatarRequest.m
//  Carte
//
//  Created by ligh on 14-5-9.
//
//

#import "UploadAvatarRequest.h"

@implementation UploadAvatarRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=faceSet&"];
    
}

@end
