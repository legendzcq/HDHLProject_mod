//
//  VersionDetectionRequest.m
//  Carte
//
//  Created by user on 14-5-12.
//
//

#import "VersionDetectionRequest.h"

@implementation VersionDetectionRequest

- (NSString *)getRequestUrl {
    return [NSString stringWithFormat:@"api.php?&apiUrl=versionCheck&"];
}

- (void)processResult {
    [super processResult];
    VersionModel *versionModel = (VersionModel *)[VersionModel reflectObjectsWithJsonObject:self.resultDic[@"data"]];
    [self.resultDic setObject:versionModel forKey:KRequestResultDataKey];
}

@end
