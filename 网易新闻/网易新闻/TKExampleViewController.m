//
//  TKExampleViewController.m
//  网易新闻
//
//  Created by wanghu on 16/5/25.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "TKExampleViewController.h"

@interface TKExampleViewController ()

@end

static NSString *ID = @"example";

@implementation TKExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 17;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.textLabel.text = self.title;
    return cell;
}

@end
