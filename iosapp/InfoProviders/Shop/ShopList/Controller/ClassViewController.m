//
//  ClassViewController.m
//  GiftSay
//
//  Created by lanou on 15/12/16.
//  Copyright (c) 2015年 lanou. All rights reserved.
//
#import "LORequestManger.h"
#import "ClassViewController.h"
#import "ClassCollectionViewCell.h"
#import "Classmodel.h"
#import "headerview.h"
#import "detailmodel.h"
#import "StagetyTableViewController.h"
#define kwidth [UIScreen mainScreen].bounds.size.width
#define KHeight [UIScreen mainScreen].bounds.size.height


@interface ClassViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
@property (nonatomic,retain) UIScrollView  *scrollview;
@property (nonatomic,retain) UICollectionView  *collection;
@property (nonatomic,retain) NSMutableArray  *sectionArray;

@property (nonatomic,retain) NSMutableDictionary  *dic;
@property (nonatomic,retain) NSArray  *Srr;

@property (nonatomic,retain) NSMutableArray  *iamgearray;

@property (nonatomic,retain) headerview  *main;

@property (nonatomic,retain) UITableView  *table;

@property (nonatomic,retain) NSMutableArray  *titlename;

@property (nonatomic,retain) NSMutableDictionary  *list;

@property (nonatomic,retain) UISegmentedControl  *segement;
@property (nonatomic,retain) UICollectionView  *coll;

@property (nonatomic,assign)  NSInteger row;
@property (nonatomic,assign) NSInteger  a;

@property (nonatomic,assign) NSInteger  b;







@end

@implementation ClassViewController

- (NSMutableDictionary*)list{
    if (!_list) {
        _list=[NSMutableDictionary dictionary];
    }
    return _list;
}

- (NSMutableArray*)titlename{
    if (!_titlename) {
        _titlename=[NSMutableArray array];
            }

    return _titlename;

}
- (NSMutableArray*)sectionArray{
    if (!_sectionArray) {
        _sectionArray=[NSMutableArray array];
    }
    return _sectionArray;

}
- (NSMutableDictionary*)dic{
    if (!_dic) {
        _dic=[NSMutableDictionary dictionary];
    }

    return _dic;
}
- (NSMutableArray*)iamgearray{
    if (!_iamgearray) {
        _iamgearray=[NSMutableArray array];
    }
    return _iamgearray;
}


- (void)setdata{
    
    [LORequestManger GET:@"http://api.liwushuo.com/v2/channel_groups/all" success:^(id response) {
        
        NSDictionary*dic=(NSDictionary* )response;
        NSArray*arr=dic[@"data"][@"channel_groups"];
        for (NSDictionary*dic in arr) {
            [self.sectionArray addObject:dic[@"name"]];
           
            
            NSArray*Arry=dic[@"channels"];
            NSMutableArray*tab=[NSMutableArray array];
            for (NSDictionary*dic1 in Arry) {
                Classmodel *model=[[Classmodel alloc]init];
                [model setValuesForKeysWithDictionary:dic1];
                [tab addObject:model];
            }
            [self.dic setValue:tab forKey:dic[@"name"]];
                  }
        
        
        [self.collection reloadData];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    
}
- (void)setimage{
    
    
    [LORequestManger GET:@"http://api.liwushuo.com/v2/collections?limit=10&offset=0" success:^(id response) {
        NSDictionary*dic=(NSDictionary*)response;
        NSArray*array=dic[@"data"][@"collections"];
        for (NSDictionary*dic in array) {
           
            [self.iamgearray addObject:dic[@"banner_image_url"]];
                  }
       
       
        
        self.main=[[headerview alloc]initWithFrame:CGRectMake(10, 50, kwidth, 50) delegate:self action:@selector(dlick) imageArray:_iamgearray ];
        
        
        
       // [self.collection reloadData];
    
    
    
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
   
    
    
    }];
    
    
}
- (void)dlick{
    
}
- (void)setdeatil{
    [LORequestManger GET:@"http://api.liwushuo.com/v2/item_categories/tree" success:^(id response) {
        NSDictionary*Dic=(NSDictionary*)response;
        NSArray*arr=Dic[@"data"][@"categories"];
        for (NSDictionary*dic in arr) {
            [self.titlename addObject:dic[@"name"]];
            NSArray*arry=dic[@"subcategories"];
            NSMutableArray*arr1=[NSMutableArray array];
            for (NSDictionary*dic1 in arry) {
                detailmodel*model1=[[detailmodel alloc]init];
                [model1 setValuesForKeysWithDictionary:dic1];
                [arr1 addObject:model1];
            
            }
            [self.list setValue:arr1 forKey:dic[@"name"]];
            
        
        }
        _table=[[UITableView alloc]initWithFrame:CGRectMake(kwidth, 50, 100, KHeight-20)];
        _table.delegate=self;
        _table.dataSource=self;
        [self.scrollview addSubview:_table];
        
        [self deatailcollection];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];



}





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = searchBarButtonItem;
        [self setdata];
    [self setimage];
    [self setdeatil];

    
    _a=1;
    _b=1;
    _segement=[[UISegmentedControl alloc]initWithItems:@[@"攻略",@"详情"]];
    _segement.frame=CGRectMake(90, 20, kwidth-180, 30);
    _segement.tintColor=[UIColor blackColor];
    _segement.selectedSegmentIndex=0;
    [_segement addTarget:self action:@selector(changevalue:) forControlEvents:(UIControlEventValueChanged)];
    self.navigationItem.titleView =_segement;
     self.scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kwidth, KHeight)];
    _scrollview.directionalLockEnabled=YES;
    _scrollview.contentSize=CGSizeMake(kwidth*2, KHeight);
    _scrollview.delegate=self;
    
    
    [self.view addSubview:self.scrollview];
    UICollectionViewFlowLayout*flow=[[UICollectionViewFlowLayout alloc]init];
       //列距
    flow.minimumInteritemSpacing=20;
    
    //行距
    flow.minimumLineSpacing=40;
        //分区内边距
    flow.sectionInset=UIEdgeInsetsMake(0, 20, 20, 20);
        CGFloat totalwidth=self.view.frame.size.width;
    
    CGFloat itemwidth=(totalwidth-2*20-3*20)/4.0;
   
    CGFloat itemheight=itemwidth;
   
    flow.itemSize=CGSizeMake(itemwidth, itemheight);
   
    flow.headerReferenceSize=CGSizeMake(0, 40);
   
    //滚动方向
    flow.scrollDirection= UICollectionViewScrollDirectionVertical;
    ;
    
    //区头大小
    flow.headerReferenceSize=CGSizeMake(0, 100);
    
    _collection=[[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flow];
    _collection.backgroundColor=[UIColor whiteColor];
    _collection.tag=1;
   _Srr=@[@"1",@"s",@"2",@"r"];
    for (NSString*St in _Srr) {
        [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:St];}
    //设置 数据源 和代理
    _collection.dataSource=self;
    _collection.delegate=self;
    [_collection registerClass:[ClassCollectionViewCell class] forCellWithReuseIdentifier:@"mycell"];
    // _collection.backgroundColor=[UIColor yellowColor];
    _collection.directionalLockEnabled=YES;
    
    [self.scrollview addSubview:_collection];
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(kwidth, 0, kwidth, 30)];
   // view.backgroundColor = [UIColor whiteColor];
    UIButton*label=[UIButton buttonWithType:(UIButtonTypeSystem)];
    label.frame=CGRectMake(0, 20, 200, 14) ;
    [label setTitle:@"选礼神器" forState:(UIControlStateNormal)];
    [label addTarget:self action:@selector(xuan) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:label];
    [self.scrollview addSubview:view];
   
    
}
- (void)xuan{
  
}


- (void)searchBarButtonItemAction{
   }


- (void)changevalue:(UISegmentedControl*)segment{
    
    switch (segment.selectedSegmentIndex) {
        case 0:
            _scrollview.contentOffset=CGPointMake(0, -50);
            break;
          case 1:
       _scrollview.contentOffset=CGPointMake(kwidth, -50);
            break;
    }
    
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat x=_scrollview.contentOffset.x;
    NSInteger a=x/_scrollview.frame.size.width;
    _segement.selectedSegmentIndex=a;
    


}

- (void)deatailcollection{
    
    UICollectionViewFlowLayout*flow1=[[UICollectionViewFlowLayout alloc]init];
    
    //列距
   
    flow1.minimumInteritemSpacing=10;
    //行距
    
    flow1.minimumLineSpacing=30;
    //分区内边距
   
    flow1.sectionInset=UIEdgeInsetsMake(0, 10, 10, 10);
    CGFloat totalwidth=self.view.frame.size.width;
    
       CGFloat itemwideth1=(totalwidth-2*10-2*10 )/3.0;
       CGFloat itemh=itemwideth1;
   
    flow1.itemSize=CGSizeMake(itemwideth1, itemh);
  
    flow1.headerReferenceSize=CGSizeMake(0, 50);
    //滚动方向
       flow1.scrollDirection=UICollectionViewScrollDirectionVertical;
    //区头大小
   
    flow1.headerReferenceSize=CGSizeMake(0, 30);
   _coll=[[UICollectionView alloc]initWithFrame:CGRectMake(kwidth+100, 50, kwidth-100, KHeight-50) collectionViewLayout:flow1];
    _coll.tag=2;
    _coll.dataSource=self;
    _coll.delegate=self;
    [_coll registerClass:[ClassCollectionViewCell class] forCellWithReuseIdentifier:@"mycell"];
    _coll.backgroundColor=[UIColor whiteColor];
    
    
    for (NSString*St in _titlename) {
        
   
    [_coll registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier:St];
    
    }
    [self.scrollview addSubview:_coll];



}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //默认为1个分区
    if (collectionView.tag==1) {
        return _sectionArray.count;    }else {
            return _titlename.count;
        }
    
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag==1) {
        return [_dic[_sectionArray[section] ] count];
    }else{
        return [_list[_titlename[section]] count] ;
    }
   
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    
    
    if (collectionView.tag==1) {
        ClassCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"mycell" forIndexPath:indexPath];        Classmodel*model=_dic[_sectionArray[indexPath.section]][indexPath.row];
        cell.model=model;
    return cell;
    }else{
        ClassCollectionViewCell*cell1=[collectionView dequeueReusableCellWithReuseIdentifier:@"mycell" forIndexPath:indexPath];
        detailmodel*model=_list[_titlename[indexPath.section]][indexPath.item];
        cell1.detail=model;
       
        
        return cell1;
    }
    
    
}
//点击事件
- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag==1) {
        
    UICollectionReusableView*header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:_Srr[indexPath.section] forIndexPath:indexPath];
   // header.backgroundColor=[UIColor redColor];
    
    
    if (indexPath.section==0) {
        
    
        [header addSubview:_main];
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(25, 110, 150, 20)];
        label.text=_sectionArray[indexPath.section];
        label.textColor=[UIColor blackColor];
        label.font=[UIFont systemFontOfSize:18];
        
        [header addSubview:label];
        UILabel*label1=[[UILabel alloc]initWithFrame:CGRectMake(25, 20, 150, 20)];
        label1.text=@"专题";
        label1.textColor=[UIColor blackColor];
        label1.font=[UIFont systemFontOfSize:18];
        
        [header addSubview:label1];
    
        UIButton*button=[UIButton buttonWithType:(UIButtonTypeSystem)];
        button.frame=CGRectMake(kwidth-130, 20, 150, 20);
        [button setTitle:@"查看全部" forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(more) forControlEvents:(UIControlEventTouchUpInside)];
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [header addSubview:button];
   
    
    }else{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(25, 70, 150, 20)];
    label.text=_sectionArray[indexPath.section];
    label.textColor=[UIColor blackColor];
    label.font=[UIFont systemFontOfSize:18];
    
        [header addSubview:label];}
  
    
        return header;
    }else{
        UICollectionReusableView*header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:_titlename[indexPath.section] forIndexPath:indexPath];
        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(header.frame.size.width/2-100, 20, 200, 18)];
        label.text=_titlename[indexPath.section];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:14];
        
        [header addSubview:label];
        
        
        return header;
    }

}
- (void)more{
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (collectionView.tag==1) {
        
    
    if (section==0) {
         return CGSizeMake(0,150);
    }else{
        return CGSizeMake(0, 100);
    }
    }else{
         return CGSizeMake(0,50);    }
   
}



- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    //在didenddisplay 执行完之后在执行;
    _b=_a;
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{

if (collectionView.tag==2) {
    
    NSArray*arr=[NSArray array];
    arr=[_coll indexPathsForVisibleItems];
    if (arr.count>0) {
        
        if (_a!=_b) {
            
            NSIndexPath*dex3=[NSIndexPath indexPathForRow:_row inSection:0];
            UITableViewCell*cell3=(UITableViewCell*)[_table cellForRowAtIndexPath:dex3];
            
            cell3.textLabel.textColor=[UIColor blackColor];
            cell3.backgroundColor=[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.3];
            
            
            
            NSIndexPath*dex=[NSIndexPath indexPathForRow:_a inSection:0];
            
            
            NSIndexPath*dex1=[NSIndexPath indexPathForRow:_b inSection:0];
            UITableViewCell*cell=(UITableViewCell*)[_table cellForRowAtIndexPath:dex1];
            
            cell.textLabel.textColor=[UIColor blackColor];
            cell.backgroundColor=[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.3];
            
           
            UITableViewCell*cell1=(UITableViewCell*)[_table cellForRowAtIndexPath:dex];
            cell1.textLabel.textColor=[UIColor redColor];
            cell1.backgroundColor=[UIColor whiteColor];
            
            [_table scrollToRowAtIndexPath:dex atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
                        _row=_b;
            
        }else{
    
        NSIndexPath*p=arr[0];
        NSLog(@"%@",p);
            NSIndexPath*dex2=[NSIndexPath indexPathForRow:_b inSection:0];
            UITableViewCell*cell2=(UITableViewCell*)[_table cellForRowAtIndexPath:dex2];
            
            cell2.textLabel.textColor=[UIColor blackColor];
            cell2.backgroundColor=[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.3];
            
        NSIndexPath*dex=[NSIndexPath indexPathForRow:p.section inSection:0];
    
    NSIndexPath*dex1=[NSIndexPath indexPathForRow:_row inSection:0];
    UITableViewCell*cell=(UITableViewCell*)[_table cellForRowAtIndexPath:dex1];
    
    cell.textLabel.textColor=[UIColor blackColor];
            cell.backgroundColor=[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.3];
            
        UITableViewCell*cell1=(UITableViewCell*)[_table cellForRowAtIndexPath:dex];
        cell1.textLabel.textColor=[UIColor redColor];
         cell1.backgroundColor=[UIColor whiteColor];
        
    [_table scrollToRowAtIndexPath:dex atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
    
    _row=p.section;
    
        }
        }

    
    }
  }
//table-------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlename.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* ide=@"cell";
    
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ide];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:ide];
    }
    cell.textLabel.text=_titlename[indexPath.row];
    
    cell.textLabel.textColor=[UIColor blackColor];
    cell.backgroundColor=[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.3];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _a=indexPath.row;
    NSIndexPath*dex=[NSIndexPath indexPathForRow:0 inSection:indexPath.row];
    
    [self.coll scrollToItemAtIndexPath:dex atScrollPosition:(UICollectionViewScrollPositionTop) animated:NO];
   
    [_table scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
    
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
