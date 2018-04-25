//
//  config.h
//  Collection
//
//  Created by mac on 2018/4/25.
//  Copyright © 2018年 mac. All rights reserved.
//

#ifndef config_h
#define config_h


#define TLog(_var) ({ NSString *name = @#_var; NSLog(@"%@: %@ -> %p : %@  %d", name, [_var class], _var, _var, (int)CFGetRetainCount((__bridge CFTypeRef)(name))); })



#endif /* config_h */
