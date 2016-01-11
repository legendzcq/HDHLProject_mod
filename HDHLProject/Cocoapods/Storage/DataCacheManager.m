//
//  DataCacheManager.m
//  
//
//  Created by lian jie on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataCacheManager.h"
#import "ITTObjectSingleton.h"

@interface DataCacheManager()
- (void)registerMemoryWarningNotification;
- (void)restore;
- (BOOL)isValidKey:(NSString*)key;
- (void)removeKey:(NSString*)key fromKeyArray:(NSMutableArray*)keyArray;
@end

@implementation DataCacheManager

ITTOBJECT_SINGLETON_BOILERPLATE(DataCacheManager, sharedManager)
- (id)init {
    self = [super init];
    if(self) {
        [self registerMemoryWarningNotification];
        [self restore];
    }
    return self;
}

- (void)dealloc {
    RELEASE_SAFELY(_memoryCacheKeys);
    RELEASE_SAFELY(_memoryCacheObjects);
    RELEASE_SAFELY(_diskCacheKeys);
    RELEASE_SAFELY(_diskCacheObjects);
    [super dealloc];
}


#pragma mark -
#pragma mark - Private Methods
- (void)registerMemoryWarningNotification{
#if TARGET_OS_IPHONE
    // Subscribe to app events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearMemoryCache)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
#ifdef __IPHONE_4_0
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)] && device.multitaskingSupported){
        // When in background, clean memory in order to have less chance to be killed
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemoryCache)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
#endif
#endif
}

- (void)restore{
    //Momory
    _memoryCacheKeys    = [[NSMutableArray alloc] init];
    _memoryCacheObjects = [[NSMutableDictionary alloc] init];
    //Disk
    if ([KUserDefaults objectForKey:UD_KEY_DATA_CACHE_KEYS]) {
        NSArray *keysArray = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefaults objectForKey:UD_KEY_DATA_CACHE_KEYS]];
        _diskCacheKeys = [[NSMutableArray alloc] initWithArray:keysArray];
    } else {
        _diskCacheKeys = [[NSMutableArray alloc] init];
    }
    if ([KUserDefaults objectForKey:UD_KEY_DATA_CACHE_OBJECTS]) {
        NSDictionary *objDic = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:[KUserDefaults objectForKey:UD_KEY_DATA_CACHE_OBJECTS]];
        _diskCacheObjects = [[NSMutableDictionary alloc] initWithDictionary:objDic];
    } else {
        _diskCacheObjects = [[NSMutableDictionary alloc] init];
    }
}

- (BOOL)isValidKey:(NSString*)key {
    if (key == nil || key == NULL) {
        return NO;
    }
    if ([key isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([key isEqualToString:@""]) {
        return NO;
    }
    if ([[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return NO;
    }
    return YES;
}

- (void)removeKey:(NSString*)key fromKeyArray:(NSMutableArray*)keyArray {
//    NSInteger indexInKeys = NSNotFound;
//    for (int i = 0; i < [keyArray count]; i++) {
//        if ([keyArray[i] isEqualToString:key]) {
//            indexInKeys = i;
//            break;
//        }
//    }
//    if (indexInKeys != NSNotFound) {
//        [keyArray removeObjectAtIndex:indexInKeys];
//    }
    if([keyArray containsObject:key]) {
        [keyArray removeObject:key];
    }
}

#pragma mark -
#pragma mark - Public Methods

- (void)doSave {
    [KUserDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_diskCacheKeys] forKey:UD_KEY_DATA_CACHE_KEYS];
    [KUserDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_diskCacheObjects] forKey:UD_KEY_DATA_CACHE_OBJECTS];
    [KUserDefaults synchronize];
}

- (void)clearMemoryCache {
    [_memoryCacheKeys removeAllObjects];
    [_memoryCacheObjects removeAllObjects];
}

- (void)clearAllCache {
    [self clearMemoryCache];
    [_diskCacheKeys removeAllObjects];
    [_diskCacheObjects removeAllObjects];
    [self doSave];
}

- (void)addObjectToMemory:(NSObject *)obj forKey:(NSString *)key {
    if (![self isValidKey:key]) {
        return;
    }
    if (!obj || (NSNull*)obj == [NSNull null]) {
        return;
    }
    if ([self hasObjectInCacheByKey:key]) {
        [self removeObjectInCacheByKey:key];
    }
    [_memoryCacheKeys addObject:key];
    _memoryCacheObjects[key] = obj;
}

- (void)addObject:(NSObject*)obj forKey:(NSString*)key {
    if (![self isValidKey:key]) {
        return;
    }
    if (!obj || (NSNull*)obj == [NSNull null]) {
        return;
    }
    if ([self hasObjectInCacheByKey:key]) {
        [self removeObjectInCacheByKey:key];
    }
    [_diskCacheKeys addObject:key];
    _diskCacheObjects[key] = obj;
    [self doSave];
}

- (NSObject *)getCachedObjectByKey:(NSString*)key {
    if (![self isValidKey:key]) {
        return nil;
    }
    if (_memoryCacheObjects[key]) {
        return _memoryCacheObjects[key];
    } else {
        return _diskCacheObjects[key];
    }
}

- (BOOL)hasObjectInCacheByKey:(NSString *)key {
    return [self getCachedObjectByKey:key] != nil;
}

- (void)removeObjectInCacheByKey:(NSString *)key {
    if (![self isValidKey:key]) {
        return;
    }
    [_diskCacheObjects removeObjectForKey:key];
    [self removeKey:key fromKeyArray:_diskCacheKeys];
    [_memoryCacheObjects removeObjectForKey:key];
    [self removeKey:key fromKeyArray:_memoryCacheKeys];
    [self doSave];
}

@end




