//
//  BundleHelper.m
//  MinFramework
//
//  Created by ligh on 14-3-11.
//
//


static NSBundle* globalBundle = nil;

/**
 * 设置全局bundle,默认为main bundle, 如多主题可以使用
 */
void SetDefaultBundle(NSBundle* bundle)
{
    globalBundle = bundle;
}

/**
 * 返回全局默认bundle
 */
NSBundle *GetDefaultBundle()
{
    return (nil != globalBundle) ? globalBundle : [NSBundle mainBundle];
}

/**
 * 返回bundle资源路径
 */

NSString *PathForBundleResource(NSString* relativePath) {
    NSString* resourcePath = [GetDefaultBundle() resourcePath];
    return [resourcePath stringByAppendingPathComponent:relativePath];
}

/**
 * 返回Documents资源路径
 */
NSString *PathForDocumentsResource(NSString* relativePath)
{
    static NSString* documentsPath = nil;
    if (nil == documentsPath) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsPath = dirs[0];
    }
    return [documentsPath stringByAppendingPathComponent:relativePath];
}


/**
 * 返回Cache资源路径
 */
NSString *PathForCacheResource(NSString* relativePath)
{
    static NSString* documentsPath = nil;
    if (nil == documentsPath) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        documentsPath = dirs[0];
    }
    return [documentsPath stringByAppendingPathComponent:relativePath];
}


