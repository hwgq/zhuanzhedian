//
//  CollectPersonTableViewCell.m
//  zhuanzhedian
//
//  Created by Gaara on 15/10/23.
//  Copyright © 2015年 Gaara. All rights reserved.
//

#import "CollectPersonTableViewCell.h"
#import "UIColor+AddColor.h"
#import "FontTool.h"
@interface CollectPersonTableViewCell ()
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *lookLabel;
@property (nonatomic, strong)UILabel *likeLabel;
@property (nonatomic, strong)UIImageView *lookImage;
@property (nonatomic, strong)UIImageView *likeImage;

@end
@implementation CollectPersonTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView
{
    UIImageView *nextImage = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 20, 29, 7, 12)];
    nextImage.image = [UIImage imageNamed:@"Cell_Next.png"];
    [self.contentView addSubview:nextImage];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 21, [UIScreen mainScreen].bounds.size.width / 2, 25)];
    self.nameLabel.font = [[FontTool customFontArrayWithSize:16]objectAtIndex:1];
//    self.nameLabel.backgroundColor = [UIColor purpleColor];
    self.nameLabel.textColor = [UIColor colorFromHexCode:@"#666666"];
    [self.contentView addSubview:self.nameLabel];
    
    
//    self.lookImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 46, 17, 13)];
////    lookImage.backgroundColor = [UIColor blueColor];
//    
//    _lookImage.image = [UIImage imageNamed:@"Group Copy.png"];
//    [self.contentView addSubview:_lookImage];
//    
//    self.lookLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 45, 60, 15)];
////    self.lookLabel.backgroundColor = [UIColor blueColor];
//    self.lookLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
//    self.lookLabel.textColor = [UIColor lightGrayColor];
//    [self.contentView addSubview:self.lookLabel];
//    
//    self.likeImage = [[UIImageView alloc]initWithFrame:CGRectMake(105, 46, 14, 13)];
//    _likeImage.image = [UIImage imageNamed:@"Fill 1 Copy 6.png"];
////    likeImage.backgroundColor = [UIColor blueColor];
//    [self.contentView addSubview:_likeImage];
//    
//    self.likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 45, 60, 15)];
//    self.likeLabel.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
//    self.likeLabel.textColor = [UIColor lightGrayColor];
//    
////    self.likeLabel.backgroundColor = [UIColor blueColor];
//    [self.contentView addSubview:self.likeLabel];
    
    
    
    
}
- (void)awakeFromNib {
    // Initialization code
}
- (void)getValueDic:(NSDictionary *)dic
{
    
    if ([[dic objectForKey:@"state"]isEqualToString:@"0"]) {
        self.nameLabel.textColor= [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1];
//        self.lookImage.image = [UIImage imageNamed:@"yanjing.png"];
//        self.likeImage.image = [UIImage imageNamed:@"aixin.png"];
        [self.label removeFromSuperview];
        self.label  = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 110, 25, 70, 20)];
        _label.backgroundColor = [UIColor colorFromHexCode:@"#dddddd"];
        _label.layer.cornerRadius = 7;
        _label.textAlignment = 1;
        _label.textColor = [UIColor whiteColor];
        _label.text = @"已隐藏";
        _label.font = [[FontTool customFontArrayWithSize:14]objectAtIndex:1];
        _label.layer.masksToBounds = YES;
        [self.contentView addSubview:_label];
        
    }else{
        [self.label removeFromSuperview];
//        self.lookImage.image = [UIImage imageNamed:@"ico-100.png"];
//        self.likeImage.image = [UIImage imageNamed:@"ico-111.png"];
        self.nameLabel.textColor = [UIColor grayColor];
        
        
    }
    
    self.nameLabel.text = [dic objectForKey:@"title"];
    self.lookLabel.text = [dic objectForKey:@"browser_num"];
    self.likeLabel.text = [dic objectForKey:@"favorite_num"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
