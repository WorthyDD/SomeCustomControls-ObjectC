//
//  ImagePickerView.m
//  EmployeeAssistant
//
//  Created by 武淅 段 on 2016/10/27.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "ImagePickerView.h"
#import "Tookit.h"
#import "constant.h"
#import "TZImagePickerController.h"
#import "ImageScanController.h"

@interface ImagePickerView ()<TZImagePickerControllerDelegate>

@property (nonatomic) UIButton *emptyTipButton;


- (void) updateView;
@end

@implementation ImagePickerView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _emptyTipButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 45)];
    [_emptyTipButton setImage:[UIImage imageNamed:@"camera-icon"] forState:UIControlStateNormal];
    [_emptyTipButton setTitleColor:COLOR_999999 forState:UIControlStateNormal];
    [_emptyTipButton setTitle:@" (可添加训练照片)" forState:UIControlStateNormal];
    [_emptyTipButton setContentMode:UIViewContentModeLeft];
    [_emptyTipButton addTarget:self action:@selector(tapAddPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_emptyTipButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_emptyTipButton sizeToFit];
    _emptyTipButton.size = CGSizeMake(_emptyTipButton.width, 45);
    [self addSubview:_emptyTipButton];
    _imgArr = [NSMutableArray new];
}

- (void)setImgArr:(NSMutableArray *)imgArr
{
    _imgArr = imgArr;
    [self updateView];
    
}

#pragma mark - actions

- (void) tapAddPhoto : (id)sender
{
    TZImagePickerController *picker = [[TZImagePickerController alloc]initWithMaxImagesCount:9 delegate:self];
    [self.ownerController presentViewController:picker animated:YES completion:^{
        
    }];
}

#pragma mark - imagepicker delegate

- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    [_imgArr addObjectsFromArray:photos];
    if(_imgArr.count>9){
        [_imgArr removeObjectsInRange:NSMakeRange(9, _imgArr.count-9)];
        [self.ownerController.view makeToast:@"最多选9张图片"];
    }
    [self updateView];
}

- (void) updateView
{
    for(UIView *view in self.subviews){
        if(![view isEqual:_emptyTipButton]){
            [view removeFromSuperview];
        }
    }
    _emptyTipButton.hidden = _imgArr.count>0;
    if(_imgArr.count == 0){
        return;
    }
    CGFloat left = 15;
    CGFloat gap = 10;
    NSInteger col = 4;
    CGFloat x = left;
    CGFloat y = 15;
    CGFloat width = (SCREEN_WIDTH-30-(col-1)*gap)/col;
    
    CGFloat top = y;
    for(int i = 0;i < _imgArr.count+1;i++){
        
        x = left + i%col*(width+gap);
        y = i/col*(width+gap)+top;
        UIImage *im;
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, width, width)];
        iv.tag = i;
        [iv setContentMode:UIViewContentModeScaleAspectFill];
        iv.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectedImage:)];
        iv.userInteractionEnabled = YES;
        [iv addGestureRecognizer:tap];
        if(i == _imgArr.count){
            im = [UIImage imageNamed:@"add-pic"];
            [iv setImage:im];
        }
        else{
            if([_imgArr[i] isMemberOfClass:[UIImage class]]){
                im = _imgArr[i];
                [iv setImage:im];
            }
            else if([_imgArr[i] isKindOfClass:[NSString class]]){
                [iv sd_setImageWithURL:[NSURL URLWithString:_imgArr[i]]];
            }
        }
        
        [self addSubview:iv];
    }
    
    y+=(gap+width);
    if(self.pickImgHandler){
        self.pickImgHandler(y+10);
    }
}

- (void) didSelectedImage : (UITapGestureRecognizer *)ges
{
    if([ges.view isKindOfClass:[UIImageView class]] && ges.view.tag == _imgArr.count){
        //add
        [self tapAddPhoto:nil];
    }
    else{
        //check img
        ImageScanController *iv = [[ImageScanController alloc]initWithNibName:@"ImageScanController" bundle:nil];
        iv.imgs = _imgArr;
        iv.currentIndex = ges.view.tag;
        iv.dismissHandler = ^(){
            [self updateView];
        };
        [_ownerController.navigationController pushViewController:iv animated:YES];
    }
}
@end
