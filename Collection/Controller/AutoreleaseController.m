//
//  AutoreleaseController.m
//  Collection
//
//  Created by mac on 2018/4/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "AutoreleaseController.h"

@interface AutoreleaseController ()
{
    __weak NSString *weak_string;
    __weak NSString *weak_auto_string;
    __weak NSString *weak_string2;
}
@end

@implementation AutoreleaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *string = [NSString stringWithFormat:@"ABC"];
    weak_string = string;
    
    @autoreleasepool{
        NSString *auto_string = [NSString stringWithFormat:@"CDE"];
        weak_auto_string = auto_string;
    }
    
    
    NSString *string2 = nil;
    @autoreleasepool {
        string2 = [NSString stringWithFormat:@"BCD"];
        weak_string2 = string2;
    }
    
    
    NSLog(@" __weak string view load : %@ , %@ ,%@  ", weak_string , weak_auto_string ,weak_string2);
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@" __weak string will appear : %@ , %@ ,%@  ", weak_string , weak_auto_string ,weak_string2);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSLog(@" __weak string did appear : %@ , %@ ,%@  ", weak_string , weak_auto_string ,weak_string2);
}



@end
