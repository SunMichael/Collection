//
//  DynamicController.m
//  Collection
//
//  Created by mac on 2018/4/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "DynamicController.h"

@interface DynamicController ()     //类的拓展

@end

@implementation DynamicController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self dynamicMethod];
}

- (void)dynamicMethod{
    BookModel *model = [BookModel new];
    model.name = @"bookname";
    model.author = @"as";
    
    NSLog(@"model: %@ \n%@",model.description,model.debugDescription);
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIButton *button =  [UIButton buttonWithFrame:CGRectMake(size.width/2 - 50.f, 200.f, 100.f, 100.f) title:@"点击按钮" actionBlock:^(UIButton *sender) {
        NSLog(@" 点击按钮... ");
    }];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end

#import <objc/runtime.h>

@implementation BookModel

@dynamic author;               //手动实现set get方法，如果方法不存在抛出异常
@synthesize name = _name;       //自动生成set get方法, 如果重写的set，get方法 _xxx变量不会自动生成

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setAuthor:(NSString *)author{
    objc_setAssociatedObject(self, "author", author, OBJC_ASSOCIATION_COPY);
}

- (NSString *)author{
    return objc_getAssociatedObject(self, "author");
}

@end



@implementation UIButton (Action)         //类的分类

@dynamic block;     //在分类中添加了新的属性，一定要写@dynamic,否则会⚠️

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title actionBlock:(Action)block{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(button, "action", block, OBJC_ASSOCIATION_COPY);
    
    return button;
}

- (void)clicked:(UIButton *)sender{
    Action block = objc_getAssociatedObject(sender, "action");
    if (block) {
        block(sender);
    }else{
        block(nil);
    }
}

@end


/*
 *
 * @dynamic 关键字一般用在给类做拓展使用，因为一般系统定义的类在分类中无法添加成员变量来存储变量，所以通过关联对象来实现
 *
 * 类的拓展是在编译时添加到类中的，而分类是在运行时添加的. 运行时对象的内存已经决定，所以不能再添加成员变量
 */














