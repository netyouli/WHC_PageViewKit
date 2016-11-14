//
//  HZTitlesBar.swift
//  Htinns
//
//  Created by WHC on 16/8/24.
//  Copyright © 2016年 hangting. All rights reserved.
//

import UIKit

class ButtonTopRightMarkView: UIView {}

class WHC_TitlesBarLayoutParam: NSObject {
    static let kNotCursorCorner: CGFloat = -1
    static let kItemAutoWidth: CGFloat = -1
    static let kNotCreateLine: CGFloat = -1
    static let kNotDefaultSelect: Int = -1
    
    /// item标题数组
    var titles: [String]!
    /// item标题富文本数组
    var attributeTitles: [NSAttributedString]!
    /// item图片数组
    var images: [UIImage]!
    /// item选中图片数组
    var selectedImages: [UIImage]!
    /// 统一item布局类型
    var itemLayoutStyle: UIButtonLayoutStyle = .Text
    /// 指定每个item布局类型
    var itemsLayoutStyle: [UIButtonLayoutStyle]!
    /// 图片的size
    var itemImageSize = CGSize.zero
    /// 文字和图片直接间隙
    var itemTextImageMargin: CGFloat = 0
    /// 高亮文字集合
    var highlightTexts: [String]!
    /// 高亮文字的颜色
    var highlightTextColor = UIColor.black
    /// item选中文字颜色
    var selectedTextColor = UIColor.black
    /// item正常文字颜色
    var normalTextColor = UIColor.black
    /// item选中字体
    var selectedFont = UIFont.boldSystemFont(ofSize: 20)
    /// item正常字体
    var normalFont = UIFont.boldSystemFont(ofSize: 16)
    /// item选中背景颜色
    var selectedBackgorundColor = UIColor.white
    /// item正常背景颜色
    var normalBackgorundColor = UIColor.white
    /// 顶部线颜色
    var topLineColor = UIColor(white: 0.8, alpha: 1.0)
    /// 底部线颜色
    var bottomLineColor = UIColor(white: 0.8, alpha: 1.0)
    /// 中间线颜色
    var middleLineColor = UIColor(white: 0.8, alpha: 1.0)
    /// 背景颜色
    var backgroundColor = UIColor.white
    /// bar顶部有线
    var topLineHeight: CGFloat = kNotCreateLine
    /// bar底部有线
    var bottomLineHeight: CGFloat = 0.5
    /// bar中间有线
    var middleLineWidth: CGFloat = kNotCreateLine
    /// bar中间线边距
    var middleLineMargin: CGFloat = 5
    
    /// 游标动画周期
    var cursorAnimationDuring: TimeInterval = 0.2
    
    /// bar顶部是否有游标
    var hasTopCursor = false
    /// bar底部是否有游标
    var hasBottomCursor = true
    
    /// bar游标高度
    var cursorHeight: CGFloat = 4
    /// bar游标左右边距
    var cursorMargin: CGFloat = 10
    /// bar游标颜色
    var cursorColor = UIColor.orange
    /// bar游标圆角
    var cursorCorner: CGFloat = kNotCursorCorner
    /// item自定义宽度
    var itemWidth: CGFloat = kItemAutoWidth
    /// 默认选中下标
    var defaultSelectIndex: Int = 0
}

class WHC_TitlesBar: UIView {

    private var scrollView: UIScrollView!
    private var topCursorView: UIView!
    private var bottomCursorView: UIView!
    private var buttons = [UIButton]()
    private var currentSelectedButton: UIButton!
    private var currentCursorX: CGFloat = 0.0
    private var backView: UIView!
    private var currentButtonIndex = -1
    private var itemWidth: CGFloat = 0.0
    /// 设置点击回调
    var clickButtonCallback: ((Int)->Void)!
    /// 设置布局参数
    var layoutParam: WHC_TitlesBarLayoutParam! {
        didSet {
           startLayout(paramObject: layoutParam)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(UIView())
    }
    
    convenience init(frame: CGRect, layoutParam: WHC_TitlesBarLayoutParam) {
        self.init(frame: frame)
        self.layoutParam = layoutParam
        startLayout(paramObject: layoutParam)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func startLayout(paramObject: WHC_TitlesBarLayoutParam) {
        buttons.removeAll()
        topCursorView?.removeFromSuperview()
        bottomCursorView?.removeFromSuperview()
        scrollView?.removeFromSuperview()
        backView?.removeFromSuperview()
        topCursorView = nil
        bottomCursorView = nil
        scrollView = nil
        scrollView = UIScrollView(frame: CGRect(x: bounds.minX, y: bounds.minY, width: min(self.whc_ScreenWidth, bounds.width), height: bounds.height))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
        backView = UIView(frame: bounds)
        scrollView.addSubview(backView)
        self.backgroundColor = layoutParam.backgroundColor
        backView.backgroundColor = layoutParam.backgroundColor
        if layoutParam.titles != nil {
            let selfWidth = bounds.width
            let selfHeight = bounds.height
            let titleCount = layoutParam.titles.count
            var itemHeight: CGFloat = 0
            var topLineHeight: CGFloat = 0
            var bottomLineHeight: CGFloat = 0
            if layoutParam.itemWidth == WHC_TitlesBarLayoutParam.kItemAutoWidth {
                var sumLineWidth: CGFloat = 0
                if layoutParam.middleLineWidth != WHC_TitlesBarLayoutParam.kNotCreateLine {
                    sumLineWidth = CGFloat(titleCount - 1) * layoutParam.middleLineWidth
                }
                itemWidth = (selfWidth - sumLineWidth) / CGFloat(titleCount)
            }else {
                itemWidth = layoutParam.itemWidth
            }
            backView.whc_Width = itemWidth * CGFloat(titleCount)
            scrollView.contentSize = CGSize(width: backView.whc_Width, height: 0)
            if layoutParam.bottomLineHeight != WHC_TitlesBarLayoutParam.kNotCreateLine {
                bottomLineHeight = layoutParam.bottomLineHeight
                let lineView = UIView(frame: CGRect(x: 0,y: selfHeight - layoutParam.bottomLineHeight,width: backView.whc_Width,height: layoutParam.bottomLineHeight))
                lineView.backgroundColor = layoutParam.bottomLineColor
                self.addSubview(lineView)
            }
            if layoutParam.topLineHeight != WHC_TitlesBarLayoutParam.kNotCreateLine {
                topLineHeight = layoutParam.topLineHeight
                let lineView = UIView(frame: CGRect(x: 0,y: 0,width: backView.whc_Width,height: layoutParam.topLineHeight))
                lineView.backgroundColor = layoutParam.topLineColor
                self.addSubview(lineView)
            }
            itemHeight = selfHeight - (topLineHeight + bottomLineHeight)
            
            let middleLineWidth: CGFloat = (layoutParam.middleLineWidth != WHC_TitlesBarLayoutParam.kNotCreateLine) ? layoutParam.middleLineWidth : 0
            let buttonY = max(layoutParam.topLineHeight, 0)
            for (index, title) in layoutParam.titles.enumerated() {
                let button = UIButton(type: .custom)
                button.tag = index
                button.frame = CGRect(x: CGFloat(index) * itemWidth + CGFloat(index) * middleLineWidth, y: buttonY, width: itemWidth, height: itemHeight)
                button.setTitle(title, for: .normal)
                if layoutParam.attributeTitles != nil &&
                    layoutParam.attributeTitles.count > index {
                    button.setAttributedTitle(layoutParam.attributeTitles[index], for: .normal)
                }
                button.setTitleColor(layoutParam.normalTextColor, for: .normal)
                if layoutParam.images != nil {
                    if index < (layoutParam.images?.count)! {
                        button.setImage(layoutParam.images[index], for: .normal)
                    }
                }
                if layoutParam.defaultSelectIndex == WHC_TitlesBarLayoutParam.kNotDefaultSelect {
                    if index == 0 {
                        button.backgroundColor = layoutParam.selectedBackgorundColor
                    }else {
                         button.backgroundColor = layoutParam.normalBackgorundColor
                    }
                }
                button.titleLabel?.font = layoutParam.normalFont
                button.titleLabel?.numberOfLines = 0
                button.contentVerticalAlignment = .center
                button.titleLabel?.textAlignment = .center
                button.addTarget(self, action: #selector(clickButton(sender:)), for: .touchUpInside)
                checkHasHighlightText(title: title, button: button)
                if layoutParam.itemsLayoutStyle != nil &&
                    index < (layoutParam.itemsLayoutStyle?.count)! {
                    button.layoutStyle = layoutParam.itemsLayoutStyle[index]
                }else {
                    button.layoutStyle = layoutParam.itemLayoutStyle
                }
                button.textImageMargin = layoutParam.itemTextImageMargin
                button.imageSize = layoutParam.itemImageSize
                buttons.append(button)
                backView.addSubview(button)
                if middleLineWidth > 0 && index < titleCount - 1 {
                    let middleLineView = UIView(frame: CGRect(x: button.whc_MaxX, y: layoutParam.middleLineMargin, width: middleLineWidth, height: selfHeight - 2 * layoutParam.middleLineMargin))
                    middleLineView.backgroundColor = layoutParam.middleLineColor
                    backView.addSubview(middleLineView)
                }
            }
            if layoutParam.hasTopCursor {
                topCursorView = UIView(frame: CGRect(x: layoutParam.cursorMargin, y: 0, width: itemWidth - 2 * layoutParam.cursorMargin, height: layoutParam.cursorHeight))
                topCursorView.backgroundColor = layoutParam.cursorColor
                if layoutParam.cursorCorner != WHC_TitlesBarLayoutParam.kNotCursorCorner {
                    topCursorView.layer.cornerRadius = layoutParam.cursorCorner
                }
                backView.addSubview(topCursorView)
            }
            
            if layoutParam.hasBottomCursor {
                bottomCursorView = UIView(frame: CGRect(x: layoutParam.cursorMargin, y: selfHeight - layoutParam.cursorHeight, width: itemWidth - 2 * layoutParam.cursorMargin, height: layoutParam.cursorHeight))
                bottomCursorView.backgroundColor = layoutParam.cursorColor
                if layoutParam.cursorCorner != WHC_TitlesBarLayoutParam.kNotCursorCorner {
                    bottomCursorView.layer.cornerRadius = layoutParam.cursorCorner
                }
                backView.addSubview(bottomCursorView)
            }
            gotoClickButton(index: layoutParam.defaultSelectIndex)
        }else {
            print("标题数组不能为空")
        }
    }
    
    private func checkHasHighlightText(title: String, button: UIButton) -> Void {
        if layoutParam.highlightTexts != nil {
            for text in layoutParam.highlightTexts {
                if title.contains(text) {
                    let attrTitle = NSMutableAttributedString(string: title)
                    attrTitle.addAttribute(NSForegroundColorAttributeName, value: layoutParam.highlightTextColor, range: NSMakeRange(title.characters.count - text.characters.count, text.characters.count))
                    button.setAttributedTitle(attrTitle, for: .normal)
                    button.setAttributedTitle(attrTitle, for: .selected)
                    break
                }
            }
        }
    }
    
    /// 取消当前选中的
    func cancelCurrentSelected() {
        currentSelectedButton?.backgroundColor = layoutParam.normalBackgorundColor
        currentSelectedButton?.titleLabel?.font = layoutParam.normalFont
        currentSelectedButton?.setTitleColor(layoutParam.normalTextColor, for: .normal)
        if layoutParam.selectedImages != nil && currentButtonIndex < layoutParam.selectedImages.count {
            currentSelectedButton.setImage(layoutParam.selectedImages[currentButtonIndex], for: .normal)
        }
    }
    
    func resetItemState(currentIndex: Int, oldIndex: Int) -> Void {
        if currentIndex >= 0 && currentIndex < buttons.count {
            currentSelectedButton = buttons[currentIndex]
            currentSelectedButton.backgroundColor = layoutParam.selectedBackgorundColor
            currentSelectedButton.titleLabel?.font = layoutParam.selectedFont
            currentSelectedButton.setTitleColor(layoutParam.selectedTextColor, for: .normal)
            if layoutParam.selectedImages != nil && currentIndex < layoutParam.selectedImages.count {
                currentSelectedButton.setImage(layoutParam.selectedImages[currentIndex], for: .normal)
            }
            for (i,button) in buttons.enumerated() {
                if i != currentIndex {
                    button.setTitleColor(layoutParam.normalTextColor, for: .normal)
                    button.backgroundColor = layoutParam.normalBackgorundColor
                    button.titleLabel?.font = layoutParam.normalFont
                    button.setTitleColor(layoutParam.normalTextColor, for: .normal)
                    if layoutParam.images != nil && i < layoutParam.images.count {
                        button.setImage(layoutParam.images[i], for: .normal)
                    }
                }
            }
            currentButtonIndex = currentIndex
        }
    }
    
    @objc private func clickButton(sender: UIButton!) {
        var index = (sender == nil ? -1 : sender.tag)
        if index == currentButtonIndex {return}
        if currentButtonIndex == -1 {
            currentButtonIndex = index
        }
        currentSelectedButton?.backgroundColor = layoutParam.normalBackgorundColor
        currentSelectedButton?.titleLabel?.font = layoutParam.normalFont
        currentSelectedButton?.setTitleColor(layoutParam.normalTextColor, for: .normal)
        if layoutParam.images != nil && currentButtonIndex < layoutParam.images.count {
            currentSelectedButton?.setImage(layoutParam.images[currentButtonIndex], for: .normal)
        }
        
        currentButtonIndex = index
        sender?.backgroundColor = layoutParam.selectedBackgorundColor
        sender?.titleLabel?.font = layoutParam.selectedFont
        sender?.setTitleColor(layoutParam.selectedTextColor, for: .normal)
        if layoutParam.selectedImages != nil && index < layoutParam.selectedImages.count {
            sender.setImage(layoutParam.selectedImages[index], for: .normal)
        }
        currentSelectedButton = sender
        
        let startOffsetIndex = Int((scrollView.whc_Width / sender.whc_Width) / 2.0)
        if index < startOffsetIndex {
            index = startOffsetIndex
        }else if index == layoutParam.titles.count - 1 {
            index = layoutParam.titles.count - startOffsetIndex
        }
        var offsetX = CGFloat(index - startOffsetIndex) * sender.whc_Width
        let availableOffsetX = scrollView.contentSize.width - scrollView.whc_Width
        if offsetX > availableOffsetX {
            offsetX = availableOffsetX
        }else if offsetX < 0.0 {
            offsetX = 0.0
        }
        UIView.animate(withDuration: layoutParam.cursorAnimationDuring, animations: {
            self.topCursorView?.whc_X = sender.whc_MaxX - self.topCursorView.whc_Width - self.layoutParam.cursorMargin
            self.bottomCursorView?.whc_X = sender.whc_MaxX - self.bottomCursorView.whc_Width - self.layoutParam.cursorMargin
            self.scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
        }) { (finish) in
            if self.bottomCursorView != nil {
                self.currentCursorX = self.bottomCursorView.whc_X
            }
            if self.topCursorView != nil {
                self.currentCursorX = self.topCursorView.whc_X
            }
        }
        if currentButtonIndex > -1 {
            clickButtonCallback?(currentButtonIndex)
        }else {
            print("按钮下标异常不能为-1")
        }
    }
    
    func dynamicBeginChange(offsetX: CGFloat, draggingX: CGFloat) -> Void {
        let index = Int(offsetX / self.whc_Width) + 1
        var count = index - 1
        var whc = 0
        if draggingX < 0.0 {
            
        }else if draggingX > 0 {
            count = buttons.count
            whc = index
        }
        if whc < count {
            for i in whc ..< count {
                let button = buttons[i]
                button.setTitleColor(layoutParam.normalTextColor, for: .normal)
                button.backgroundColor = layoutParam.normalBackgorundColor
                button.titleLabel?.font = layoutParam.normalFont
            }
        }
    }
    
    func dynamicWillEndChange(contentOffsetX: CGFloat, draggingX: CGFloat) -> Void {
        let index = Int(contentOffsetX / self.whc_Width)
        let count = buttons.count
        let nextIndex = index + 1
        for i in 0 ..< count {
            if i != index && i != nextIndex {
                let button = buttons[i]
                button.setTitleColor(layoutParam.normalTextColor, for: .normal)
                button.backgroundColor = layoutParam.normalBackgorundColor
                button.titleLabel?.font = layoutParam.normalFont
            }
        }
    }
    
    func dynamicDidEndChange(contentOffsetX: CGFloat,pageIndex: Int) -> Void {
        let tempItemWidth = (layoutParam.middleLineWidth != WHC_TitlesBarLayoutParam.kNotCreateLine ? layoutParam.middleLineWidth : 0) + itemWidth
        let startOffsetIndex = Int((scrollView.whc_Width / tempItemWidth) / 2.0)
        var localOffsetX = contentOffsetX * (tempItemWidth / scrollView.whc_Width) - CGFloat(tempItemWidth) * CGFloat(startOffsetIndex)
        if localOffsetX < 0 {
            localOffsetX = 0.0
        }else if (scrollView.contentSize.width - scrollView.whc_Width < localOffsetX){
            localOffsetX = scrollView.contentSize.width - scrollView.whc_Width
        }
        scrollView.setContentOffset(CGPoint(x: localOffsetX, y: 0), animated: true)
    }
    
    func dynamicChangeWithScrollViewContentOffsetX(contentOffsetX: CGFloat, draggingX: CGFloat,changeFont: Bool, changeTextColor: Bool, changeBackColor: Bool) -> Void {
        var n_t_r: CGFloat = 0, n_t_g: CGFloat = 0, n_t_b: CGFloat = 0, n_t_a: CGFloat = 0
        var s_t_r: CGFloat = 0, s_t_g: CGFloat = 0, s_t_b: CGFloat = 0, s_t_a: CGFloat = 0
        if changeTextColor {
            layoutParam.normalTextColor.getRed(&n_t_r, green: &n_t_g, blue: &n_t_b, alpha: &n_t_a)
            layoutParam.selectedTextColor.getRed(&s_t_r, green: &s_t_g, blue: &s_t_b, alpha: &s_t_a)
        }
        
        var n_b_r: CGFloat = 0, n_b_g: CGFloat = 0, n_b_b: CGFloat = 0, n_b_a: CGFloat = 0
        var s_b_r: CGFloat = 0, s_b_g: CGFloat = 0, s_b_b: CGFloat = 0, s_b_a: CGFloat = 0
        if changeBackColor {
            layoutParam.normalBackgorundColor.getRed(&n_b_r, green: &n_b_g, blue: &n_b_b, alpha: &n_b_a)
            layoutParam.selectedBackgorundColor.getRed(&s_b_r, green: &s_b_g, blue: &s_b_b, alpha: &s_b_a)
        }
        
        let tempItemWidth = (layoutParam.middleLineWidth != WHC_TitlesBarLayoutParam.kNotCreateLine ? layoutParam.middleLineWidth : 0) + itemWidth
        let cursorMoveOffsetX = contentOffsetX * (tempItemWidth / self.whc_Width)
        if layoutParam.hasTopCursor {
            topCursorView.whc_X = cursorMoveOffsetX + layoutParam.cursorMargin
        }
        if layoutParam.hasBottomCursor {
            bottomCursorView.whc_X = cursorMoveOffsetX + layoutParam.cursorMargin
        }
        
        var pageIndex = Int(contentOffsetX / self.whc_Width) + 1
        let currentButton = buttons[pageIndex - 1]
        let rightSwitch = draggingX < 0
        var percent = fabs((cursorMoveOffsetX - tempItemWidth * CGFloat(pageIndex - 1)) / tempItemWidth)
        if rightSwitch && Int(contentOffsetX) % Int(self.whc_Width) == 0 {
            percent = 1
            if pageIndex > 1 {
                pageIndex -= 1;
            }
        }
        if changeTextColor {
            let text_color = UIColor(red: n_t_r * percent + s_t_r * (1 - percent),
                                     green: n_t_g * percent + s_t_g * (1 - percent),
                                     blue: n_t_b * percent + s_t_b * (1 - percent),
                                     alpha: n_t_a)
            currentButton.setTitleColor(text_color, for: .normal)
        }
        if changeBackColor {
            let back_color = UIColor(red: n_b_r * percent + s_b_r * (1 - percent),
                                     green: n_b_g * percent + s_b_g * (1 - percent),
                                     blue: n_b_b * percent + s_b_b * (1 - percent),
                                     alpha: n_b_a)
            currentButton.backgroundColor = back_color
        }

        if changeFont {
            if layoutParam.selectedFont.fontName.contains("Regular") {
                currentButton.titleLabel?.font = UIFont.systemFont(ofSize: layoutParam.selectedFont.pointSize * (1 - percent) + layoutParam.normalFont.pointSize * percent)
            }else {
                currentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: layoutParam.selectedFont.pointSize * (1 - percent) + layoutParam.normalFont.pointSize * percent)
            }
        }
        if pageIndex <= 1 && contentOffsetX < 0 {
            let nextButton = buttons[pageIndex]
            nextButton.backgroundColor = layoutParam.normalBackgorundColor
            nextButton.setTitleColor(layoutParam.normalTextColor, for: .normal)
            return
        }
        
        if pageIndex < buttons.count && pageIndex >= 0 {
            let nextButton = buttons[pageIndex]
            if nextButton != currentButton {
                if changeBackColor {
                    nextButton.backgroundColor = UIColor(red: s_b_r * percent + n_b_r * (1 - percent),
                                                     green: s_b_g * percent + n_b_g * (1 - percent),
                                                     blue: s_b_b * percent + n_b_b * (1 - percent),
                                                     alpha: s_b_a)
                }
                if changeTextColor {
                    nextButton.setTitleColor(UIColor(red: s_t_r * percent + n_t_r * (1 - percent),
                                                 green: s_t_g * percent + n_t_g * (1 - percent),
                                                 blue: s_t_b * percent + n_t_b * (1 - percent),
                                                 alpha: s_t_a), for: .normal)
                }
                if changeFont {
                    if layoutParam.normalFont.fontName.contains("Regular") {
                        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: layoutParam.normalFont.pointSize * (1 - percent) + layoutParam.selectedFont.pointSize * percent)
                    }else {
                        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: layoutParam.normalFont.pointSize * (1 - percent) + layoutParam.selectedFont.pointSize * percent)
                    }
                }
            }
        }
    }
    
    /// 跳转点击按钮
    func gotoClickButton(index: Int) -> Void {
        if index != WHC_PageViewLayoutParam.kNotDefaultSelect {
            if index < buttons.count {
                clickButton(sender: buttons[index])
            }
        }else {
            if buttons.count > 0 {
                currentSelectedButton = buttons.first
            }
        }
    }
    
    /// 设置右上角标记
    func setTopRightMark(index: Int, x: CGFloat, color: UIColor, size: CGSize) -> Void {
        let button = buttons[index]
        let margin: CGFloat = 5
        var markView: ButtonTopRightMarkView!
        for view in button.subviews {
            if view is ButtonTopRightMarkView {
                markView = view as! ButtonTopRightMarkView
                markView.removeFromSuperview()
                break
            }
        }
        if markView == nil {
            markView = ButtonTopRightMarkView()
            markView.layer.cornerRadius = size.width / 2
            markView.clipsToBounds = true
        }
        markView.backgroundColor = color
        button.addSubview(markView)
        markView.whc_Y = margin
        markView.whc_X = x
        markView.whc_Size = size
    }
    
    /// 移除右上角标记
    func removeTopRightMark(index: Int) {
        let button = buttons[index]
        for view in button.subviews {
            if view is ButtonTopRightMarkView {
                view.removeFromSuperview()
                break
            }
        }
    }
}
