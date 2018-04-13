//
//  PropertyController.h
//  Collection
//
//  Created by mac on 2018/4/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActionDelegate
- (void)action;

@end

@interface PropertyController : UIViewController

//normal
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,assign) NSInteger number;
@property (nonatomic ,strong) UIImage *image;
@property (nonatomic ,weak) id <ActionDelegate> delegate;


//special

@property (nonatomic ,assign) NSString *author;  //在使用时，会提示__unsafe
@property (nonatomic ,weak) NSString *company;



@end



/*
   常用的属性修饰符：
 @copy , 修饰不可变对象,copy出新的对象
 @assign , 修饰基本数据类型，修饰对象时容易造成野指针
 @strong , 强引用
 @weak , 弱引用，一般在解决循环引用时使用 （weak修饰的对象会被放到一个键值表中，对象的地址是key，当对象引用计数为0时，会在表中查找对应的对象，并置为nil）
 */
