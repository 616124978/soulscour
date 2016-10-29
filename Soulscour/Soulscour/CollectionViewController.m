//
//  CollectionViewController.m
//  Soulscour
//
//  Created by lanou on 16/10/28.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CollectionViewController.h"
#import "PoeTool.h"
#import "PoeModel.h"
#import "PoeViewController.h"

@interface CollectionViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CollectionViewController

-(void)getAllpoe {
    self.dataArray = [[PoeTool searchAllpoe] mutableCopy];
}

-(void)initTableView {
    self.title = @"收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-113)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc] init];
    [self getAllpoe];
    [self initTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    PoeModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    
    return cell;
}

//自带编辑按钮的响应方法
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
}

//返回指定cell是否处于可编辑状态
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//返回cell的编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //默认为删除
    return UITableViewCellEditingStyleDelete;
}

//处理编辑结果
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [PoeTool deletePoe:self.dataArray[indexPath.row]];
    [self getAllpoe];
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PoeModel *model = self.dataArray[indexPath.row];
    self.sendBlock(model.poe_id);
    [self.navigationController popViewControllerAnimated:YES];
}

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
