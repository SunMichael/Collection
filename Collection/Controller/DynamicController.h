//
//  DynamicController.h
//  Collection
//
//  Created by mac on 2018/4/13.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicController : UIViewController

@end



@interface BookModel: NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic ,copy) NSString *author;

@end


typedef void(^Action)(UIButton *sender);

@interface UIButton (Action)

@property(nonatomic ,copy) Action block;

+ (UIButton*)buttonWithFrame:(CGRect)frame title:(NSString *)title actionBlock:(Action)block;


@end
