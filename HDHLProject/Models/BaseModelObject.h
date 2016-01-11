//
//  BaseModelObject.h
//  HDHLProject
//
//  Created by Mac on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PROPERTY_STRONG @property (nonatomic, strong)
#define PROPERTY_COPY   @property (nonatomic, copy)
#define PROPERTY_ASSIGN @property (nonatomic, assign)

@interface BaseModelObject : NSObject <NSCoding>

//若果需要缓存，则必须实现的方法
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

- (id)initWithDictionary:(NSDictionary *)dict;
+ (NSArray *)objectsWithArrayOfDictionaries:(NSArray *)list;

#pragma mark - 字典与model反射
+ (NSArray *)reflectObjectsWithArrayOfDictionaries:(NSArray *)array;
+ (BaseModelObject *)reflectObjectsWithJsonObject:(NSObject *)dataSource;
- (BOOL)reflectDataFromJsonObject:(NSObject *)dataSource;
- (NSDictionary *)dictionaryFromProperties;
//该方法只限实现了 initWithDictionary: 方法并在内部处理部分数据（不是标准的反射处理）
+ (NSArray *)reflectArrayWithInitWithDictionary:(NSArray *)array;


//下两个方法需要子类实现,字典反射model时,需要通过此方法得到需要反射到哪个model类
- (Class)elementClassForArrayKey:(NSString *)key; //警告：model套model必须实现的方法
- (Class)classForDictionaryKey:(NSString *)key;


@end
