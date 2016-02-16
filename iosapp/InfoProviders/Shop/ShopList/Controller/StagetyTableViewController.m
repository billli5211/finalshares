//
//  StagetyTableViewController.m
//  GiftSay
//
//  Created by lanou on 15/12/22.
//  Copyright (c) 2015年 lanou. All rights reserved.
//
#import "LORequestManger.h"
#import "StagetyTableViewController.h"
#import "ContentTableViewCell.h"
#import "imagemodel.h"
@interface StagetyTableViewController ()
@property (nonatomic,retain) NSMutableDictionary  *Dic;
@property (nonatomic,retain) NSMutableArray  *imageArray;

@end

@implementation StagetyTableViewController
- (NSMutableArray*)imageArray{
    if (!_imageArray) {
        _imageArray=[NSMutableArray array];
    }
    return _imageArray;
}


- (void)setimage{
    
    // NSMutableArray*arry=[NSMutableArray array];
    self.Dic=[NSMutableDictionary dictionary];
    [LORequestManger GET:_url success:^(id response) {
        NSDictionary*Dic=(NSDictionary*)response;
        NSArray*arr=[NSArray array];
        arr=Dic[@"data"][@"items"];
        for (NSDictionary*Dic in arr) {
            imagemodel*model=[[imagemodel alloc]init];
            [model setValuesForKeysWithDictionary:Dic];
            NSLog(@"%@",model.title);
            
            [self.imageArray addObject:model];
        }
       [self.tableView reloadData];
        
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setimage];
    self.tableView.rowHeight=220;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _imageArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
static NSString *ide=@"cell";
    ContentTableViewCell*Cell=[tableView dequeueReusableCellWithIdentifier:ide];
    if (Cell==nil) {
        Cell=[[ContentTableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:ide];
    }
    Cell.iamge=_imageArray[indexPath.row];


    return Cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
