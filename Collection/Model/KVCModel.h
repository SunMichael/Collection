//
//  KVCModel.h
//  Collection
//
//  Created by mac on 2018/4/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVCModel : NSObject 

@property(nonatomic ,copy) NSString *name;
@property(nonatomic ,strong) NSMutableArray *items;

- (void)addItem;
- (void)addItemObserver;
- (void)removeItemObserver;

@end
