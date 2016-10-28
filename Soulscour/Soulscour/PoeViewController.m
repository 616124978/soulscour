//
//  PoeViewController.m
//  Poe
//
//  Created by lanou on 16/10/26.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "PoeViewController.h"
#import "PoeModel.h"
#import "PoeTool.h"
#import "CollectionViewController.h"
#import <stdlib.h>


@interface PoeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleT;

@property (weak, nonatomic) IBOutlet UILabel *authorT;

@property (weak, nonatomic) IBOutlet UIButton *collBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) PoeModel *model;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL isCollected;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation PoeViewController

-(void)loadData {
    
    [self.indicator startAnimating];
    
    self.model = [[PoeModel alloc] init];
    
    int arc = arc4random()%(92-1+1)+1;

    NSLog(@"%d",arc);
    
    NSString *str=[NSString stringWithFormat:@"http://bubo.in/poe/poem?s=%d",arc];
    
    //生成Url
    NSURL *url = [NSURL URLWithString:str];
    
    //创建会话
    NSURLSession *session = [NSURLSession sharedSession];
    
    //创建任务
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                for (NSDictionary *dic in arr) {
                    [self.model setValuesForKeysWithDictionary:dic];
                    self.dataArray = [self.model.content componentsSeparatedByString:@"|^n|"];
                }
                NSArray *array = [PoeTool searchPoe:self.model.poe_id];
                if (array.count == 0) {
                    [self.collBtn setBackgroundImage:[UIImage imageNamed:@"nocollec.png"] forState:UIControlStateNormal];
                    self.isCollected = NO;
                }
                else
                {
                    [self.collBtn setBackgroundImage:[UIImage imageNamed:@"colleced.png"] forState:UIControlStateNormal];
                    self.isCollected = YES;
                }
                self.tableView.contentOffset = CGPointMake(0,0);
                [self.tableView reloadData];
                self.titleT.text = self.model.title;
                self.authorT.text = self.model.artist;
                [self.indicator stopAnimating];
                [self.indicator setHidesWhenStopped:YES];

            });
        }
        else {
            [self.indicator stopAnimating];
            [self.indicator setHidesWhenStopped:YES];
            NSLog(@"error = %@",error);
            [self alertView];
        }
        
    }];
    [task resume];
    
}

-(void)initView {
    self.title = @"诗";
    
    self.dataArray = [[NSArray alloc] init];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    UIImage *freshIcon=[UIImage imageNamed:@"refresh.png"];
    freshIcon=[freshIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightItem1=[[UIBarButtonItem alloc] initWithImage:freshIcon style:UIBarButtonItemStyleDone target:self action:@selector(refreshAction)];
    UIImage *collIcon=[UIImage imageNamed:@"collec.png"];
    collIcon=[collIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightItem2=[[UIBarButtonItem alloc] initWithImage:collIcon style:UIBarButtonItemStyleDone target:self action:@selector(pushAction)];
    self.navigationItem.rightBarButtonItems = @[rightItem2,rightItem1];
    
    self.titleT.textColor = [UIColor colorWithWhite:0.550 alpha:1.000];
    self.authorT.textColor = [UIColor colorWithWhite:0.550 alpha:1.000];
    

    [self.collBtn addTarget:self action:@selector(collAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    
}

-(void)initTimer {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
}

-(void)initIndicator {
    
    self.indicator =[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //设置显示位置
    self.indicator.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2-100);
    //将这个控件加到父容器中。
    [self.view addSubview:self.indicator];
    
    self.indicator.color = [UIColor lightGrayColor];
}

- (void)alertView
{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"请求超时，请点击刷新按钮" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alter addAction:ok];
    [self presentViewController:alter animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self initIndicator];
    
    [self loadData];
    
    [self initTimer];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count+12;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (indexPath.row>=4&&indexPath.row<=self.dataArray.count+3) {
        cell.textLabel.text = self.dataArray[indexPath.row-4];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithWhite:0.550 alpha:1.000];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 0;
    }
    else cell.textLabel.text = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshAction {
    self.isCollected = NO;
    self.dataArray = nil;
    self.titleT.text = nil;
    self.authorT.text = nil;
    [self.tableView reloadData];
    [self loadData];
}

-(void)timerAction {
    
    self.tableView.contentOffset = CGPointMake(0,self.tableView.contentOffset.y+1);
    
    CGFloat x = (self.dataArray.count+12)*50 - self.tableView.bounds.size.height;

    if (self.tableView.contentOffset.y >= x) {
        self.tableView.contentOffset = CGPointMake(0,0);
    }
}


-(void)collAction {
    
    
    if (!self.isCollected) {
        [PoeTool addPoe:self.model];
        [self.collBtn setBackgroundImage:[UIImage imageNamed:@"colleced.png"] forState:UIControlStateNormal];
        self.isCollected = YES;
    }
    else
    {
        [PoeTool deletePoe:self.model];
        [self.collBtn setBackgroundImage:[UIImage imageNamed:@"nocollec.png"] forState:UIControlStateNormal];
        self.isCollected = NO;
    }
}

-(void)pushAction {
    [self.timer setFireDate:[NSDate distantFuture]];
    CollectionViewController *collVC = [[CollectionViewController alloc] init];
    [self.navigationController pushViewController:collVC animated:YES];
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
