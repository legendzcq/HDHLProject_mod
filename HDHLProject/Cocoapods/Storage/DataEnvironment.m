//
//  DataEnvironment.m
//  
//
//  Copyright 2010 itotem. All rights reserved.
//


#import "DataEnvironment.h"
#import "DataCacheManager.h"
#import "ITTObjectSingleton.h"
@interface DataEnvironment()
- (void)restore;
- (void)registerMemoryWarningNotification;
@end
@implementation DataEnvironment

ITTOBJECT_SINGLETON_BOILERPLATE(DataEnvironment, sharedDataEnvironment)

#pragma mark - lifecycle methods
- (id)init{
    self = [super init];
	if ( self) {
		[self restore];
        [self registerMemoryWarningNotification];
	}
	return self;
}

-(void)clearNetworkData{
    [[DataCacheManager sharedManager] clearAllCache];
}

- (void)dealloc{
    RELEASE_SAFELY(_urlRequestHost);
	[super dealloc];
}
#pragma mark - public methods
- (void)clearCacheData{
    //clear cache data if needed
}

#pragma mark - private methods
- (void)restore{
    _urlRequestHost = [Host_Url retain];
}
- (void)registerMemoryWarningNotification{
#if TARGET_OS_IPHONE
    // Subscribe to app events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearCacheData)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];    
#ifdef __IPHONE_4_0
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)] && device.multitaskingSupported){
        // When in background, clean memory in order to have less chance to be killed
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearCacheData)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
#endif
#endif        
}

@end