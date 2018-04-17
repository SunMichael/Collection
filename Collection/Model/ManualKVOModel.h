//
//  ManualKVOModel.h
//  Collection
//
//  Created by mac on 2018/4/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManualKVOModel : NSObject

@property(nonatomic ,copy) NSString *name;


- (NSInteger)age;
- (void)setAge:(NSInteger)age;

@end
