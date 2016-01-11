//
//  HHRequestResult
//
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "ITTRequestResult.h"


@implementation ITTRequestResult
///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

-(id)initWithCode:(NSString*)code withMessage:(NSString*)message{
    self = [super init];
    if (self) {
        if ([code isKindOfClass:[NSString class]]) {
            if ([code isEqualToString:@"1"]) {
                _code = @1;
            } else if ([code isEqualToString:@"-1"]) {
                _code = @(-1);
            } else {
                _code = @0;
            }
        } else {
            _code = @0;
        }
        _message = [message retain];
    }
    return self;
}

-(BOOL)isSuccess{
    return (_code && [_code intValue] == 1);
}

-(BOOL)isNoLogin {
    return (_code && [_code intValue] == -1);
}

-(void)showErrorMessage{
    if (_message && _message.length > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" 
                                                            message:_message
                                                           delegate:nil 
                                                  cancelButtonTitle:@"确定" 
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void)dealloc {
	[_code release];
    [_message release];
    [super dealloc];
}
@end
