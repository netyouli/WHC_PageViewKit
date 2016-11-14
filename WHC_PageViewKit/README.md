WHC_PageViewKit
==============
![Build Status](https://api.travis-ci.org/netyouli/WHC_PageViewKit.svg?branch=master)
[![Pod Version](http://img.shields.io/cocoapods/v/WHC_PageViewKit.svg?style=flat)](http://cocoadocs.org/docsets/WHC_PageViewKit/)
[![Pod Platform](http://img.shields.io/cocoapods/p/WHC_PageViewKit.svg?style=flat)](http://cocoadocs.org/docsets/WHC_PageViewKit/)
[![Pod License](http://img.shields.io/cocoapods/l/WHC_PageViewKit.svg?style=flat)](https://opensource.org/licenses/MIT)
简介
==============
- **高效**: 预加载机制
- **方便**: 只需要设置简单参数即可构建炫酷的TitleBar和PageView
- **动画**: 支持翻页TitleBar炫酷动画效果
- **优势**: TitleBar模块和PageView模块可以单独使用
- **强大**: TitleBar支持30多种UI样式
- **咨询**: 712641411
- **作者**: 吴海超

集成
==============
* 使用CocoaPods:
-  pod 'WHC_PageViewKit', '~> 1.0.4'
* 手工集成:
-  导入文件夹WHC_PageViewKit

使用演示
==============
<img src = "https://github.com/netyouli/WHC_PageViewKit/blob/master/gif/pageView.gif" width = "375"><img src = "https://github.com/netyouli/WHC_PageViewKit/blob/master/gif/note.png" width = "375">
<img src = "https://github.com/netyouli/WHC_PageViewKit/blob/master/gif/a.png" width = "375"><img src = "https://github.com/netyouli/WHC_PageViewKit/blob/master/gif/b.png" width = "375">

要求
==============
* iOS 8.0 or later
* Xcode 8.0 or later

用法
==============
*  创建PageView
```Swift
override func viewDidLoad() {
    super.viewDidLoad()
    let pageView = WHC_PageView()
    pageView.delegate = self
    self.view.addSubview(pageView)
    pageView.whc_Left(0)
    .whc_Top(0)
    .whc_Right(0)
    .whc_Bottom(0)

    let layoutParam = WHC_PageViewLayoutParam()
    layoutParam.titles = ["新闻","外汇","黄金","原油","白银","股票","现货"]
    layoutParam.itemWidth = 80 /***如果标题很多一屏放不下需要设定每个标题的固定宽度否则可以忽略***/
    layoutParam.selectedTextColor = UIColor.orange
    layoutParam.normalBackgorundColor = UIColor.white
    layoutParam.normalTextColor = UIColor.black
    layoutParam.selectedBackgorundColor = UIColor.gary

    pageView.layoutIfNeeded()
    pageView.layoutParam = layoutParam
}

//MARK: - WHC_PageViewDelegate -
func whcPageViewStartLoadingViews() -> [UIView]! {
    return views
}

func whcPageView(pageView: WHC_PageView, willUpdateView view: UIView, index: Int) {
    print("更新当前视图")
}

```

* 单独创建TitleBar
```Swift 
override func viewDidLoad() {
    super.viewDidLoad()
    let bottomBar = WHC_TitlesBar()
    self.view.addSubview(bottomBar)
    bottomBar.whc_Left(0)
    .whc_Right(0)
    .whc_BaseLine(0)
    .whc_Height(50)

    /// 设置底部bar的样式
    let layoutParam = WHC_TitlesBarLayoutParam()
    layoutParam.titles = ["样式","样式二","Android","iOS"]
    layoutParam.images = images
    layoutParam.selectedImages = selectedImages
    layoutParam.bottomLineHeight = WHC_TitlesBarLayoutParam.kNotCreateLine
    layoutParam.hasBottomCursor = false
    layoutParam.topLineHeight = 0.5
    layoutParam.normalFont = UIFont.systemFont(ofSize: 10)
    layoutParam.selectedFont = UIFont.systemFont(ofSize: 10)
    layoutParam.selectedTextColor = UIColor.gray
    layoutParam.itemTextImageMargin = 3
    layoutParam.defaultSelectIndex = 0
    layoutParam.itemImageSize = CGSize(width: 25, height: 25)
    layoutParam.itemLayoutStyle = .Image_Top_Text_Bottom
    bottomBar.layoutIfNeeded()
    bottomBar.layoutParam = layoutParam

    /// 设置点击回调
    bottomBar.clickButtonCallback = {(index: Int) in

    }
}
```

## <a id="期待"></a>期待

- 如果您在使用过程中有任何问题，欢迎issue me! 很乐意为您解答任何相关问题!
- 与其给我点star，不如向我狠狠地抛来一个BUG！
- 如果您想要更多的接口来自定义或者建议/意见，欢迎issue me！我会根据大家的需求提供更多的接口！

## Licenses
All source code is licensed under the MIT License.
