//
//  UIImageView+XXImageBrowser.h
//  ImageBrowserTool
//
//  Created by 林祥兴 on 16/2/15.
//  Copyright © 2016年 pogo.inxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (XXImageBrowser)

/**
 *  图片是否可以全屏缩放
 *
 *  @param isYes <#isYes description#>
 */
- (void)setImageBrowseEnabled:(BOOL) isYes;

/**
 *  图片是否可以全屏缩放并且保存到系统相册
 *
 *  @param isYes <#isYes description#>
 */
- (void)setImageBrowseAndSaveEnabled:(BOOL) isYes;


@end
