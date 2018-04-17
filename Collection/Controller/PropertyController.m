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



@end


