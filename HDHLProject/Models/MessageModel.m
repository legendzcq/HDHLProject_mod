//
//  MessageModel.m
//  Carte
//
//  Created by zln on 14-9-9.
//
//

#import "MessageModel.h"
#import "MessageCenterModel.h"

@implementation MessageModel


- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super initWithDictionary:dict]) {
        NSArray *recodeJsonArray = dict[@"list"];
        NSMutableArray *recodeModelArray = [NSMutableArray array];
        for (id recodeJson in recodeJsonArray) {
            MessageCenterModel *messageModel = [[MessageCenterModel alloc] initWithDictionary:recodeJson];
            [recodeModelArray addObject:messageModel];
        }
        self.records = recodeModelArray;
    }
    return self;
}

@end
