//
//  ITTBaseModelObject.m
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseModelObject.h"


static NSSet *_foundationClasses;

@implementation BaseModelObject


#pragma mark -
#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
  
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        Class c = [self class];
        while (c) {
            [self extensionDataWithClass:c WithDiction:dict];
            c =  class_getSuperclass([c class]);
            if([self isClassFromFoundation:c]){
                break ;
            }
        }
    }
    return self;
}
// 遍历到基类停止遍历
- (BOOL)isClassFromFoundation:(Class)c
{
    if(_foundationClasses == nil){
        _foundationClasses = [NSSet setWithObjects:
                              [NSObject class],
                              [NSURL class],
                              [NSDate class],
                              [NSNumber class],
                              [NSDecimalNumber class],
                              [NSData class],
                              [NSMutableData class],
                              [NSArray class],
                              [NSMutableArray class],
                              [NSDictionary class],
                              [NSMutableDictionary class],
                              [NSString class],
                              [NSMutableString class], nil];    }
    return [_foundationClasses containsObject:c];
}
//遍历赋值
- (void)extensionDataWithClass:(Class)c WithDiction:(NSDictionary *)dict
{
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([c class], &outCount);
    for (unsigned int i = 0; i< outCount; i++)
    {
        Ivar ivar = ivars[i];
        NSString *code = @(ivar_getTypeEncoding(ivar));//属性类型
        NSString *propertyName =@(ivar_getName(ivar));//属性名字
        if([code isEqual:@"NSArray"]){
            [self extensionWithPropertyName:propertyName WithDictiony:dict WithClass:c];//数组解析
            return ;
        }
        // 2.属性名
        if ([propertyName hasPrefix:@"_"]) {
            propertyName = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
        }         
        SEL sel = [self getSetterSelWithAttibuteName:propertyName];
        if([self respondsToSelector:sel])
        {
            NSString *value = [dict stringForKey:propertyName];
            [self performSelectorOnMainThread:sel //设置属性值
                                   withObject:value
                                waitUntilDone:[NSThread isMainThread]];
        }
    }
}
- (void)extensionWithPropertyName:(NSString *)properName WithDictiony:(NSDictionary *)dict WithClass:(Class)c
{
    NSMutableArray *array = [self getDataArrayWithProperName:properName];
    for (NSDictionary *dataDic in [dict objectForKey:[properName lowercaseString]]) {
        BaseModelObject * a = [[[self getClassWithPropertyName:properName] alloc]init];
        [a extensionDataWithClass:c WithDiction:dataDic];
        [array addObject:a];
    }
    if(!array.count){
        return ;
    }
    SEL sel = [self getSetterSelWithAttibuteName:properName];
    if([self respondsToSelector:sel])
    {
        [self performSelectorOnMainThread:sel
                               withObject:array
                            waitUntilDone:[NSThread isMainThread]];
    }
}
- (Class)getClassWithPropertyName:(NSString *)properName
{
    return nil ;
}

- (NSMutableArray *)getDataArrayWithProperName:(NSString *)properName
{
    return nil ;
}


-(SEL)getSetterSelWithAttibuteName:(NSString*)attributeName{
    NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
    NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:",capital,[attributeName substringFromIndex:1]];
    return NSSelectorFromString(setterSelStr);
}

+ (NSArray *)objectsWithArrayOfDictionaries:(NSArray *)array
{
    NSMutableArray *objects = [NSMutableArray array];
    
    if (array && [array isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in array) {
            if (![dict isKindOfClass:[NSDictionary class]]) {
                continue; 
            }
            id instance = [[self alloc] initWithDictionary:dict];
            if (instance != nil) {
                [objects addObject:instance];
            }
        }
    }
    
    return objects;
}

#pragma mark - 反射
+ (NSArray *)reflectObjectsWithArrayOfDictionaries:(NSArray *)array
{
    NSMutableArray *objects = [NSMutableArray array];
    
    if (array && [array isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in array) {
            if (![dict isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            BaseModelObject *instance = [[self alloc] init];
            [instance reflectDataFromJsonObject:dict];
            if (instance != nil) {
                [objects addObject:instance];
            }
        }
    }
    
    return objects;
}

+ (BaseModelObject *)reflectObjectsWithJsonObject:(NSObject *)dataSource {
    BaseModelObject *instance = [[self alloc] init];
    [instance reflectDataFromJsonObject:dataSource];
    if (instance != nil) {
        return instance;
    }
    return nil;
}

- (BOOL)reflectDataFromJsonObject:(NSObject *)dataSource
{
    BOOL ret = NO;
    if (dataSource == nil) {
        return ret;
    }
    for (NSString *key in [self propertyKeys]) {
        if ([dataSource isKindOfClass:[NSDictionary class]])
            ret = ([dataSource valueForKey:key]==nil)?NO:YES;
        else
            ret = [dataSource respondsToSelector:NSSelectorFromString(key)];
        if (ret) {
            id propertyValue = [dataSource valueForKey:key];
            //该值不为NSNULL，并且也不为nil
            if ([propertyValue isKindOfClass:[NSArray class]]) {
                Class aClass = [self elementClassForArrayKey:key];
                NSArray *elementObjects = [aClass reflectObjectsWithArrayOfDictionaries:propertyValue];
                [self setValue:elementObjects forKey:key];
            }
            else if ([propertyValue isKindOfClass:[NSDictionary class]]) {
                Class aClass = [self classForDictionaryKey:key];
                BaseModelObject *object = [[aClass alloc] init];
                [object reflectDataFromJsonObject:propertyValue];
                [self setValue:object forKey:key];
            }
            else if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil) {
                if([propertyValue isKindOfClass:[NSNumber class]]) {
                    [self setValue:[(NSNumber *)propertyValue stringValue] forKey:key];
                }
                else if ([propertyValue isKindOfClass:[NSString class]]) {
                    [self setValue:propertyValue forKey:key];
                }
                else {
                    [self setValue:nil forKey:key];
                }
            }
        }
    }
    return ret;
}

- (NSDictionary *)dictionaryFromProperties
{
    return [self dictionaryDescriptionForClassType:[self class]];
}

- (Class)elementClassForArrayKey:(NSString *)key
{
    return [BaseModelObject class];
}

- (Class)classForDictionaryKey:(NSString *)key
{
    return [BaseModelObject class];
}

+ (NSArray *)reflectArrayWithInitWithDictionary:(NSArray *)array {
    NSMutableArray *objects = [NSMutableArray array];
    
    if (array && [array isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in array) {
            if (![dict isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            BaseModelObject *instance = [[self alloc] initWithDictionary:dict];
            if (instance != nil) {
                [objects addObject:instance];
            }
        }
    }
    return objects;
}

#pragma mark - private
- (NSArray *)propertyKeys
{
    //    unsigned int outCount, i;
    //    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    //    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    //    for (i = 0; i < outCount; i++) {
    //        objc_property_t property = properties[i];
    //        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
    //        [keys addObject:propertyName];
    //    }
    //    free(properties);
    //    return keys;
    return [self propertyKeysForClassType:[self class]];
}

- (NSArray *)propertyKeysForClassType:(Class)classType
{
    NSMutableSet * result = [NSMutableSet setWithCapacity:0];
    Class superClass  = class_getSuperclass(classType);
    if  ( superClass != nil && ![superClass isEqual:[NSObject class]])
    {
        [result addObjectsFromArray:[self propertyKeysForClassType:superClass]];
    }
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(classType, &outCount);
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    free(properties);
    [result addObjectsFromArray:keys];
    return result.allObjects;
}

- (NSDictionary *)dictionaryDescriptionForClassType:(Class)classType  {
    NSMutableDictionary * result = [NSMutableDictionary dictionaryWithCapacity:0];
    Class superClass  = class_getSuperclass(classType);
    if  ( superClass != nil && ![superClass isEqual:[NSObject class]])
    {
        [result addEntriesFromDictionary:[self dictionaryDescriptionForClassType:superClass]];
    }
    unsigned int          property_count;
    objc_property_t * property_list = class_copyPropertyList(classType, (unsigned int *)&property_count);
    
    for (NSInteger i = (NSInteger)property_count - 1; i >= 0; --i) {
        objc_property_t property = property_list[i];
        
        const char * property_name = property_getName(property);
        
        NSString * propertyName = [NSString stringWithCString:property_name encoding:NSASCIIStringEncoding];
        if (propertyName) {
            id value = [self valueForKey:propertyName];
            if (value) {
                if ([value isKindOfClass:[NSArray class]]) {
                    NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
                    for (id valueMember in value) {
                        NSDictionary *populatedMember = [valueMember dictionaryFromProperties];
                        [myMembers addObject:populatedMember];
                    }
                    
                    value = myMembers;
                    [result setObject:value forKey:propertyName];
                }
                else {
                    [result setObject:value forKey:propertyName];
                }
            }
            
        }
    }
    free(property_list);
    return result;
}

@end
