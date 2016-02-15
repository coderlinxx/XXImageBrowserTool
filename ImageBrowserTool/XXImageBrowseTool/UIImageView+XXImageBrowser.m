//
//  UIImageView+XXImageBrowser.m
//  ImageBrowserTool
//
//  Created by 林祥兴 on 16/2/15.
//  Copyright © 2016年 pogo.inxx. All rights reserved.
//

#import "UIImageView+XXImageBrowser.h"

#define SCREEN_Width ([[UIScreen mainScreen] bounds].size.width)

@implementation UIImageView (XXImageBrowser)

static CGFloat  lastScaleFactor = 1;         //缩放
static CGPoint netTranslation;                  //平衡

- (void)setImageBrowseEnabled:(BOOL)isYes{
    if (!isYes) {
        NSLog(@"未开启图片放大功能");
        return;
    }else{
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(smallImageClick:)];
        [self addGestureRecognizer:tap];
    }
}

- (void)setImageBrowseAndSaveEnabled:(BOOL) isYes{
    if (!isYes) {
        return;
    }else{
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(smallImageWithSaveClick:)];
        [self addGestureRecognizer:tap];
    }
}

/** 生成主UIImageView图片容器 */
-(UIImageView *)kWindowImageV{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect rect = [self convertRect:self.bounds toView: window];
    UIView *background = [[UIView alloc] initWithFrame:window.frame];
    background.alpha = 0.0;
    background.backgroundColor = [UIColor clearColor];
    [window addSubview:background];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:rect];
    imageV.userInteractionEnabled = YES;
    [imageV setImage:self.image];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    imageV.clipsToBounds = YES;
    imageV.alpha = 0.1;
    imageV.backgroundColor = [UIColor clearColor];
    [background addSubview:imageV];
    
    //1. 单击手势
    UITapGestureRecognizer *tapBig = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigImageClick:)];
    //2. 手势为捏的姿势:按住option按钮配合鼠标来做这个动作在虚拟器上
    UIPinchGestureRecognizer *pinchGesture=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinchGesture:)];
    //3. 拖动手势
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [imageV addGestureRecognizer:pinchGesture];
    [imageV addGestureRecognizer:tapBig];
    [imageV addGestureRecognizer:panGesture];
    return imageV;
}

/** 普通小图放大(不带保存功能) */
-(void)smallImageClick:(UITapGestureRecognizer *)tap{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIImageView *kWindowImageV = [self kWindowImageV];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.75f initialSpringVelocity:3.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        kWindowImageV.frame = window.frame;
        kWindowImageV.alpha = 1;
        kWindowImageV.superview.alpha = 1;
        kWindowImageV.backgroundColor = [UIColor blackColor];
        kWindowImageV.superview.backgroundColor = [UIColor blackColor];
    } completion:^(BOOL finished) {
        if (finished) {
//            NSLog(@"%s success",__FUNCTION__);
        }
    }];
}

/** 带保存功能的小图放大 */
-(void)smallImageWithSaveClick:(UITapGestureRecognizer *)tap{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIImageView *kWindowImageV = [self kWindowImageV];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.75f initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        kWindowImageV.frame = window.frame;
        kWindowImageV.alpha = 1;
        kWindowImageV.superview.alpha = 1;
        kWindowImageV.backgroundColor = [UIColor blackColor];
        kWindowImageV.superview.backgroundColor = [UIColor blackColor];
    } completion:^(BOOL finished) {
        
        if (finished) {
            CGRect rect = CGRectMake(60, 40, 30, 30);
            UIButton *btn = [[UIButton alloc] initWithFrame:rect];
            btn.alpha = 0.1;
            [kWindowImageV.superview addSubview:btn];
            [btn setImage:[UIImage imageNamed:@"home_save"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
            
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                btn.frame = CGRectMake(SCREEN_Width - 60, 40, 30, 30);
                btn.alpha = 1.0;
            } completion:^(BOOL finished) {
                if (finished) {
//                    NSLog(@"%s success",__func__);
                }
            }];
        }
    }];
    
}


- (void)saveImage:(UIButton *)btn{
    
    __block UIImageView *kWindowImageV;
    
    [btn.superview.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            kWindowImageV = (UIImageView *)obj;
        }
    }];
    
//    [SVProgressHUD showWithStatus:@"保存中..." maskType:SVProgressHUDMaskTypeGradient];
    UIImageWriteToSavedPhotosAlbum(kWindowImageV.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(id)contextInfo{
    if(error != NULL){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"save photo fail" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"save photo fail");
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"save photo success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"save photo success");
    }
}


-(void)bigImageClick:(UITapGestureRecognizer *)tap{
    
    UIImageView *kWindowImageV =  (UIImageView *)[tap view];
    [UIView animateWithDuration:0.5 animations:^{
        
        //当前视图相对于屏幕原点的位置
        CGRect rect = [self convertRect:self.bounds toView:nil];
        kWindowImageV.frame = rect;
        kWindowImageV.alpha = 0.0;
        kWindowImageV.superview.alpha = 0.0;
        kWindowImageV.superview.backgroundColor = [UIColor clearColor];
        kWindowImageV.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [kWindowImageV.superview removeFromSuperview];
        [kWindowImageV removeFromSuperview];
    }];
    
}

-(void)handlePinchGesture:(UIPinchGestureRecognizer *)sender{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat factor=[(UIPinchGestureRecognizer*)sender scale];
    if(factor > 1){
        //图片放大
        [UIView animateWithDuration:0.5 animations:^{
            sender.view.frame = CGRectMake(window.frame.origin.x - window.frame.size.width/2, window.frame.origin.y - window.frame.size.height/2, window.frame.size.width*2, window.frame.size.height*2);
        }];
    }else if(factor < 1){
        if (sender.view.frame.origin.x < 0) {
            //缩小
            [UIView animateWithDuration:0.5 animations:^{
                sender.view.frame = window.frame;
            }];
        }else{ }
    }
    
    if(sender.state==UIGestureRecognizerStateEnded){
        if(factor>1){
            lastScaleFactor += (factor-1);
        }else{
            lastScaleFactor *= factor;
        }
    }
    
}

-(void)handlePanGesture:(UIGestureRecognizer*)sender{
    if (sender.view.frame.origin.x != 0) { //未放大时不允许拖动
        CGPoint translation=[(UIPanGestureRecognizer*)sender translationInView:sender.view];
        sender.view.transform=CGAffineTransformMakeTranslation(netTranslation.x+translation.x, netTranslation.y+translation.y);
        if(sender.state==UIGestureRecognizerStateEnded){
            netTranslation.x+=translation.x;
            netTranslation.y+=translation.y;
        }
    }
}

@end
