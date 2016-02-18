//
//  ViewController.m
//  购物车
//
//  Created by beijingduanluo on 16/1/7.
//  Copyright © 2016年 beijingduanluo. All rights reserved.
//


#import "CarViewController.h"
#import "ShopCartCell.h"
#import "ShopCarFooterView.h"
#import "ShopCarHeaderView.h"
#import <Foundation/Foundation.h>

#import "shopConfig.h"

@interface CarViewController ()<UITableViewDataSource,UITableViewDelegate,footerViewDelegate,shopCartDelegate>
{
    ShopCartCell *shopCell;
    ShopCarFooterView *foot;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *array;

@property(nonatomic,strong)UIButton *allSelectBtn;
@property(nonatomic,strong)UILabel *totalPriceLabel;

@end

@implementation CarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"购物车";
    self.view.backgroundColor =[UIColor whiteColor];
    self.isonOff = YES;
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    ShopModel *model =[[ShopModel alloc]init];
    model.imgStr =@"img";
    model.title=@"饮料";
    model.price = @"19";
    model.num = @"1";
    model.isSelected = @"true";
    
    ShopModel *model1 =[[ShopModel alloc]init];
    model1.imgStr =@"img-1";
    model1.title=@"高级玫瑰礼盒";
    model1.price = @"109";
    model1.num = @"1";
    model1.isSelected = @"true";
    
    ShopModel *model2 =[[ShopModel alloc]init];
    model2.imgStr =@"img2";
    model2.title=@"生日蛋糕";
    model2.price = @"109";
    model2.num = @"1";
    model2.isSelected = @"true";
    
    ShopModel *mode =[[ShopModel alloc]init];
    mode.imgStr =@"img";
    mode.title=@"饮料";
    mode.price = @"200";
    mode.num = @"1";
    mode.isSelected = @"true";
    
    ShopModel *mod =[[ShopModel alloc]init];
    mod.imgStr =@"img-1";
    mod.title=@"高级玫瑰礼盒";
    mod.price = @"9";
    mod.num = @"1";
    mod.isSelected = @"true";
    
    ShopModel *mods =[[ShopModel alloc]init];
    mods.imgStr =@"img2";
    mods.title=@"生日蛋糕";
    mods.price = @"10";
    mods.num = @"1";
    mods.isSelected = @"true";
    NSMutableArray *array =[NSMutableArray arrayWithObjects:mod,mode,mods, nil];
    _array =[NSMutableArray array];
    _dataArray =[NSMutableArray array];
    [ _dataArray addObject:model];
    [_dataArray addObject:model2];
    [_dataArray addObject:model1];
    [_array addObject:_dataArray];
    [_array addObject:array];
    
}


#pragma tableView&Delegate&DataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     shopCell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!shopCell) {
        shopCell = [[ShopCartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    shopCell.delegate = self;
    NSMutableArray *array =_array[indexPath.section];
    shopCell.model = array[indexPath.row];
    shopCell.selectionStyle =UITableViewCellSelectionStyleNone;
    return shopCell;
}
//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80*Height;
}
//cell的个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array =_array[section];
    return array.count;
}
//区头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30*Height;
}
//区尾的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50*Height;
}
//区的个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _array.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ShopCarHeaderView *head =[[ShopCarHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30*Height)];
    return head;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    foot =[[ShopCarFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50*Height)];
    foot.delegate = self;
    int cout = 0;
    NSMutableArray *array =self.array[section];
    if (array != nil) {
        for (int i = 0; i < array.count; i++) {
            ShopModel *shopModel =array[i];
            if ([shopModel.isSelected isEqualToString:@"true"]) {
                cout++;
                float total =shopModel.price.floatValue*shopModel.num.intValue;
                NSString *totalPrice =[foot.totalPriceLabel.text substringFromIndex:3];
                foot.totalPriceLabel.text =[NSString stringWithFormat:@"总价：%.2f",total+totalPrice.floatValue];
            }
        }
        
    if (array.count == cout) {
       // self.isonOff = YES;
        [foot.allSelectBtn setImage:[UIImage imageNamed:@"btnSelected"] forState:UIControlStateNormal];
    }else{
       // self.isonOff = NO;
        [foot.allSelectBtn setImage:[UIImage imageNamed:@"addShop_bord"] forState:UIControlStateNormal];
    }
}
    
    foot.allSelectBtn.tag=(section +1)*1000;
    return foot;
}

#pragma cell的代理
-(void)shopCartDelegate:(ShopCartCell *)cell WithBtn:(UIButton *)btn
{
    NSIndexPath *indexPath =[self.tableView indexPathForCell:cell];
    int couss=0 ;
    NSArray *array =self.array[indexPath.section];
    for (int i =0; i<array.count; i++) {
        ShopModel *model =array[i];
        
        if (i==indexPath.row) {
            if (btn.selected) {
                model.isSelected = @"true";
                
            }else{
               model.isSelected = @"false";
            }
           
        }
        if ([model.isSelected isEqualToString:@"true"]) {
            couss++;
        }
    }
    if (couss == array.count) {
        self.isonOff = NO;
    }else{
        self.isonOff = YES;
    }
    [self.tableView reloadData];
}

-(void)shopCartDelegateNum:(ShopCartCell *)cell WithBtn:(UIButton *)btn
{
    NSIndexPath *indexPath =[self.tableView indexPathForCell:cell];
    NSArray *array =self.array[indexPath.section];
    for (int i =0; i<array.count; i++) {
        ShopModel *model =array[i];
        
        if (i==indexPath.row) {
            if (btn.tag == 2000) {
                model.num =[NSString stringWithFormat:@"%d",model.num.intValue+1];
            }else{
                if (model.num.intValue == 1) {
                    
                }else{
                model.num =[NSString stringWithFormat:@"%d",model.num.intValue-1];
                }
            }
            
        }
    }
    [self.tableView reloadData];
}
//点击cell执行的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



-(void)footerViewdelegate:(ShopCarFooterView *)footer AndBtn:(UIButton *)btn
{
    
    if (self.isonOff) {
        NSInteger section =btn.tag/1000-1;
        for (int i = 0; i<_array.count; i++) {
            NSMutableArray *array =_array[i];
            if (i==section) {
                for (int j = 0; j<array.count; j++) {
                    ShopModel *model =array[j];
                    model.isSelected = @"true";
                }
            }
        }
        self.isonOff = NO;
    }else{
        NSInteger section =btn.tag/1000-1;
        for (int i = 0; i<_array.count; i++) {
            NSArray *array =_array[i];
            if (i==section) {
                for (int j = 0; j<array.count; j++) {
                    ShopModel *model =array[j];
                    model.isSelected = @"false";
                }
            }
        }
        self.isonOff = YES;
    }
    [self.tableView reloadData];
}




















@end
