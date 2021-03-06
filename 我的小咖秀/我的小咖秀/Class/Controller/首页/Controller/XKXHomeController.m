//
//  XKXHomeController.m
//  我的小咖秀
//
//  Created by admin on 16/2/17.
//  Copyright © 2016年 admin. All rights reserved.
//  首页

#import "XKXHomeController.h"
#import "XKXButton.h"
#import "XKXHomeModel.h"
#import "XKXHomeVideoCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "XKXVideoPlayController.h"
#import "XKXRightView.h"
#import "我的小咖秀-Swift.h"
#import <POP.h>
@interface XKXHomeController ()<UICollectionViewDataSource,UICollectionViewDelegate>
/** collectionView */
@property (weak,nonatomic) UICollectionView * collectionView;
/** 遮盖 */
@property (weak,nonatomic) UIImageView * bgView;

/** 数据 */
@property (strong,nonatomic) NSMutableArray * data;
//@property (strong,nonatomic) MyVideoPlayer * player;
@end

@implementation XKXHomeController

static NSString * ID = @"HomeVideo";
- (NSMutableArray *)data{
    
    if (_data == nil) {
        
        _data = [NSMutableArray array];
        
        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"discover.plist" ofType:nil];
        
        NSDictionary * dictArr = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        NSArray * tmp = dictArr[@"videos"];
        
        for (NSDictionary * dict in tmp) {
            
            XKXHomeModel * video = [XKXHomeModel videoWithDictionary:dict];
            
            [_data addObject:video];
        }
    }
    

    return _data;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 右边按钮
    WTBarButtonItem * right = [WTBarButtonItem tabBarButtonWithTitle:nil andImage:@"recorder_img_btn"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    [right addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray * strArray = @[@"关注",@"发现",@"同城"];
    // 中间按钮
   WTSelectedView * selectedView = [[WTSelectedView alloc] initWithFrame:CGRectMake(0, 0, 150, 30) andArray:strArray];
   self.navigationItem.titleView = selectedView;
    
    [self setUpCollectionView];

}

/********************右侧按钮点击**********************/
- (void)rightButtonClick {
    
    XKXRightView * rightView = [XKXRightView rightView];
    rightView.backgroundColor = [UIColor blackColor];
    rightView.alpha = 0.9;
    rightView.frame = self.view.bounds;
    [self.navigationController.view addSubview:rightView];
}


/********************创建collectionView**********************/
- (void)setUpCollectionView{
    
    // 1.创建布局
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    // 1.1 设置item的宽高
    CGFloat itemWidth = (self.view.width - 1) * 0.5;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
   // layout.sectionInset = UIEdgeInsetsMake(0, margin, margin, 0);
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    // 2.创建collectionView
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor blackColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    collectionView.showsVerticalScrollIndicator = NO;

    // 3.注册cell
    [collectionView registerClass:[XKXHomeVideoCell class] forCellWithReuseIdentifier:ID];
    
    // 4.添加刷新控件
    RefreshControl * refresh = [[RefreshControl alloc] init];
    [collectionView addSubview:refresh];
}

- (void)bgViewClick{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.bgView removeFromSuperview];
        
    }];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    XKXHomeVideoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.backgroundColor = XKXColor;
    
    cell.video = self.data[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XKXHomeModel * video = self.data[indexPath.item];
    
    NSLog(@"%@",video.video);
    // 视频的播放地址
    NSString * string = [[NSBundle mainBundle] pathForResource:video.video ofType:nil];
    
    if (!string){
    
        NSLog(@"%@",string);
        return;
    }
//NSLog(@"string ----- %@", string);
    NSURL * url = [NSURL fileURLWithPath:string];
// NSLog(@"url---- %@",url);
//    // 创建视频控制器
//    MPMoviePlayerViewController * player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
//    
//    player.view.frame = CGRectMake(0, 20, self.view.width, 200);
//    [self presentMoviePlayerViewControllerAnimated:player];
    
    // 创建导航控制器
    XKXVideoPlayController * playVc = [[XKXVideoPlayController alloc] init];
    //XKXNavigationController * nav = [[XKXNavigationController alloc] initWithRootViewController:playVc];
    //playVc.view.backgroundColor = [UIColor greenColor];

    // 创建avplayer
//    AVPlayerItem * item = [AVPlayerItem playerItemWithURL:url];
//    self.player = [AVPlayer playerWithPlayerItem:item];
//    playVc.player = self.player;
//    AVPlayerLayer * layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//
//    layer.frame = CGRectMake(0, 0, playVc.view.width, playVc.view.width);
//    [playVc.videoView.layer addSublayer:layer];
//    [self.player play];
    
    MyVideoPlayer * player = [[MyVideoPlayer alloc] initVideoPlayer];
    playVc.videoPlayer = player;
    
    //playVc.player = player.player;
    player.playerItem = [AVPlayerItem playerItemWithURL:url];
    player.frame = CGRectMake(0, 0, playVc.view.width, playVc.view.width);
    [playVc.videoView addSubview:player];
    
    [self.navigationController pushViewController:playVc animated:YES];
}
@end
