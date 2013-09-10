//
//  GTVGridTableView.h
//  GridTableView
//
//  Created by Jeong YunWon on 13. 9. 10..
//  Copyright (c) 2013 youknowone.org. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GTVGridTableViewDataSource;
@class GTVGridTableViewCell;

@interface GTVGridTableView : UITableView<UITableViewDataSource>

@property(weak,nonatomic) IBOutlet id<GTVGridTableViewDataSource> gridSource;

- (NSInteger)numberOfColumnsInSection:(NSInteger)section;
- (NSInteger)numberOfCellsInSection:(NSInteger)section;
- (GTVGridTableViewCell *)cellForGridAtIndex:(NSInteger)index section:(NSInteger)section;

- (id)dequeueReusableGridCellWithIdentifier:(NSString *)identifier;

@end


@protocol GTVGridTableViewDataSource <NSObject>

- (NSInteger)tableView:(GTVGridTableView *)tableView numberOfCellsInSection:(NSInteger)section;

@optional

- (NSInteger)tableView:(GTVGridTableView *)tableView numberOfColumnsInSection:(NSInteger)section;
- (NSInteger)numberOfSectionsInTableView:(GTVGridTableView *)tableView; // Default is 1 if not implemented

- (NSString *)tableView:(GTVGridTableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (NSString *)tableView:(GTVGridTableView *)tableView titleForFooterInSection:(NSInteger)section;
- (GTVGridTableViewCell *)tableView:(GTVGridTableView *)tableView cellForGridAtIndex:(NSInteger)index section:(NSInteger)section;

- (void)tableView:(GTVGridTableView *)tableView didSelectGridAtIndex:(NSInteger)index section:(NSInteger)section;

@end


@interface GTVGridTableViewCell : UIView

@property(readonly) NSString *reuseIdentifier;
@property(readonly) UIView *contentView;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
