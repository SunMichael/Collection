//
//  Robot.h
//  Collection
//
//  Created by mac on 2018/4/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Robot : NSObject
{
    NSInteger num;
}
@property(nonatomic ,copy) NSString *name;
@property(nonatomic ,copy) NSString *company;

- (void)run;

- (void)walk;

- (void)talkToSomeone:(NSString *)name;

@end
