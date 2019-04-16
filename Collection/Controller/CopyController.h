//
//  CopyController.h
//  Collection
//
//  Created by mac on 2018/4/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CopyController : UIViewController

@property(nonatomic , copy) NSString *cString;
@property(nonatomic , strong) NSString *sString;

@property(nonatomic , copy) NSMutableString *cmString;
@property(nonatomic , strong) NSMutableString *smString;

@property(nonatomic , copy) NSArray *cAry;
@property(nonatomic , strong) NSArray *sAry;

@end
