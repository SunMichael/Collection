//
//  ViewController.m
//  Collection
//
//  Created by mac on 2018/4/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ViewController.h"
#import "CopyController.h"
#import "KVCController.h"
#import "DynamicController.h"
#import "PropertyController.h"
#import "RuntimeController.h"
#import "AutoreleaseController.h"
#import "KVOController.h"
#import "BlockController.h"
#import "GCDController.h"

#import <objc/runtime.h>
@interface ViewController ()
{
    NSArray *ary;
    NSArray *vcAry;
<<<<<<< Updated upstream
    NSString *name;
=======
    
    NSString *string;
    NSMutableString *mstring;
>>>>>>> Stashed changes
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"知识点集合";
    name = @"name";
    
    ary = @[@"copy_demo",@"KVC_demo",@"KVO_demo",@"dynamic_demo",
            @"property_demo", @"runtime_demo", @"autorelease_demo",
            @"block_demo",@"thread_demo"];
    
    vcAry = @[@"CopyController",@"KVCController",@"KVOController" ,@"DynamicController",
              @"PropertyController",@"RuntimeController" ,@"AutoreleaseController",
              @"BlockController",@"GCDController" ];
#ifdef TARGETS_TEST
    self.title = @"target test";
#endif
    
<<<<<<< Updated upstream
=======
    string = @"string";
    mstring = [[NSMutableString alloc] initWithString:@"mstring"];
//    NSCache *cache = [[NSCache alloc]init];
//    cache setObject:<#(nonnull id)#> forKey:<#(nonnull id)#>
>>>>>>> Stashed changes
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ary.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *string = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    cell.textLabel.text = ary[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    Class class = NSClassFromString(vcAry[indexPath.row]);
    UIViewController *vc = [[class alloc] init];
    vc.title = ary[indexPath.row];
    if ([vc  isKindOfClass:[PropertyController class]]) {
        PropertyController *pc = (PropertyController *)vc;
<<<<<<< Updated upstream
        pc.name = name;
        name = @"newname";
=======
        pc.ary = [NSMutableArray arrayWithObjects:@"b",@"c",nil];
//        pc.author = [[NSString alloc] init];
//        pc.unsafeAry = [[NSMutableArray alloc] init];
    }else if ([vc isKindOfClass:[CopyController class]]) {
        CopyController *copy = (CopyController *)vc;
        copy.cString = string;
        copy.sString = string;
        copy.cmString = mstring;
        copy.smString = mstring;
        
        copy.cAry = ary;
        copy.sAry = ary;
>>>>>>> Stashed changes
    }
    
    [self.navigationController pushViewController:vc animated:YES];

}

<<<<<<< Updated upstream
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}


- (void)viewDidAppear:(BOOL)animated{
    NSLog(@" name %@ , %p " ,name ,name);
=======

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@" %p , %p ", string ,mstring);
>>>>>>> Stashed changes
}

@end
