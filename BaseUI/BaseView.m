//
//  BaseView.m
//  card
//
//  Created by Hale Chan on 15/4/8.
//  Copyright (c) 2015年 Papaya Mobile Inc. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

+ (instancetype)viewFromDefaultNib
{
    NSString *name = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:name bundle:nil];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

+ (instancetype)viewFromDefaultNibWithNibName:(NSString *)nibName
{
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    return [[nib instantiateWithOwner:nil options:nil] lastObject];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    //
}

- (void)baseRemoveAllSubViews
{
    for ( UIView *view in self.subviews ){
        [view removeFromSuperview];
    }
}
@end
