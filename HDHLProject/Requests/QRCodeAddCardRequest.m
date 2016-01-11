//
//  QRCodeAddCardRequest.m
//  Carte
//
//  Created by hdcai on 15/4/18.
//
//

#import "QRCodeAddCardRequest.h"

@implementation QRCodeAddCardRequest
- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=qrScan&"];
}
@end
