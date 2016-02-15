# XXImageBrowserTool
一个用简单的方式实现的UIImageView的分类,让以UIImageView为容器展示的任何图片都可以简单实现全屏放大缩小保存等功能.

用分类的方式实现可以更方便的调用.

####效果图:

![](https://github.com/coderlinxx/XXImageBrowserTool/blob/master/imageDemo.gif)

####集成方法:

只需要在创建UIImageView时调用分类方法:
```Objective-C
[header setImageBrowseAndSaveEnabled:YES];
或者
[cell.imageView setImageBrowseEnabled:YES];
```
详见 demo.
