//
//  iosapp
//
//  Created by bill li on 2016-01-28.
//  Copyright (c) 2016年 finalshares. All rights reserved.
//

#import "VideoTableViewController.h"

//#import "MBProgressHUD+MJ.h"
#import "VideoModel.h"
#import "UIImageView+WebCache.h"
#import "VideoCell.h"

#import <MediaPlayer/MediaPlayer.h>

#import "JsonUtils.h"

@interface VideoTableViewController ()
@property(nonatomic,strong)NSArray *videos;

//播放器视图控制器
@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayerViewController;
@end

@implementation VideoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //去掉下划线
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    //[MBProgressHUD showMessage:@"正在努力加载中"];
    
    if(ENABLE_TEST_DATA){
        
        // just for test purpose
        NSArray *array = [JsonUtils getConfig:@"video" with:@"videoItems"];
        
        NSMutableArray *videos=[NSMutableArray array];
        for (NSDictionary *dict in array) {
            VideoModel *model=[VideoModel viodesModelWithDict:dict];
            [videos addObject:model];
        }
        
        self.videos=videos;
        
        //刷新表格
        [self.tableView reloadData];
        
        return;
    }
    //创建路径
    
    NSString  *urlStr=@"http://192.168.1.53:8080/MJServer/video";
    //NSString  *urlStr=@"http://www.weather.com.cn/adat/sk/101010100.html";
    NSURL *url=[NSURL URLWithString:urlStr];
    
    //创建请求
    NSMutableURLRequest  *request=[NSMutableURLRequest requestWithURL:url];//默认为get请求
    //设置最大的网络等待时间
    request.timeoutInterval=20.0;
    
    //获取主队列
    NSOperationQueue *queue=[NSOperationQueue mainQueue];
    //发起请求
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //隐藏HUD
        //[MBProgressHUD hideHUD];

        
        if (data) {//如果请求成功，拿到服务器返回的数据
            //解析拿到的数据(JSON方式)
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            //           NSArray *array=dict[@"video"];
            NSArray *array=dict[@"videos"];
            
            NSMutableArray *videos=[NSMutableArray array];
            for (NSDictionary *dict in array) {
                VideoModel *model=[VideoModel viodesModelWithDict:dict];
                [videos addObject:model];
            }
            self.videos=videos;
            
            //刷新表格
            [self.tableView reloadData];
            
        }else//如果请求失败，没有拿到数据
        {
            //[MBProgressHUD showError:@"网络繁忙，等稍后再试！"];
        }
        
    }];
}

#pragma mark-数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videos.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"ID";
    VideoCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[VideoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    //获取数据模型
    VideoModel *model=self.videos[indexPath.row];
    cell.textLabel.text=model.name;
    NSString *length=[NSString stringWithFormat:@"时长%d分钟",model.length];
    cell.detailTextLabel.text=length;
    
    // video.image == resources/images/minion_01.png
    NSString *imageUrl = [NSString stringWithFormat:@"http://192.168.1.53:8080/MJServer/%@", model.image];
    
    //这里使用了第三方框架
    [cell.imageView  setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;
}

//设置cell的行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}



//播放视频
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出数据模型
    VideoModel *model=self.videos[indexPath.row];
    
    //创建视屏播放器
    //   MPMoviePlayerController 可以随意控制播放器的尺寸
    //MPMoviePlayerViewController只能全屏播放
    
    //NSString *url = [NSString stringWithFormat:@"http://192.168.1.53:8080/MJServer/%@", model.url];
    
    
    self.moviePlayerViewController=nil;//保证每次点击都重新创建视频播放控制器视图，避免再次点击时由于不播放的问题
    //    [self presentViewController:self.moviePlayerViewController animated:YES completion:nil];
    //注意，在MPMoviePlayerViewController.h中对UIViewController扩展两个用于模态展示和关闭MPMoviePlayerViewController的方法，增加了一种下拉展示动画效果
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayerViewController];
    
    
}

-(void)dealloc{
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  取得网络文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getNetworkUrl{
    NSString *urlStr=@"http://7xi9it.com1.z0.glb.clouddn.com/mv0.mp4";
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    return url;
}

-(MPMoviePlayerViewController *)moviePlayerViewController{
    if (!_moviePlayerViewController) {
        NSURL *url=[self getNetworkUrl];
        _moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
        [self addNotification];
    }
    return _moviePlayerViewController;
}


#pragma mark - 控制器通知
/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayerViewController.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayerViewController.moviePlayer];
    
}

/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    switch (self.moviePlayerViewController.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放.");
            break;
        default:
            NSLog(@"播放状态:%li",self.moviePlayerViewController.moviePlayer.playbackState);
            break;
    }
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    NSLog(@"播放完成.%li",self.moviePlayerViewController.moviePlayer.playbackState);
}



@end
