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

#import <objc/runtime.h>
@interface ViewController ()
{
    NSArray *ary;
    NSArray *vcAry;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"代码集合";
    ary = @[@"copy测试",@"KVC测试",@"KVO测试",@"dynamic测试",
            @"property测试", @"runtime测试", @"autorelease测试",@"block测试"];
    
    vcAry = @[@"CopyController",@"KVCController",@"KVOController" ,@"DynamicController",
              @"PropertyController",@"RuntimeController" ,@"AutoreleaseController",@"BlockController"];
    
//    NSCache *cache = [[NSCache alloc]init];
//    cache setObject:<#(nonnull id)#> forKey:<#(nonnull id)#>
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        pc.ary = [NSMutableArray arrayWithObjects:@"b",@"c",nil];
    }
    [self.navigationController pushViewController:vc animated:YES];

}

@end
