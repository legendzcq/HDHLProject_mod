//
//  DataCacheManager.h
//  轻量级缓存管理器，利用UserDefault进行缓存管理，大数据量是效率有问题
//
//  Created by lian jie on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UD_KEY_DATA_CACHE_KEYS    @"UD_KEY_DATA_CACHE_KEYS"
#define UD_KEY_DATA_CACHE_OBJECTS @"UD_KEY_DATA_CACHE_OBJECTS"

#define DATA_CACHE_KEY_ALL_TOPIC_LIST     @"DATA_CACHE_KEY_ALL_TOPIC_LIST"
#define DATA_CACHE_KEY_MY_TOPIC_LIST      @"DATA_CACHE_KEY_MY_TOPIC_LIST"
#define DATA_CACHE_KEY_UPDATED_TOPIC_LIST @"DATA_CACHE_KEY_UPDATED_TOPIC_LIST"

typedef enum{
	DataCacheManagerCacheTypeMemory,
	DataCacheManagerCacheTypePersist
} DataCacheManagerCacheType;

@interface DataCacheManager : NSObject {
    NSMutableArray      *_memoryCacheKeys;    // keys for objects only cached in memory
    NSMutableDictionary *_memoryCacheObjects; // objects only cached in memory
    NSMutableArray      *_diskCacheKeys;      // keys for keys not managed by queue
    NSMutableDictionary *_diskCacheObjects;
}

+ (DataCacheManager *)sharedManager;
- (void)clearAllCache;
- (void)clearMemoryCache;
- (void)addObject:(NSObject *)obj forKey:(NSString*)key;
- (void)addObjectToMemory:(NSObject *)obj forKey:(NSString*)key;
- (NSObject *)getCachedObjectByKey:(NSString*)key;
- (BOOL)hasObjectInCacheByKey:(NSString*)key;
- (void)removeObjectInCacheByKey:(NSString*)key;
- (void)doSave;

@end
