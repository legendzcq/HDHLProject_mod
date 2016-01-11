//
//  DataEnvironment.h
//
//  Copyright 2010 itotem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataEnvironment : NSObject
{
    NSString *_urlRequestHost;
}
@property (nonatomic,retain) NSString *urlRequestHost;

+ (DataEnvironment *)sharedDataEnvironment;

- (void)clearNetworkData;
- (void)clearCacheData;
@end
