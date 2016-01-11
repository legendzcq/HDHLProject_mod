//
//  MessageStatusChangeRequest.m
//  Carte
//
//  Created by zln on 14-9-11.
//
//

#import "MessageStatusChangeRequest.h"
#import "MessageModel.h"
#import "MessageCenterModel.h"

@implementation MessageStatusChangeRequest


- (NSString *)getRequestUrl
{
    return [NSString stringWithFormat:@"api.php?apiUrl=messageChange&"];
}

- (void)processResult
{
    [super processResult];
    if (self.isSuccess)
    {
        PageModel *pageModel = [[PageModel alloc] initWithDictionary:self.resultDic[@"data"]];
        NSArray *messageJSONArray = self.resultDic[@"data"][@"list"];
        NSMutableArray *messageArray = [NSMutableArray array];
        for ( id dic  in messageJSONArray){
            MessageCenterModel *messageModel = [[MessageCenterModel alloc] initWithDictionary:dic];
            [messageArray addObject:messageModel];
        }
        pageModel.listArray = messageArray;
        [self.resultDic removeObjectForKey:@"data"];
        [self.resultDic setObject:pageModel forKey:KRequestResultDataKey];
    }
}

@end
