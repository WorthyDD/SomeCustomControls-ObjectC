//
//  BaseRootSegmentController.m
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/9/21.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "BaseRootSegmentController.h"

@interface BaseRootSegmentController ()

@property (nonatomic, assign) NSInteger segmentIndex;   //第一次初始化默认选中的segment
@property (nonatomic) NSArray<UIViewController *> *controllers;
@end

@implementation BaseRootSegmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (instancetype)initWithSegmentItems:(NSArray *)items defaultIndex:(NSInteger)index
{
    self = [super init];
    if(self){
        self.segmentIndex = index;
        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:items];
        [segment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
        [segment setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0]} forState:UIControlStateNormal];
        segment.size = CGSizeMake(SCREEN_WIDTH*0.45, 30);
        [segment setSelectedSegmentIndex:_segmentIndex];
        self.navigationItem.titleView = segment;

    }
    return self;
}

- (void)addChildrenControllers:(NSArray<UIViewController *> *)controllers
{
    _controllers = controllers;
    for(int i = 0;i < controllers.count;i++){
        
        UIViewController *vc = controllers[i];
        [self.view addSubview:vc.view];
        if(_segmentIndex == i){
            vc.view.hidden = NO;
        }
        else{
            vc.view.hidden = YES;
        }
    }
}

#pragma mark - actions
- (void) segmentValueChange : (UISegmentedControl *)control
{
    NSInteger index = control.selectedSegmentIndex;
    UIViewController *selectVC = _controllers[index];
    for(UIViewController *vc in _controllers){
        if([vc isEqual:selectVC]){
            vc.view.hidden = NO;
        }
        else{
            vc.view.hidden = YES;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
