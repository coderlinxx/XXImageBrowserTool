//
//  ViewController.m
//  ImageBrowserTool
//
//  Created by 林祥兴 on 16/2/15.
//  Copyright © 2016年 pogo.inxx. All rights reserved.
//

#import "ViewController.h"

#import "UIImageView+XXImageBrowser.h"

#define SCREEN_Width ([[UIScreen mainScreen] bounds].size.width)

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self addHeaderView];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}
-(UIView *)addHeaderView{
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, -64, SCREEN_Width, 200)];
    [header setImage:[UIImage imageNamed:@"bg"]];
    header.contentMode = UIViewContentModeScaleAspectFill;
    header.clipsToBounds = YES;
    
    [header setImageBrowseAndSaveEnabled:YES];
    
    return header;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"ViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.imageView.image = [UIImage imageNamed:@"bg"];
    [cell.imageView setImageBrowseEnabled:YES];
    cell.textLabel.text = [NSString stringWithFormat:@" 第 %zd 行 - %@",indexPath.row,[self class]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
