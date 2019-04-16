


//
//  CopyController.m
//  Collection
//
//  Created by mac on 2018/4/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "CopyController.h"
#import "User.h"
#import "config.h"

@interface CopyController ()

@end


@implementation CopyController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"--- %p , %p ,%p ,%p ",_cString ,_sString , _cmString ,_smString);
    
    _cString = @"newCopyString";
    _sString = @"newStrongString";
    
//    [_cmString replaceCharactersInRange:NSMakeRange(0, 3) withString:@"new"];
    [_smString replaceCharactersInRange:NSMakeRange(0, 3) withString:@"new"];
    
    NSLog(@"--- %p , %p ,%p ,%p ",_cString ,_sString , _cmString ,_smString);
    
    
    
//    [self aryCopyMethod];
//    [self maryCopyMethod];
    
    [self copyUserMethod];
    
//    [self aryCopy];
//    [self stringCopy];
}

- (void)aryCopyMethod{
    
    NSArray *imAry = [[NSArray alloc] initWithObjects:@"A",@"B",@"C", nil];
    
    id imAry2 = [imAry copy];        
    
    NSLog(@" imAry: %p  \n imAry2: %p", imAry , imAry2);
    
    NSLog(@" obj1: %p  \n imAry2: %p", imAry[0] , imAry2[0]);
    
    id mAryCopy2 = [imAry mutableCopy];
    
    NSLog(@" imAry: %p  \n mAryCopy2: %p", imAry , mAryCopy2);
    
    NSLog(@" obj1: %p  \n mAryCopy2: %p", imAry[0] , mAryCopy2[0]);
    
}

- (void)maryCopyMethod{
    NSMutableArray *mAry = [[NSMutableArray alloc] initWithObjects:@"A",@"B",@"C", nil];
    
    id mAry2 = [mAry copy];
    
    NSLog(@" imAry: %p  \n imAry2: %p", mAry , mAry2);
    
    NSLog(@" obj1: %p  \n imAry2: %p", mAry[0] , mAry2[0]);
    
    id mAryCopy2 = [mAry mutableCopy];
    
    NSLog(@" imAry: %p  \n mAryCopy2: %p", mAry , mAryCopy2);
    
    NSLog(@" obj1: %p  \n mAryCopy2: %p", mAry[0] , mAryCopy2[0]);
}

- (void)copyUserMethod{
    
    // 对比 copy和strong 修饰的属性的区别
    User *user = [[User alloc] init];
    NSMutableString *mName = [[NSMutableString alloc] initWithString:@"A"];
    id obj = [mName copy];
    NSLog(@" %p %p , %@ ",mName ,obj ,NSStringFromClass([obj class]));
    user.name = mName;
    user.mString = mName;
    [mName appendString:@"B"];
    RetainCount(mName)
    
    NSLog(@"user.name: %@ ",user.name);
    NSLog(@" mName:%p \n name:%p ", mName , user.name);
    
    NSMutableString *mLocation = [[NSMutableString alloc] initWithString:@"hz"];
    user.location = mLocation;
    [mLocation appendString:@"xihu"];
    RetainCount(mLocation)
    
    NSLog(@"user.location: %@ ",user.location);
    NSLog(@" mName:%p \n location:%p ", mLocation , user.location);
    
    User *copyUser = [user copy];
    NSLog(@" user:%p \n copy:%p ", user , copyUser);
    RetainCount(user)
    
    [mLocation appendString:@"wensan"];
    NSLog(@" user.location:%@ \n copy.location:%@ ", user.location , copyUser.location);
    NSLog(@" user.location:%p \n copy.location:%p ", user.location , copyUser.location);
    NSLog(@" user.name:%p \n copy.name:%p ", user.name , copyUser.name);
    
    User *user2 = user;
    NSLog(@" user:%p \n user2:%p ", user , user2);
}


/**
 数组的深浅拷贝
 */
- (void)aryCopy{
    NSMutableArray *allAry = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        User *model = [User new];
        model.name = [NSString stringWithFormat:@"%ld",(long)i];
        [allAry addObject:model];
        NSLog(@" model %p ", model);
    }
    
    NSMutableArray *copyAry = [allAry copy];
    NSLog(@" %p , %p , %p ",  allAry, copyAry, copyAry[0]);
    
    NSMutableArray *copyAry2= [[NSMutableArray alloc] initWithArray:allAry copyItems:YES];
    NSLog(@" %p , %p , %p ", allAry, copyAry, copyAry2[0]);
}


/**
  taggedPointer
 */
- (void)stringCopy{
    NSString *string = @"a";
    NSString *string2 = string;
    NSLog(@" %p , %p ",string ,string2);
<<<<<<< Updated upstream
    string = nil;
    NSLog(@" %@ , %p ",[string stringByAppendingString:@"x"] ,[string2 stringByAppendingString:@"a"]);
    
    
    
    
=======
    string = @"b";
    NSLog(@" %p , %p ",string ,string2);
//    NSLog(@" %@ , %p ",[string stringByAppendingString:@"x"] ,[string2 stringByAppendingString:@"a"]);
>>>>>>> Stashed changes
}

/*
 *  总结: 在对集合的 copy（指针引用。共享一片内存地址） mutableCopy（会产生新的内存地址）
 
 *  1.对可变集合copy，产生的对象都是不可变的，对不可变集合copy不产生新对象
 *  2.对可变集合，不可变集合的mutableCopy，产生的对象都是可变的
 *
 *
 *  不可变对象copy，是浅拷贝，也就是说指针引用；发送mutableCopy，是深复制，也就是说内容复制;
 *  可变对象copy和mutableCopy均是单层深拷贝，也就是说单层的内容拷贝；      //拷贝后集合内的对象不变。指向同一个
 
 *  属性在使用copy修饰时，当外部赋值时会拷贝新的，相当于2份，所以当外部改变时copy，不会影响里面的值
 *  属性在使用strong修饰时，外部赋值时是指针引用，指向的是同一份。所以外部改变时，里面也会跟着改变
 
 *  在对自定义class对象copy时是单层深复制(和可变集合一样)，会产生新的内存地址，但对象的属性指向的是同一个
 
 
 */




@end
