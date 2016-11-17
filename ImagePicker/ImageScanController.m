//
//  ImageScanController.m
//  EmployeeAssistant
//
//  Created by 武淅 段 on 2016/10/31.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "ImageScanController.h"
#import "ImageCell.h"
#import "constant.h"
#import "Tookit.h"
#import "BaseNavigationController.h"

@interface ImageScanController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation ImageScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64-50);
    UINib *nib = [UINib nibWithNibName:@"ImageCell" bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"Cell"];
    _collectionView.pagingEnabled = YES;
    
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"delete-white"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapDeleteItem:)];
    self.navigationItem.rightBarButtonItem = deleteItem;
    [self setTitle:[NSString stringWithFormat:@"%ld/%ld", _currentIndex+1, _imgs.count]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(_collectionView.tag != 12){
        [_collectionView setContentOffset:CGPointMake(_currentIndex*SCREEN_WIDTH, _collectionView.contentOffset.y)];
        _collectionView.tag = 12;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTintColor:THEME_COLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : COLOR_333333}];
    if(self.dismissHandler){
        self.dismissHandler();
    }
    
}

#pragma collection View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imgs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    id im = _imgs[indexPath.row];
    if([im isKindOfClass:[UIImage class]]){
        cell.imageView.image = im;
    }
    else if([im isKindOfClass:[NSString class]]){
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:im] placeholderImage:default_avatar_img];
    }
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
    _currentIndex = index;
    [self setTitle:[NSString stringWithFormat:@"%ld/%ld", _currentIndex+1, _imgs.count]];
}

#pragma mark -actions

- (void) didTapDeleteItem : (UIBarButtonItem *)sender
{
    if(_imgs.count>0){
        [_imgs removeObjectAtIndex:_currentIndex];
        if(_currentIndex > _imgs.count-1 && _currentIndex != 0){
            _currentIndex = _imgs.count-1;
        }
        [_collectionView reloadData];
        [self setTitle:[NSString stringWithFormat:@"%ld/%ld", _currentIndex+1, _imgs.count]];
    }
}

@end
