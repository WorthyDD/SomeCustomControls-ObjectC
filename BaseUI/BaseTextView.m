//
//  BaseTextView.m
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/9/23.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "BaseTextView.h"

@interface BaseTextView()

@property (nonatomic) UILabel *placeHolderLabel;
@property (nonatomic) UIColor *holderColor;
@property (nonatomic) NSString *placeHolder;

@end
@implementation BaseTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if(self){
        [self commenInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self commenInit];
    }
    return self;
}

- (void) commenInit
{
    [self setTextContainerInset:UIEdgeInsetsMake(8, 8, 8, 8)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPlaceHolder:(NSString *)placeHolder color:(UIColor *)color
{
    _holderColor = color;
    _placeHolder = placeHolder;
    [self setNeedsDisplay];
}

- (void)textDidChange : (NSNotification *) notify
{
    if(self.text.length == 0 && _placeHolder.length>0){
        _placeHolderLabel.hidden = NO;
    }
    else{
        _placeHolderLabel.hidden = YES;
    }
}

- (void)drawRect:(CGRect)rect
{
    if(!_placeHolderLabel){
        _placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, self.bounds.size.width-30, 0)];
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.font = self.font;
        [_placeHolderLabel setTextColor:_holderColor];
        _placeHolderLabel.hidden = YES;
        [self addSubview:_placeHolderLabel];
    }
    
    _placeHolderLabel.text = _placeHolder;
    [_placeHolderLabel sizeToFit];
    [self sendSubviewToBack:_placeHolderLabel];
    if(self.text.length == 0 && _placeHolder.length>0){
        _placeHolderLabel.hidden = NO;
    }
    else{
        _placeHolderLabel.hidden = YES;
    }
}

@end
