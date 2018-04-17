//
//  KVOController.m
//  Collection
//
//  Created by mac on 2018/4/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "KVOController.h"
#import "ManualKVOModel.h"
@interface KVOController ()
{
    ManualKVOModel *model;
}
@end

@implementation KVOController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self manualKVO];
}

- (void)manualKVO{
    //对于对象成员变量的监听，需要手动来实现
    model = [[ManualKVOModel alloc] init];
    model.name = @"sun";
    model.age = 18;
    
    [model addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    model.name = @"newName";
    
    [model addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
    model.age = 20;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@" kvo change : %@ ",change);
}

- (void)dealloc{
    [model removeObserver:self forKeyPath:@"name"];
    [model removeObserver:self forKeyPath:@"age"];
}

@end
