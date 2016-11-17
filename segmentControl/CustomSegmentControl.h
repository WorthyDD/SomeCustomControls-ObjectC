//
//  CustomSegmentControl.h
//  RomanCar
//
//  Created by 武淅 段 on 2016/11/17.
//  Copyright © 2016年 武淅 段. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSegmentControl : UIControl

@property (nonatomic, assign) NSInteger currentSelectedIndex;

- (instancetype)initWithFrame:(CGRect)frame items: (NSArray*)items;
- (instancetype)initWithFrame:(CGRect)frame items: (NSArray*)items highlightColor : (UIColor *)color1 unHighlightColor : (UIColor *)color2;

@end
