//
//  GTTViewController.m
//  GridTableViewTestApp
//
//  Created by Jeong YunWon on 13. 9. 10..
//  Copyright (c) 2013 youknowone.org. All rights reserved.
//

#import "GTTViewController.h"

@interface GTTViewController ()

@end

@implementation GTTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(GTVGridTableView *)tableView numberOfColumnsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)tableView:(GTVGridTableView *)tableView numberOfCellsInSection:(NSInteger)section {
    return 20;
}

- (GTVGridTableViewCell *)tableView:(GTVGridTableView *)tableView cellForGridAtIndex:(NSInteger)index section:(NSInteger)section {
    GTVGridTableViewCell *cell = [tableView dequeueReusableGridCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[GTVGridTableViewCell alloc] initWithReuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor colorWithRed:1.0f * arc4random() / UINT32_MAX
                                           green:1.0f * arc4random() / UINT32_MAX
                                            blue:1.0f * arc4random() / UINT32_MAX
                                           alpha:1.0f];
    return cell;
}

- (void)tableView:(GTVGridTableView *)tableView didSelectGridAtIndex:(NSInteger)index section:(NSInteger)section {
    NSLog(@"%d %d", section, index);
}

@end
