//
//  KVCController.m
//  Collection
//
//  Created by mac on 2018/4/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "KVCController.h"
#import "KVCModel.h"
@implementation KVCController
{
    KVCModel *model;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self kvcMethod];
    [self operator];
}

- (void)kvcMethod{
    model = [KVCModel new];
    model.name = @"name";
    
    [model  setValue:@"newName" forKey:@"newName"];  //属性没有声明，找对应的成员变量赋值_xx,isxx等
    [model setValue:@"password" forKey:@"password"];
    
    NSString *name = [model valueForKey:@"newName"];
    NSLog(@" model name: %p %@",model.name ,name);
    
    id value = [model valueForKey:@"name"];
    NSLog(@" name value: %@ ",value);
    
    id obj = [model valueForKey:@"mykey"];
    NSLog(@" undefine key:  %@", NSStringFromClass([obj class]));
    NSLog(@"index: %@ %@ %@",obj[0], obj[1], obj[2]);
    
    [model addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    model.name = @"changedName";
    NSLog(@"changed name: %p",model.name);
        
    [model addObserver:self forKeyPath:@"items" options:NSKeyValueObservingOptionNew context:nil];
    
    [model.items addObject:@"A"];
    
    [model addItem];
    
    [model addItemObserver];  //此方法执行完items的内存地址和之前执行的会不同
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@" model change: %@ ", change);
}

- (void)dealloc{
    [model removeObserver:self forKeyPath:@"name" context:nil];
    [model removeObserver:self forKeyPath:@"items" context:nil];
}


- (void)operator{
    NSMutableArray *allAry = [NSMutableArray array];
    for (NSInteger i = 1; i < 10 ; i++) {
        Product *model = [Product new];
        model.name = [NSString stringWithFormat:@"product%ld",i];
        model.price = @(i);
        [allAry addObject:model];
    }
    //集合操作符
    id max = [allAry valueForKeyPath:@"@max.price"];
    id count = [allAry valueForKeyPath:@"@count"];

    //对象操作符
    id ary = [allAry valueForKeyPath:@"unionOfObjects.name"];         //不去重
    id sortAry = [allAry valueForKeyPath:@"distinctUnionOfObjects.name"];  //去重
    
    NSLog(@"operator : %@, %@ ,%@ ,%@",max ,count ,ary, sortAry);
    
}


/*                  === KVC执行过程 ===
 *  1.+ (BOOL)accessInstanceVariablesDirectly, 默认返回YES，表示如果没有找到Set<Key>方法的话，会按照_key，_iskey，key，iskey的顺序搜索成员，设置成NO就不这样搜索
 
 *  2.执行setValue: forKey: , 会查找该类是否有-setKey:方法，_key成员变量，isKey变量等不管该变量是什么样的访问修饰符，如果存在就对其赋值
 
 *  3.如果不存在，那么调用- (void)setValue:(id)value forUndefinedKey:(NSString *)key 方法，super的该方法的实现是抛出异常
 
 
 *  4.执行valueForKey:时，会先查找-getKey: -isKey: 等方法，如果上面方法不存在，会返回一个NSKeyValueArray代理集合，
      -objectInNumbersAtIndex的实现就是，该集合获取index元素的实现
 
 
                    ===  KVC与集合  ===
       KVO依赖KVC来实现，KVO是对类对象某个属性的内存地址或常量改变
 
 *  如果直接对类对象的集合items进行监听，会发现items改变前后内存地址不变(一般属性NSString这种会变)，这样KVO不会有监听返回。
 *  使用 mutableArrayValueForKey:来获取集合，再改变就能被监听
 
 
 *  访问，修改私有属性的2种方式，KVC和runtime获取属性名使用object_setIvar
 */



@end
