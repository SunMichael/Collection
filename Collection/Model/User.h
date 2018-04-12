//
//  User.h
//  Collection
//
//  Created by mac on 2018/4/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject  <NSCopying>

@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) int age;
@property(nonatomic, strong) NSString *location;



@end
