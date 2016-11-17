//
//  CustomActionSheetView.m
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/9/18.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "CustomActionSheetView.h"
#import "constant.h"
#import "UIColor+TAToolkit.h"

#define row_height 44

@interface CustomActionSheetView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *items;

@end

@implementation CustomActionSheetView

- (instancetype)initWithTitle:(NSString *)title items:(NSArray *)items
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self){
        
        _items = items;
        UIView *superView = [[UIApplication sharedApplication] keyWindow];
        _selectedIndex = -1;
        //tableView
        CGFloat height = 0;
        if(title.length > 0){
            height += row_height;
        }
        height += items.count*row_height;
        height += row_height+8;  //取消
        if(height > SCREEN_HEIGHT/2){
            height = SCREEN_HEIGHT/2;
        }
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, height) style:UITableViewStyleGrouped];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        //header
        if(title.length>0){
            UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, row_height)];
            UILabel *label = [[UILabel alloc]initWithFrame:header.bounds];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setFont:[UIFont systemFontOfSize:14.0f]];
            [label setTextColor:COLOR_999999];
            if([title isKindOfClass:[NSAttributedString class]]){
                label.attributedText = (NSAttributedString*)title;
            }
            else{
                [label setText:title];
            }
            [header addSubview:label];
            [header setBackgroundColor:[UIColor whiteColor]];
            _tableView.tableHeaderView = header;
        }
        else{
            _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.1, 0.1)];
        }
        //footer
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, row_height)];
        //UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
        //        [line setBackgroundColor:[UIColor colorWithRGB:0xeeeeee]];
        //        [footerView addSubview:line];
        UILabel *cancleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, row_height)];
        [cancleLabel setTextColor:COLOR_666666];
        [cancleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [cancleLabel setTextAlignment:NSTextAlignmentCenter];
        [cancleLabel setText:@"取消"];
        [footerView addSubview:cancleLabel];
        [footerView setBackgroundColor:[UIColor whiteColor]];
        footerView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapCancleButton:)];
        [footerView addGestureRecognizer:tap];
        _tableView.tableFooterView = footerView;
        if([_tableView respondsToSelector:@selector(setLayoutMargins:)]){
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        if([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        [_tableView setSectionHeaderHeight:0.1];
        [_tableView setSectionFooterHeight:8];
        [_tableView setRowHeight:row_height];
        [_tableView setBounces:NO];
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.0]];
        [superView addSubview:self];
        [_tableView reloadData];
        
    }
    return self;
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *item = _items[indexPath.row];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    if(_selectedIndex == indexPath.row){
        item = [NSString stringWithFormat:@"%@ ✓",item];
        [cell.textLabel setTextColor:THEME_COLOR];
    }
    else{
        [cell.textLabel setTextColor:COLOR_333333];
    }
    
    if([item isKindOfClass:[NSAttributedString class]]){
        cell.textLabel.attributedText = (NSAttributedString *)item;
    }
    else{
        [cell.textLabel setText:item];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismiss];
    if(self.handler){
        self.handler(indexPath.row);
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}


#pragma mark - show dismiss
- (void) show
{
    if(!self.superview){
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    }
    
    CGRect frame = _tableView.frame;
    frame.origin.y = SCREEN_HEIGHT - _tableView.frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
        _tableView.frame = frame;
    }];
}

- (void) dismiss
{
    CGRect frame = _tableView.frame;
    frame.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame = frame;
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.0]];
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - tap cancle
- (void) didTapCancleButton : (id)ges
{
    [self dismiss];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    if(location.y<_tableView.y){       //实际上这一步是多余的  self接收不到响应
        [self dismiss];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    [self.tableView reloadData];
}

@end
