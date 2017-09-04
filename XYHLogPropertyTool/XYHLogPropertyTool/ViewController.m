//
//  ViewController.m
//  XYHLogPropertyTool
//
//  Created by ydjh-apple on 2017/9/1.
//  Copyright © 2017年 zeb-apple. All rights reserved.
//

#import "ViewController.h"
#import "XYHLogPropertyTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"HZConfigFile" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    //    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    [XYHLogPropertyTool logAllPropertyWithObject:jsonDic filename:@""];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
