//
//  GTVGridTableView.m
//  GridTableView
//
//  Created by Jeong YunWon on 13. 9. 10..
//  Copyright (c) 2013 youknowone.org. All rights reserved.
//

#import "GTVGridTableView.h"

@interface _GTVGridTableViewRowCell : UITableViewCell

@property(strong,nonatomic) NSArray *holders;

@end


@implementation _GTVGridTableViewRowCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    return self;
}

@end


@interface _GTVGridTableViewRowCellHolder : UIView

@property(strong,nonatomic) UIButton *coverButton;
@property(strong,nonatomic) id cell;

@end

@implementation _GTVGridTableViewRowCellHolder

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        UIButton *cover = [[UIButton alloc] initWithFrame:self.bounds];
        [self addSubview:cover];
        self.coverButton = cover;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end


@interface GTVGridTableView () {
//    __strong NSMutableDictionary *_reusableGridCells;
//    __strong NSMutableDictionary *_visibleGridCells;
}

@end


@implementation GTVGridTableView

- (void)_gridTableViewInit {
    self.allowsSelection = NO;
    self.dataSource = self;
//    self->_reusableGridCells = [NSMutableDictionary dictionary];
}

- (id)init {
    self = [super init];
    [self _gridTableViewInit];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self _gridTableViewInit];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self _gridTableViewInit];
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    [self _gridTableViewInit];
    return self;
}

- (NSInteger)numberOfColumnsInSection:(NSInteger)section {
    if ([self.gridSource respondsToSelector:@selector(tableView:numberOfColumnsInSection:)]) {
        return [self.gridSource tableView:self numberOfColumnsInSection:section];
    }
    return 1;
}

- (NSInteger)numberOfCellsInSection:(NSInteger)section {
    return [self.gridSource tableView:self numberOfCellsInSection:section];
}

- (GTVGridTableViewCell *)cellForGridAtIndex:(NSInteger)index section:(NSInteger)section {
    return [self.gridSource tableView:self cellForGridAtIndex:index section:section];
}

- (id)dequeueReusableGridCellWithIdentifier:(NSString *)identifier {
    return nil; // TODO:
}


- (void)coverDidSelected:(id)sender {
    NSInteger tag = [sender tag];
    if (tag < 0) return;
    if ([self.gridSource respondsToSelector:@selector(tableView:didSelectGridAtIndex:section:)]) {
        NSInteger section = tag / 0x10000;
        NSInteger index = tag % 0x10000;
        [self.gridSource tableView:self didSelectGridAtIndex:index section:section];
    }
}

#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.gridSource respondsToSelector:_cmd]) {
        return [self.gridSource numberOfSectionsInTableView:(id)tableView];
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self.gridSource respondsToSelector:_cmd]) {
        [self.gridSource tableView:(id)tableView titleForHeaderInSection:section];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if ([self.gridSource respondsToSelector:_cmd]) {
        [self.gridSource tableView:(id)tableView titleForFooterInSection:section];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger cellCount = [self numberOfCellsInSection:section];
    NSInteger columnCount = [self numberOfColumnsInSection:section];

    NSInteger rows = ((cellCount - 1) / columnCount) + 1;
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger cellCount = [self numberOfCellsInSection:indexPath.section];
    NSInteger columnCount = [self numberOfColumnsInSection:indexPath.section];
    NSString *reuseIdentifier = @(columnCount).stringValue;

    _GTVGridTableViewRowCell *tableCell = (id)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableCell == nil) {
        tableCell = [[_GTVGridTableViewRowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];

        NSMutableArray *holders = [NSMutableArray array];
        for (int i = 0; i < columnCount; i++) {
            CGFloat width = tableView.frame.size.width / columnCount;
            _GTVGridTableViewRowCellHolder *view = [[_GTVGridTableViewRowCellHolder alloc] initWithFrame:CGRectMake(width * i, .0, width, 1.0f)];
            [view.coverButton addTarget:self action:@selector(coverDidSelected:) forControlEvents:UIControlEventTouchUpInside];
            [tableCell addSubview:view];
            [holders addObject:view];
        }
        tableCell.holders = holders;
    }
    CGFloat rowHeight = -1.0f;
    if ([tableView.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        rowHeight = [tableView.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    if (rowHeight < 0) {
        rowHeight = tableView.rowHeight;
    }
    for (UIView *holder in tableCell.holders) {
        CGRect frame = holder.frame;
        frame.size.height = rowHeight;
        holder.frame = frame;
    }

    NSInteger index = indexPath.row * columnCount;
    for (int i = 0; i < columnCount; i++) {
        _GTVGridTableViewRowCellHolder *holder = tableCell.holders[i];
        [holder.cell removeFromSuperview];
        holder.cell = nil;
        holder.coverButton.frame = holder.bounds;

        if (index + i < cellCount) {
            GTVGridTableViewCell *gridCell = [self cellForGridAtIndex:index + i section:indexPath.section];
            gridCell.frame = holder.bounds;
            [holder insertSubview:gridCell belowSubview:holder.coverButton];

            holder.cell = gridCell;
            holder.coverButton.tag = 0x10000 * indexPath.section + index + i;
        } else {
            holder.coverButton.tag = -1;
        }
    }

    return tableCell;
}

@end


@interface GTVGridTableViewCell () {
    __strong NSString *_reuseIdentifier;
}

@end


@implementation GTVGridTableViewCell

- (UIView *)contentView {
    return self;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self != nil) {
        self->_reuseIdentifier = reuseIdentifier;
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(.0, .0, 100, 100);
    }
    return self;
}

@end
