//
//  CustomSegmentControl.m
//  RomanCar
//
//  Created by 武淅 段 on 2016/11/17.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import "CustomSegmentControl.h"
#import "Tookit.h"
#import "constant.h"

@interface CustomSegmentControl()

@property (nonatomic) NSMutableArray *labs;
@property (nonatomic) UIColor *highlightColor;
@property (nonatomic) UIColor *UnHeightlightColor;
@property (nonatomic) UIView *shadowLine;

@end
@implementation CustomSegmentControl


- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    return [self initWithFrame:frame items:items highlightColor:nil unHighlightColor:nil];
}

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items highlightColor:(UIColor *)color1 unHighlightColor:(UIColor *)color2
{
    self = [super initWithFrame:frame];
    if(self){
        
        if(items.count > 0){
            _labs = [NSMutableArray new];
            CGFloat width = SCREEN_WIDTH/items.count;
            for(int i = 0;i<items.count;i++){
                CGFloat x = i*width;
                UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(x, 0, width, frame.size.height)];
                [lab setTextAlignment:NSTextAlignmentCenter];
                [lab setFont:[UIFont systemFontOfSize:15.0]];
                [lab setText:items[i]];
                _UnHeightlightColor = color2?color2:COLOR_BBBBBB;
                [lab setTextColor:color2?color2:COLOR_BBBBBB];
                [self addSubview:lab];
                [_labs addObject:lab];
            }
            
            //shadow
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-1, width, 1)];
            [line setBackgroundColor:THEME_COLOR];
            [self addSubview:line];
            _shadowLine = line;
            [self.layer setShadowColor:COLOR_F1F1F1.CGColor];
            [self.layer setShadowOffset:CGSizeMake(0, 2)];
            
            //highlight
            UILabel *lab = _labs[_currentSelectedIndex];
            _highlightColor = color1?color1:COLOR_666666;
            [lab setTextColor:color1?color1:COLOR_666666];
        }
        
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGFloat width = self.frame.size.width/_labs.count;
    NSInteger index = location.x/width;
    self.currentSelectedIndex = index;
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)setCurrentSelectedIndex:(NSInteger)currentSelectedIndex
{
    _currentSelectedIndex = currentSelectedIndex;
    
    CGFloat width = self.frame.size.width/_labs.count;
    for(int i = 0;i<_labs.count;i++){
        UILabel *lab = _labs[i];
        if(currentSelectedIndex == i){
            [lab setTextColor:_highlightColor];
            [UIView animateWithDuration:0.3 animations:^{
               
                _shadowLine.center = CGPointMake(i*width+width/2, self.frame.size.height-0.5);
            }];
        }
        else{
            [lab setTextColor:_UnHeightlightColor];
        }
    }
}

@end
