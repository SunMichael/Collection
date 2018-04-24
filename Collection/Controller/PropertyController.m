//
//  PropertyController.m
//  Collection
//
//  Created by mac on 2018/4/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "PropertyController.h"

@interface PropertyController ()
{
    NSString *share;
}
@end

@implementation PropertyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self propertyMethod];
    
    [_author stringByAppendingString:@"DEF"];
    
//    if (_mAry.count > 0) {
//        [_mAry removeLastObject];
//        NSLog(@"mAry: %@",_mAry);
//    }
    
    NSLog(@" ary class : %@ ",NSStringFromClass([_ary class]));
}


- (void)propertyMethod{
    NSString *string = @"ABC";
    _author = string;

}


/**
 查找view自身所在的controller

 @param view view description
 @return return value description
 */
-(UIViewController *)findController:(UIView*)view
{
    id responder = view;
    while (responder){
        if ([responder isKindOfClass:[UIViewController class]]){
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

@end


