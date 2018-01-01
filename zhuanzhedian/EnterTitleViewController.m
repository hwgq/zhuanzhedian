//
//  EnterTitleViewController.m
//  zhuanzhedian
//
//  Created by Gaara on 16/9/14.
//  Copyright © 2016年 Gaara. All rights reserved.
//

#import "EnterTitleViewController.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
#import "AFNetworking.h"
#import "SearchResultCell.h"
#import "UILableFitText.h"
@interface EnterTitleViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong)UITextField *enterTextField;
@property (nonatomic, strong)UILabel *textNumLabel;
@property (nonatomic, strong)NSArray *tagArr;
@property (nonatomic, strong)UIView *tagBackView;
@property (nonatomic, strong)UITableView *tagTable;
@property (nonatomic, strong)UIScrollView *resultScrollView;
@property (nonatomic, strong)UILabel *titleView;
@end
@implementation EnterTitleViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)goToLastPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)cancelAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        if (self.enterTextField.text.length > 0) {
            [self.delegate getTitleFromDic:@{@"title":self.enterTextField.text}];
            
        }
    }
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHexCode:@"#ffffff"];
    
    
//    UIImageView *imageBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//    imageBack.image = [UIImage imageNamed:@"back_icon.png"];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
//    [imageBack addGestureRecognizer:tap];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:imageBack];
    
//    UIButton *completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 50, 30)];
//    [completeBtn setTitle:@"保存" forState:UIControlStateNormal];
//    completeBtn.titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
//    [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [completeBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:completeBtn];
    
    
    UIView *textBackView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, self.view.frame.size.width - 80 , 30)];
    textBackView.backgroundColor = [UIColor whiteColor];
    
    textBackView.layer.cornerRadius = 25/ 2.0;
    textBackView.layer.masksToBounds = YES;
//    [self.view addSubview:textBackView];
  
    
    
    
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 1)];
//    lineView.backgroundColor = [UIColor colorFromHexCode:@"bbbbbb"];
//    [textBackView addSubview:lineView];
    
//    UIView *lineViewTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 59, self.view.frame.size.width, 1)];
//    lineViewTwo.backgroundColor = [UIColor colorFromHexCode:@"#eeeeee"];
//    [textBackView addSubview:lineViewTwo];
    
    self.enterTextField =  [[UITextField alloc]initWithFrame:CGRectMake(10, 3.5, self.view.frame.size.width - 100, 25)];
    self.enterTextField.textColor = [UIColor colorFromHexCode:@"#666666"];
    [self.enterTextField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    self.enterTextField.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
   
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"请输入\"%@\"对应的职位名称",self.currentType]];
    [placeholder addAttribute:NSForegroundColorAttributeName
                       value:[UIColor colorFromHexCode:@"bbbbbb"]
                       range:NSMakeRange(0, 12+self.currentType.length)];
    [placeholder addAttribute:NSFontAttributeName
                       value:[[FontTool customFontArrayWithSize:14]objectAtIndex:1]
                       range:NSMakeRange(0, 12+self.currentType.length)];
    self.enterTextField.attributedPlaceholder = placeholder;
    self.enterTextField.text = self.currentStr;
    self.enterTextField.delegate = self;
    self.enterTextField.returnKeyType = UIReturnKeyGo;
    [textBackView addSubview:self.enterTextField];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:textBackView];
//    [self.view addSubview:textBackView];
    
    self.textNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 5, 90, 20)];
    self.textNumLabel.font = [[FontTool customFontArrayWithSize:12]objectAtIndex:1];
    self.textNumLabel.textColor = [UIColor colorFromHexCode:@"#c6c6c6"];
    self.textNumLabel.text = @"0 / 10";
    self.textNumLabel.textAlignment = 2;
//    [self.view addSubview:self.textNumLabel];
    
//    if (self.currentType) {
//        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
//        titleLabel.textColor = [UIColor whiteColor];
//        titleLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
//        titleLabel.textAlignment = 1;
//        titleLabel.text = self.currentType;
//        self.navigationItem.titleView = titleLabel;
//    }
    
    NSLog(@"%@",self.currentType);
    
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 16)];
    backImageView.image = [UIImage imageNamed:@"navbar_icon_back.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToLastPage)];
    [backImageView addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backImageView];
    
}

- (void)valueChanged:(UITextField *)field
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.operationQueue cancelAllOperations];
    
    
    NSString *url = [NSString stringWithFormat:@"http://api.zzd.hidna.cn/v1/jd/recommend/%@",field.text];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    self.textNumLabel.text = [NSString stringWithFormat:@"%lu / 10",field.text.length];
    if (self.enterTextField.text.length > 10) {
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:self.textNumLabel.text];
        [str addAttribute:NSForegroundColorAttributeName  value:[UIColor redColor] range:NSMakeRange(0, self.textNumLabel.text.length - 5)];
        self.textNumLabel.attributedText = str;

        
    }
    if (field.text.length == 0) {
        [self.tagTable removeFromSuperview];
        self.tagTable = nil;
    }else{
    [self reloadTagTable];
    }
    if (field.text.length == 0) {
        
    }else{
//    self.titleView.text = [NSString stringWithFormat:@"   查找""%@""",field.text];
        NSMutableAttributedString *searchStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"  以下职位供您参考"]];
//        [searchStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexCode:@"#38AB99"] range:NSMakeRange(searchStr.length - 2, 2)];
        self.titleView.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
        [searchStr addAttribute:NSFontAttributeName value:[[FontTool customFontArrayWithSize:14]objectAtIndex:1] range:NSMakeRange(0, searchStr.length)];
//        [searchStr addAttribute:NSFontAttributeName value:[[FontTool customFontArrayWithSize:16]objectAtIndex:1] range:NSMakeRange(searchStr.length - 2, 2)];
        self.titleView.attributedText = searchStr;
    }
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"ret"]isEqualToString:@"0"]) {
            NSArray *arr = [responseObject objectForKey:@"data"];
            if ([arr isKindOfClass:[NSArray class]]) {
                self.tagArr = arr;
//                [self reloadTagViews];
                int a = 0;
                for (NSString *resultStr in self.tagArr) {
                    if ([resultStr isEqualToString:field.text]) {
                        a = 100;
                    }
                }
                if (a == 0) {
                    NSMutableArray *resultArr = @[field.text].mutableCopy;
                    [resultArr addObjectsFromArray:self.tagArr];
                    self.tagArr = resultArr.copy;
                    
                }
                    [self reloadTagTable];
                
                if (field.text.length == 0) {
                    
                }else{
                    //    self.titleView.text = [NSString stringWithFormat:@"   查找""%@""",field.text];
                    NSMutableAttributedString *searchStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"  以下职位供您参考"]];
//                    [searchStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexCode:@"#38AB99"] range:NSMakeRange(searchStr.length - 2, 2)];
                    self.titleView.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
//                    [searchStr addAttribute:NSFontAttributeName value:[[FontTool customFontArrayWithSize:14]objectAtIndex:1] range:NSMakeRange(0, searchStr.length)];
//                    [searchStr addAttribute:NSFontAttributeName value:[[FontTool customFontArrayWithSize:16]objectAtIndex:1] range:NSMakeRange(searchStr.length - 2, 2)];
                    self.titleView.attributedText = searchStr;
                }

                
            }
        }else {
            self.tagArr = @[];
            [self.tagBackView removeFromSuperview];
            self.tagBackView = nil;
          
            [self reloadTagTable];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
}
- (void)reloadTagTable
{
    if (!self.tagTable) {
        self.tagTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height )];
        self.tagTable.delegate = self;
        self.tagTable.dataSource = self;
        self.tagTable.rowHeight = 40;
        self.tagTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tagTable.backgroundColor = [UIColor colorFromHexCode:@"#ffffff"];
        [self.view addSubview:self.tagTable];
        
        self.titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
        self.titleView.textColor = [UIColor colorFromHexCode:@"#bbbbbb"];
        self.titleView.font = [[FontTool customFontArrayWithSize:15]objectAtIndex:1];
//        self.titleView.backgroundColor = [UIColor colorFromHexCode:@"fbfbf8"];
        self.tagTable.tableHeaderView = self.titleView;
        
        [self.tagTable reloadData];
    }else{
        [self.tagTable reloadData];
    }
//    if (self.tagArr.count > 0) {
//    if (!self.resultScrollView) {
//        self.resultScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height - 65)];
//        self.resultScrollView.backgroundColor = [UIColor colorFromHexCode:@"#eeeeee"];
//        [self.view addSubview:self.resultScrollView];
//        
//        self.titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
//        self.titleView.textColor = [UIColor colorFromHexCode:@"#bbbbbb"];
//        self.titleView.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
//        [self.resultScrollView addSubview:self.titleView];
//        
//        int tagLine = 0;
//        CGFloat tagWeight = 0.0;
//        for (NSString *tagStr in self.tagArr) {
//            UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//            tagLabel.text = tagStr;
//            tagLabel.layer.borderWidth = 1;
//            tagLabel.layer.borderColor = [UIColor colorFromHexCode:@"999999"].CGColor;
//            tagLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
//            tagLabel.userInteractionEnabled = YES;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTap:)];
//            [tagLabel addGestureRecognizer:tap];
//            tagLabel.textColor = [UIColor colorFromHexCode:@"999999"];
//            tagLabel.layer.cornerRadius = 10;
//            tagLabel.textAlignment = 1;
//            [self.resultScrollView addSubview:tagLabel];
//            
//            CGSize tagLabelSize = [UILableFitText fitTextWithHeight:20 label:tagLabel];
//            
//            if (tagWeight + tagLabelSize.width + 30 > self.view.frame.size.width) {
//                tagLine = tagLine + 1;
//                tagWeight = 30 + tagLabelSize.width;
//                tagLabel.frame = CGRectMake(5, tagLine * 35 + 50, tagLabelSize.width + 20, 25);
//                NSLog(@"%@",tagLabel);
//                
//            }else{
//                tagLabel.frame = CGRectMake(5 + tagWeight, tagLine * 35 + 50, tagLabelSize.width + 20, 25);
//                NSLog(@"%@",tagLabel);
//                tagWeight = tagWeight + tagLabelSize.width + 30;
//                
//            }
//            
//            
//        }
//        
//    }else{
//        [self.resultScrollView removeFromSuperview];
//        self.resultScrollView = nil;
//        [self reloadTagTable];
//    }
//    }else{
//        [self.resultScrollView removeFromSuperview];
//        
//    }
}
- (void)labelTap:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)tap.view;
    self.enterTextField.text = label.text;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tagArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SearchResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setTitleText:[self.tagArr objectAtIndex:indexPath.row] key:nil];
    
    return cell;
}
- (void)reloadTagViews
{
    for (int i = 0 ; i < 1000; i++) {
        UILabel *label = [self.view viewWithTag:i + 1];
        if (label == nil) {
            break;
        }else{
            [label removeFromSuperview];
        }
    }
    
    if (self.tagBackView == nil) {
        self.tagBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 0)];
        [self.view addSubview:self.tagBackView];
    }else{
        
    }
    for (int i = 0; i < self.tagArr.count; i++) {
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(10 + i % 3 * 120, i / 3 * 100 + 20 , 110, 30)];
        if (i == (self.tagArr.count - 1)) {
            self.tagBackView.frame = CGRectMake(0, 100, self.view.frame.size.width, i / 3 * 100 + 80);
        }
        lb.tag = i + 1;
        lb.textAlignment = 1;
        lb.font = [[FontTool customFontArrayWithSize:12]objectAtIndex:1];
        lb.backgroundColor = [UIColor blackColor];
        lb.textColor = [UIColor whiteColor];
        lb.text = [self.tagArr objectAtIndex:i];
        [self.tagBackView addSubview:lb];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tagArr objectAtIndex:indexPath.row]!= nil) {
        
    
    if (self.enterTextField.text.length > 0) {
        [self.delegate getTitleFromDic:@{@"title":[self.tagArr objectAtIndex:indexPath.row]}];
        
    }
    }
}
@end
