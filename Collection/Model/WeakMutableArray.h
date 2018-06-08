//
//  WeakMutableArray.h
//  Collection
//
//  Created by mac on 2018/5/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeakMutableArray : NSObject

@property(nonatomic ,strong ,readonly) NSArray *allObjects;

@property(nonatomic , assign , readonly) NSInteger useableCount;

@property(nonatomic , assign , readonly) NSInteger allCount;

- (void)addObject:(id)obj;

- (id)objectAtWeakArrayIndex:(NSInteger)index;

@end
