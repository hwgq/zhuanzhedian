//
//  VWWWaterView.m
//  Water Waves
//
//  Created by Veari_mac02 on 14-5-23.
//  Copyright (c) 2014年 Veari. All rights reserved.
//

#import "VWWWaterView.h"
typedef enum kSliderTag{
    kHeight_Tag             = 11,
    kSpeed_Tag              = 12,
    kWave_Tag               = 13,
    kWaveIncrease_Tag       = 16,
    kWaveMin_Tag            = 17,
    kWaveMax_Tag            = 18,
    kWaveW_Tag              = 19,
    
}SliderTag;
#define showValueLableTag   10

#define waveDelta 0.01
@interface VWWWaterView ()
{
    UIColor *_currentWaterColor;
}

//公式中用到(起始相位)
@property (assign, nonatomic) float b;

@end


@implementation VWWWaterView


- (id)initWithFrame:(CGRect)frame color:(UIColor *)color
{
    //公式中用到(起始速度)
    self.b = 0;
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _currentWaterColor = color;
        
        [NSTimer scheduledTimerWithTimeInterval:0.01
                                         target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
    }
    return self;
}

-(void)animateWave
{
    if (self.jia == YES) {
        self.wave += self.waveIncrease;
        self.wave = (self.wave < self.waveMin ? self.waveMin : self.wave);
    }else{
        self.wave -= self.waveIncrease;
        self.wave = (self.wave > self.waveMax ? self.waveMax : self.wave);
    }
    
    
    if (self.wave <= self.waveMin) {
        self.jia = YES;
    }
    
    if (self.wave >= self.waveMax) {
        self.jia = NO;
    }
    
    
    self.b += self.waveSpeed;
    
    //该方法会重新调用drawRect方法
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    //画水
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [_currentWaterColor CGColor]);
    
    float y = self.waveHeight;
    CGPathMoveToPoint(path, NULL, 0, y);
    for(float x=0;x<=self.frame.size.width;x++){
        y= self.wave * sin( x/self.w*M_PI + 4 * self.b/M_PI ) * 5 + self.waveHeight;
        CGPathAddLineToPoint(path, nil, x, y);
    }

    //左上到右下颜色填充
    CGPathAddLineToPoint(path, nil, self.frame.size.width, rect.size.height);
    //右上到左下颜色填充
    CGPathAddLineToPoint(path, nil, 0, rect.size.height);
    //暂未发现有什么用
    CGPathAddLineToPoint(path, nil, 0, self.waveHeight);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
}


#pragma mark 重写方法
@synthesize wave = _wave;
- (void)setWave:(float)wave
{
    _wave = wave;
    
    [self upDateLabelFromTag:kWave_Tag value:wave];
}

@synthesize waveIncrease = _waveIncrease;
- (void)setWaveIncrease:(float)waveIncrease
{
    _waveIncrease = waveIncrease;
    [self upDateLabelFromTag:kWaveIncrease_Tag value:waveIncrease];
}

@synthesize waveMin = _waveMin;
- (void)setWaveMin:(float)waveMin
{
    _waveMin = waveMin;
    [self upDateLabelFromTag:kWaveMin_Tag value:waveMin];
}

@synthesize waveMax = _waveMax;
- (void)setWaveMax:(float)waveMax
{
    _waveMax = waveMax;
    [self upDateLabelFromTag:kWaveMax_Tag value:waveMax];
}

@synthesize waveSpeed = _waveSpeed;
- (void)setWaveSpeed:(float)waveSpeed
{
    _waveSpeed = waveSpeed;
    [self upDateLabelFromTag:kSpeed_Tag value:waveSpeed];
}

@synthesize waveHeight = _waveHeight;
- (void)setWaveHeight:(float)waveHeight
{
    _waveHeight = waveHeight;
    [self upDateLabelFromTag:kHeight_Tag value:waveHeight];
}

@synthesize w = _w;
- (void)setW:(float)w
{
    _w = w;
    [self upDateLabelFromTag:kWaveW_Tag value:w];
}


#pragma mark 更新显示的数据，slider的指示器
- (void)upDateLabelFromTag:(NSInteger)tag value:(CGFloat)value
{
    if (tag == 0) {
        return;
    }
    
    UIView *parentView = [[self superview] viewWithTag:tag];
    
    for (id tempView in parentView.subviews) {
        if ([tempView isKindOfClass:[UISlider class]]) {
            UISlider *tempSlider = (UISlider *)tempView;
            if (tempSlider.tag == tag) {
                //更新指示器的数值
                tempSlider.value = value;
                //更新显示的数据
                UILabel *tempLabel = (UILabel *)[parentView viewWithTag:showValueLableTag];
                tempLabel.text = [NSString stringWithFormat:@"%0.2f", value];
                [tempLabel sizeToFit];
            }
        }
    }
}

@end
