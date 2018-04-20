//
//  BlockController.h
//  Collection
//
//  Created by mac on 2018/4/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^propertyBlock)(void);

@interface BlockController : UIViewController


@property(nonatomic ,copy) propertyBlock block;

@end
