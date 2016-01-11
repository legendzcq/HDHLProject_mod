//
//  QRCodeRequest.m
//  Carte
//
//  Created by zln on 15/1/7.
//
//

#import "QRCodeRequest.h"
#import "QRCodeModel.h"

@implementation QRCodeRequest

- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=storeQRCode&"];
    
}


- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}

- (void)processResult
{
    [super processResult];
    QRCodeModel *qrCodeModel = (QRCodeModel*)[QRCodeModel reflectObjectsWithJsonObject:self.resultDic[@"data"]];
    [self.resultDic setObject:qrCodeModel forKey:KRequestResultDataKey];
}

@end
