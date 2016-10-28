//
//  BezViewController.m
//  Soulscour
//
//  Created by lanou on 16/10/28.
//  Copyright © 2016年 lanou. All rights reserved.
//


#define kscHeight [UIScreen mainScreen].bounds.size.height
#define kscWidth  [UIScreen mainScreen].bounds.size.width

#import "BeaViewController.h"

#import "CHCardItemCustomView.h"
#import "CHCardItemModel.h"
#import "CHCardView.h"

@interface BeaViewController ()<CHCardViewDelegate,CHCardViewDataSource>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,weak)CHCardView *cardView;

//数据总数目
@property(nonatomic,assign)NSInteger totalRow;

//第几次加载数据，每次加载下一页数据
@property(nonatomic,assign)NSInteger count;

//等待菊花
@property(nonatomic,strong)UIActivityIndicatorView *indicator;

@end

@implementation BeaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //初始化菊花
    [self initIndicator];
    
    self.count=0;
    // data
    [self loadData];
    
    // reload
    [self.cardView reloadData];
    
    
}

#pragma mark 初始化Indicator
-(void)initIndicator
{
    self.indicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //frame
    self.indicator.center=CGPointMake(kscWidth/2, kscHeight/2);
    
    [self.view addSubview:self.indicator];
    self.indicator.color=[UIColor grayColor];
    [self.indicator startAnimating];
    
}

#pragma mark loadData加载数据
-(void)loadData
{
    
    
    [self.dataArray removeAllObjects];
    
    NSString *str=@"http://qianming.sinaapp.com/index.php/AndroidApi10/index/cid/qutu/lastId";
    //1.生成url
    NSURL *url=[NSURL URLWithString:str];
    //2创建会话
    NSURLSession *session=[NSURLSession sharedSession];
    //3.创建任务
    NSURLSessionDataTask *task=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //5.解析数据
        if (data) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            //得到总行数
            NSArray *array=dict[@"rows"];
            self.totalRow=[array[0][@"id"] integerValue];
            //            NSLog(@"总数据数 %ld",self.totalRow);
            
            
            //开始请求数据 每次请求15条数据
            if (self.count*15>self.totalRow) {
                self.count=0;
            }
            NSString *str2=[str stringByAppendingFormat:@"/%ld",self.totalRow+1-self.count*15];
            NSLog(@"%ld",self.totalRow-self.count*15);
            self.count++;
            
            
            NSURL *url2=[NSURL URLWithString:str2];
            
            NSURLSessionDataTask *task2=[session dataTaskWithURL:url2 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (data) {
                    NSArray *array=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    for (NSDictionary *dic in array) {
                        
                        CHCardItemModel *model=[[CHCardItemModel alloc]init];
                        [model setValuesForKeysWithDictionary:dic];
                        NSLog(@"%@",model.timeStr);
                        [self.dataArray insertObject:model atIndex:0];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.cardView reloadData];
                        });
                    }
                }
            }];
            [task2 resume];
            
        }
        
    }];
    
    //4开启任务
    [task resume];
    
    
}



//懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (CHCardView *)cardView {
    if (!_cardView) {
        CHCardView *cardView = [[CHCardView alloc] initWithFrame:CGRectMake(15, 30, kscWidth - 30, kscHeight-180)];
        [self.view addSubview:cardView];
        _cardView = cardView;
        cardView.delegate = self;
        cardView.dataSource = self;
    }
    return _cardView;
}


#pragma  mark delagate 方法
-(NSInteger)numberOfItemViewsInCardView:(CHCardView *)cardView
{
    
    return self.dataArray.count;
    
}
-(CHCardItemView *)cardView:(CHCardView *)cardView itemViewAtIndex:(NSInteger)index
{
    
    
    CHCardItemCustomView *itemView=[[CHCardItemCustomView alloc]initWithFrame:cardView.bounds];
    itemView.itemModel=self.dataArray[index];
    
    return itemView;
    
}
- (void)cardViewNeedMoreData:(CHCardView *)cardView {
    
    
    // data
    [self loadData];
    // reload
    [self.cardView reloadData];
}


//-(void)viewDidLayoutSubviews
//{
//
//    self.cardView.frame=self.view.bounds;
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
