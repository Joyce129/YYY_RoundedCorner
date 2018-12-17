//
//  ViewController.m
//  RoundCorner
//
//  Created by Jean on 2018/12/17.
//  Copyright © 2018年 北京易盟天地信息技术股份有限公司. All rights reserved.
//

#import "ViewController.h"

// UILabel -> UIView -> UIResponder -> NSObject
// UIButton -> UIControl -> UIView -> UIResponder -> NSObject

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"iOS开发高效设置圆角";
    [self test1];
    
    [self test2];
    
    [self test3];
    
    [self test4];
    
    [self test5];
    
    [self test6];
    
    [self test7];
    
    [self test8];
}

#pragma mark 方法1：设置按钮UILabel部分圆角
- (void)test1
{
    UILabel * myLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 160, 150 , 50)];
    myLabel1.font = [UIFont systemFontOfSize:14];
    myLabel1.text = @"UILabel设置圆角";
    myLabel1.textAlignment = NSTextAlignmentCenter;
    myLabel1.textColor = [UIColor blueColor];
    [self.view addSubview:myLabel1];
    
    myLabel1.layer.cornerRadius = 15;
    myLabel1.layer.borderWidth = 1;
    myLabel1.layer.borderColor = [UIColor redColor].CGColor;
    //关键点
    myLabel1.layer.backgroundColor = [UIColor greenColor].CGColor;
}

#pragma mark 方法2：设置按钮UILabel部分圆角
- (void)test2
{
    UILabel * myLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(180, 160, 150 , 50)];
    myLabel2.font = [UIFont systemFontOfSize:14];
    myLabel2.text = @"UILabel设置圆角";
    myLabel2.backgroundColor = [UIColor brownColor];
    myLabel2.textAlignment = NSTextAlignmentCenter;
    myLabel2.textColor = [UIColor whiteColor];
    [self.view addSubview:myLabel2];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:myLabel2.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = myLabel2.bounds;
    maskLayer.path = maskPath.CGPath;
    myLabel2.layer.mask  = maskLayer;
}

#pragma mark 设置按钮UIButton部分圆角
- (void)test3
{
    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.frame = CGRectMake(20, 240, 150, 50);
    tempBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [tempBtn setTitle:@"UIButton设置圆角" forState:UIControlStateNormal];
    [tempBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tempBtn.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:tempBtn];
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:tempBtn.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = tempBtn.bounds;
    maskLayer1.path = maskPath1.CGPath;
    tempBtn.layer.mask  = maskLayer1;
}

/*************************设置图片圆角*************************/
/*
 UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale) 各参数含义:
 size：新创建的位图上下文的大小
 opaque：透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
 scale：缩放因子 iPhone 4是2.0，其他是1.0。虽然这里可以用[UIScreen mainScreen].scale来获取，但实际上设为0后，系统就会自动设置正确的比例
 
 */
#pragma mark 通过设置layer的属性，设置图片圆角
//maskToBounds会触发离屏渲染(offscreen rendering)，GPU在当前屏幕缓冲区外新开辟一个渲染缓冲区进行工作，也就是离屏渲染，这会带来额外的性能损耗，如果这样的圆角操作达到一定数量，会触发缓冲区的频繁合并和上下文的的频繁切换，性能的代价会宏观地表现在用户体验上<掉帧>不建议使用.
- (void)test4
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"头像"]];
    imageView.frame = CGRectMake(20, 330, 100, 100);
    //只需要设置layer层的两个属性
    //设置圆角
    imageView.layer.cornerRadius = 50;
    //将多余的部分切掉
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
}

#pragma mark 使用贝塞尔曲线UIBezierPath和Core Graphics框架画出一个圆角，设置图片圆角
- (void)test5
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(160, 330, 100, 100)];
    imageView.image = [UIImage imageNamed:@"素材1"];
    [self.view addSubview:imageView];
    
    //开始对imageView进行画图
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    
    //使用贝塞尔曲线画出一个圆形图
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:imageView.frame.size.width] addClip];
    [imageView drawRect:imageView.bounds];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    //结束画图
    UIGraphicsEndImageContext();
}

#pragma mark 使用Core Graphics框架画出一个圆角，设置图片圆角
- (void)test6
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 460, 100, 100)];
    imageView.image = [UIImage imageNamed:@"素材2"];
    [self.view addSubview:imageView];
    
    //开始对imageView进行画图
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    
    //获得图形上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    //设置一个范围
    CGRect rect = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
    //根据一个rect创建一个椭圆
    CGContextAddEllipseInRect(ref, rect);
    //裁剪
    CGContextClip(ref);
    //将原照片画到图形上下文
    [imageView.image drawInRect:rect];
    
    //从上下文上获取剪裁后的照片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    imageView.image = newImage;
}

#pragma mark 使用CAShapeLayer和UIBezierPath设置圆角，设置图片圆角
- (void)test7
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(160, 460, 100, 100)];
    imageView.image = [UIImage imageNamed:@"素材3"];
    [self.view addSubview:imageView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView.bounds.size];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = imageView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    imageView.layer.mask = maskLayer;
}

#pragma mark 指定需要成为圆角的角
- (void)test8
{
    //设置视图位置和大小
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(20, 600, 140, 50)];
    //设置背景颜色
    myView.backgroundColor = [UIColor redColor];
    //添加到跟视图
    [self.view addSubview:myView];
    
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:myView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(25, 25)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = myView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    myView.layer.mask = maskLayer;
    
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:myView.bounds];
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.font = [UIFont systemFontOfSize:14];
    //添加文字
    tempLabel.text = @"UIView设置圆角";
    //文字颜色
    tempLabel.textColor = [UIColor whiteColor];
    [myView addSubview: tempLabel];
}



@end
