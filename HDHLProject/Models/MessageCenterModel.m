//
//  MessageCenterModel.m
//  Carte
//
//  Created by zln on 14-9-9.
//
//

#import "MessageCenterModel.h"

@implementation MessageCenterModel

- (void)dealloc
{
    RELEASE_SAFELY(_addtime);
    RELEASE_SAFELY(_content);
    RELEASE_SAFELY(_title);
    RELEASE_SAFELY(_message_id);
    RELEASE_SAFELY(_type);

}


@end
