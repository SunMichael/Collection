//
//  RuntimeController.m
//  Collection
//
//  Created by mac on 2018/4/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "RuntimeController.h"
#import "Robot.h"
#import <objc/runtime.h>

@interface RuntimeController ()

@end

@implementation RuntimeController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getIvarList];
    [self getMethodList];
    [self exchangeMethod];
    
    [self objc_msgSend];
    
    [self creatClass];
}

- (void)objc_msgSend{       //对象调用方法的流程源码在下面注释
    NSString *string = nil;
    string = [string stringByAppendingString:@"a"];
}

/*  ====   objc_msgSend 对nil对象发消息返回nil   ===
 *
 *
 //向对象发送消息
 id objc_msgSend(id self, SEL op, ...) {
 if (!self) return nil;
 IMP imp = class_getMethodImplementation(self->isa, SEL op);
 imp(self, op, ...); //调用这个函数，伪代码...
 }
 
 //查找IMP
 IMP class_getMethodImplementation(Class cls, SEL sel) {
 if (!cls || !sel) return nil;
 IMP imp = lookUpImpOrNil(cls, sel);
 if (!imp) return _objc_msgForward; //_objc_msgForward 用于消息转发
 return imp;
 }
 
 IMP lookUpImpOrNil(Class cls, SEL sel) {
 if (!cls->initialize()) {
 _class_initialize(cls);
 }
 
 Class curClass = cls;
 IMP imp = nil;
 do { //先查缓存,缓存没有时重建,仍旧没有则向父类查询
 if (!curClass) break;
 if (!curClass->cache) fill_cache(cls, curClass);
 imp = cache_getImp(curClass, sel);
 if (imp) break;
 } while (curClass = curClass->superclass);
 
 return imp;
 }
 *
 *
 */




- (void)getIvarList{
    Robot *robot = [Robot new];
    robot.name = @"shadow";
    robot.company = @"sun";
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([Robot class], &count);   //成员变量列表
    for (unsigned int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSLog(@"成员变量: %@",name);
    }
    
    Ivar ivar = class_getInstanceVariable([Robot class], "_name");   //获取指定的成员变量, 此处使用_name 因为Robot此时已经由属性name自动生成了_name变量
    object_setIvar(robot, ivar, @"robotdog");      //给成员变量赋值
    NSLog(@" %@ == %@ ",robot.name , object_getIvar(robot, ivar));
    free(ivars);
    
}

- (void)getMethodList{
    unsigned int count;
    Method *methods = class_copyMethodList([Robot class], &count);
    for (unsigned int i = 0 ; i < count; i++) {
        Method method = methods[i];
        SEL sel = method_getName(method);
//        IMP imp = method_getImplementation(method);   //方法实现
        
        NSLog(@"类的方法: %@", NSStringFromSelector(sel));
    }
    free(methods);
}

- (void)exchangeMethod{
//    class_getClassMethod(Class  _Nullable __unsafe_unretained cls, SEL  _Nonnull name) //获取类方法
    Method run = class_getInstanceMethod([Robot class], @selector(run));     //获取对象的方法
    Method walk = class_getInstanceMethod([Robot class], @selector(walk));
    method_exchangeImplementations(run, walk);
    
    Robot *robot = [[Robot alloc]init];
    [robot run];
    [robot walk];
}

void userRunImp(id self, SEL _cmd, NSDictionary *dic){
    NSLog(@"imp接受到的dic: %@",dic);
    id obj = object_getIvar(self, class_getInstanceVariable([self class], "name"));
    NSLog(@"成员变量: %@", obj);
}

- (void)creatClass{    //动态创建一个类，添加变量和方法
    
    Class cls = objc_allocateClassPair([NSObject class], "UserClass", 0);
    
    class_addIvar(cls, "name", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
    class_addIvar(cls, "age", sizeof(int), sizeof(int), @encode(int));
    
    SEL sel = sel_registerName("userRun");
    class_addMethod(cls, sel, (IMP)userRunImp, "i@:@");
    
    /*   第三个参数格式说明
     *
     ”v@:”意思就是这已是一个void类型的方法，没有参数传入。
     “i@:”就是说这是一个int类型的方法，没有参数传入。
     ”i@:@”就是说这是一个int类型的方法，有一个参数传入。
     *
     */
    
    objc_registerClassPair(cls);
    
    
    id user = [[cls alloc] init];
    NSString *className = NSStringFromClass(object_getClass(user));
    NSLog(@"对象的类: %@",className);
    
    Ivar nameIvar = class_getInstanceVariable(cls, "name");   //这里的变量名称要使用name，因为是runtime自己生成的变量name，并不是属性来的_name
    [user setValue:@"chris" forKey:@"name"];
    
    Ivar ageIvar = class_getInstanceVariable(cls, "age");
    object_setIvar(user, ageIvar, @20);
    
    
    NSLog(@"user 属性值: %@ %@",object_getIvar(user, nameIvar), object_getIvar(user, ageIvar));
    
    NSDictionary *dic = @{@"key1": @"value1"};
    id result = [user performSelector:@selector(userRun) withObject:dic];
    NSLog(@" 方法返回: %@ ",result);
}



@end


/*
 Ivar是objc_ivar的指针，objc_ivar的本质是struct，里面主要有ivar_name, ivar_type
 
  先从class中取instanceVariable ,也就是成员变量的ivar ,然后对其的操作 object_getIvar() ,object_setIvar
 
 */


/*
 *******   属性和成员变量的区别   *******
 
 
 ***   首先Class的实质是struct 里面的内容有   ***
 
 struct objc_class {
 Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
 
 #if !__OBJC2__
 Class _Nullable super_class                              OBJC2_UNAVAILABLE;
 const char * _Nonnull name                               OBJC2_UNAVAILABLE;
 long version                                             OBJC2_UNAVAILABLE;
 long info                                                OBJC2_UNAVAILABLE;
 long instance_size                                       OBJC2_UNAVAILABLE;
 struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE;
 struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;
 struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;
 struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;
 #endif
 }
 
 主要是有objc_ivar_list ,objc_method_list 所以属性可以看成是 成员变量 + setget = 属性
 
 
 ***   对象的实质内容   ***
 struct objc_object {
 Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
 };
 
 对象里面有isa指针，指向它的class，class里面有objc_ivar_list（成员变量列表），objc_method_list（对象方法列表）
 */


/*
struct objc_ivar {
    char * _Nullable ivar_name                               OBJC2_UNAVAILABLE;
    char * _Nullable ivar_type                               OBJC2_UNAVAILABLE;
    int ivar_offset                                          OBJC2_UNAVAILABLE;
#ifdef __LP64__
    int space                                                OBJC2_UNAVAILABLE;
#endif
}                                                            OBJC2_UNAVAILABLE;
*/

/*
struct objc_ivar_list {
    int ivar_count                                           OBJC2_UNAVAILABLE;
#ifdef __LP64__
    int space                                                OBJC2_UNAVAILABLE;
#endif
    struct objc_ivar ivar_list[1]                            OBJC2_UNAVAILABLE;
}                                                            OBJC2_UNAVAILABLE;
*/

/*
struct objc_method {
    SEL _Nonnull method_name                                 OBJC2_UNAVAILABLE;
    char * _Nullable method_types                            OBJC2_UNAVAILABLE;
    IMP _Nonnull method_imp                                  OBJC2_UNAVAILABLE;
}                                                            OBJC2_UNAVAILABLE;
*/

/*
struct objc_method_list {
    struct objc_method_list * _Nullable obsolete             OBJC2_UNAVAILABLE;
    
    int method_count                                         OBJC2_UNAVAILABLE;
#ifdef __LP64__
    int space                                                OBJC2_UNAVAILABLE;
#endif
    struct objc_method method_list[1]                        OBJC2_UNAVAILABLE;
}
*/




















