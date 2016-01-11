//
//  BundleHelper.h
//  MinFramework
//
//  Bundle助手类
//
//  Created by ligh on 14-3-11.
//
//

#import <Foundation/Foundation.h>


/**
 * 设置全局bundle,默认为main bundle, 如多主题可以使用
 */
void SetDefaultBundle(NSBundle* bundle);

/**
 * 返回全局默认bundle
 */
NSBundle *GetDefaultBundle();


/**
 * 返回Documents资源路径
 */
NSString *PathForDocumentsResource(NSString* relativePath);


/**
 * 返回Cache资源路径
 */
NSString *PathForCacheResource(NSString* relativePath);

