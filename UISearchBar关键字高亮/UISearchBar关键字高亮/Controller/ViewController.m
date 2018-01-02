//
//  ViewController.m
//  UISearchBar关键字高亮
//
//  Created by xgm on 2018/1/2.
//  Copyright © 2018年 www.auratech.hk. All rights reserved.
//

#import "ViewController.h"
#import "MemberViewCell.h"
#import "UserModel.h"


#define Width  [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic,strong)UITableView  *tabView;

@property(nonatomic,strong)UISearchBar* searchBar;

@property (nonatomic, strong) NSMutableArray *dataArray;  //数据源

@property (nonatomic, strong)NSMutableArray* dataSourceForSearM;    //搜索时数据源

@end

@implementation ViewController

#pragma mark - 懒加载
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
-(NSMutableArray*)dataSourceForSearM{
    if(!_dataSourceForSearM){
        _dataSourceForSearM=[[NSMutableArray alloc]init];
    }
    return _dataSourceForSearM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableView];
    
    [self _initializeData];
}

#pragma mark - Private Method
-(void)_initializeData{
    // 解析 json 假数据
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"PersonList" ofType:@".json"];
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:jsonPath]];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSArray *personArray = jsonDict[@"data"];
    
    //加载数据源
    for (NSString *str in personArray) {
        UserModel   *usermodel = [[UserModel alloc]init];
        usermodel.name = str;
        [self.dataArray addObject:usermodel];
    }
    self.dataSourceForSearM = [self.dataArray mutableCopy];
}


#pragma mark - Init the TableView
-(void)setTableView{
    self.tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,Width, Height-49) style:UITableViewStylePlain];
    self.tabView.backgroundColor = UIColorFromRGB(0xf0f0f6);
    self.tabView.tableFooterView = [[UIView alloc]init];
    self.tabView.userInteractionEnabled = YES;
    [self.view addSubview:self.tabView];
    
    //设置searchBar
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, Width, 44)];
    [self.searchBar setBackgroundColor:[UIColor colorWithRed:32/255.0 green:77/255.0 blue:136/255.0 alpha:1.0]];
    self.searchBar.showsCancelButton=NO;
    self.searchBar.tintColor = UIColorFromRGB(0x2baadf);
    self.searchBar.delegate=self;
    self.tabView.tableHeaderView = self.searchBar;
    
    //设置代理
    self.tabView.dataSource = self;
    self.tabView.delegate = self;
    self.tabView.rowHeight = [MemberViewCell fixedHeight];
    self.tabView.sectionIndexBackgroundColor = [UIColor clearColor];
    
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceForSearM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"SDContacts";
    MemberViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MemberViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    NSUInteger row = indexPath.row;
    UserModel  *model = self.dataSourceForSearM[row];
    // 原始搜索结果字符串.
    NSString *originResult =model.name;

    // 获取关键字的位置
    NSRange range = [originResult rangeOfString:self.searchBar.text];
    // 转换成可以操作的字符串类型.
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:originResult];
    // 添加属性(粗体)
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
    // 关键字高亮
     UIColor *highlightedColor = [UIColor colorWithRed:0 green:131/255.0 blue:0 alpha:1.0];
    [attribute addAttribute:NSForegroundColorAttributeName value:highlightedColor range:range];
    // 将带属性的字符串添加到cell.textLabel上.
    [cell.nameLabel setAttributedText:attribute];
    cell.nameLabel.text = model.name;
    cell.iconImageView.image = [UIImage imageNamed:@"user_img_default"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 文本搜索Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    _searchBar.showsCancelButton = NO;
}

//搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];   //让键盘掉下
}

//结束编辑
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
}


//取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    
    self.dataSourceForSearM  = [self.dataArray mutableCopy];
    [self.tabView reloadData];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.dataSourceForSearM removeAllObjects];
    for (UserModel *user in self.dataArray) {
        if([[user.name uppercaseString] rangeOfString:[searchText uppercaseString]].location != NSNotFound){
            [self.dataSourceForSearM addObject:user];
        }
    }
    
    //搜索框内容为空
    if(searchText.length == 0){
        [self.dataSourceForSearM removeAllObjects];
        self.dataSourceForSearM  = [self.dataArray mutableCopy];
    }
    
    [self.tabView reloadData];
}

//上下滑动的时候键盘收起
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
