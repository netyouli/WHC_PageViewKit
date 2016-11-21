//
//  HZPageView.swift
//  Htinns
//
//  Created by WHC on 16/8/24.
//  Copyright © 2016年 hangting. All rights reserved.
//
//  Github <https://github.com/netyouli/WHC_PageViewKit>

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

// VERSION:(1.0.1)

import UIKit

class WHC_PageViewLayoutParam: WHC_TitlesBarLayoutParam {
    /// 标题栏高度
    var titleBarHeight: CGFloat = 44.0
    /// 是否能够动态改变字体大小
    var canChangeFont = true
    /// 是否能够动态改变文字颜色
    var canChangeTextColor = true
    /// 是否能够动态改变背景颜色
    var canChangeBackColor = true
}

/// WHC_PageView视图代理
@objc protocol WHC_PageViewDelegate {
    /**
     说明:开始加载视图
     @return 返回要加载的视图集合
     */
    @objc optional func whcPageViewStartLoadingViews() -> [UIView]!
    /**
     说明:更新视图
     @param pageView 当前页视图
     @param view 将要更新的视图
     @param index 将要更新视图的下表索引
     */
    @objc optional func whcPageView(pageView: WHC_PageView, willUpdateView view: UIView, index: Int)
}

class WHC_PageView: UIView, UIScrollViewDelegate {

    private var scrollView: UIScrollView!
    private var titleBar: WHC_TitlesBar!
    private var views: [UIView]!
    private var currentPageIndex = 0
    private var isGotoClick = false
    private var isBigSwitch = false
    private var isClickSwitch = false
    private var replaceTag1 = 0
    private var replaceTag2 = 0
    /// 设置布局参数
    var layoutParam: WHC_PageViewLayoutParam! {
        didSet {
            if delegate != nil {
                startLayout(paramObject: layoutParam)
            }
        }
    }
    
    /// 设置代理
    weak var delegate: WHC_PageViewDelegate! {
        didSet {
            if layoutParam != nil {
                startLayout(paramObject: layoutParam)
            }
        }
    }
    
    /// 高度差
    var heightDiff: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, layoutParam: WHC_PageViewLayoutParam) {
        self.init(frame: frame)
        self.layoutParam = layoutParam
        startLayout(paramObject: layoutParam)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func startLayout(paramObject: WHC_PageViewLayoutParam) {
        titleBar?.removeFromSuperview()
        scrollView?.removeFromSuperview()
        titleBar = nil
        scrollView = nil
        self.layoutIfNeeded()
        titleBar = WHC_TitlesBar(frame: CGRect(x: 0, y: 0, width: self.whc_Width, height: layoutParam.titleBarHeight), layoutParam: paramObject)
        titleBar.clickButtonCallback = {[unowned self] (index: Int) -> Void in
            self.isClickSwitch = true
            if !self.isGotoClick {
                self.handleTitleItemClick(animation: true, index: index)
            }
            self.isGotoClick = false
        }
        self.addSubview(titleBar)
        scrollView = UIScrollView(frame: CGRect(x: 0,y: titleBar.whc_MaxY,width: min(self.whc_Width, self.whc_ScreenWidth),height: self.whc_Height - titleBar.whc_MaxY - heightDiff))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        self.addSubview(scrollView)
        
        views = delegate?.whcPageViewStartLoadingViews?()
        let viewWidth = scrollView.whc_Width
        let viewHeight = scrollView.whc_Height
        if views != nil {
            for (index, view) in views.enumerated() {
                view.tag = index + 1
                view.whc_Width = viewWidth
                view.whc_Xy = CGPoint(x: CGFloat(index) * viewWidth , y: 0)
                view.whc_Height = viewHeight
                scrollView.addSubview(view)
            }
            scrollView.contentSize = CGSize(width: viewWidth * CGFloat(views.count), height: 0)
            if views != nil  && views.count > 0 {
                delegate?.whcPageView?(pageView: self, willUpdateView: views.first!, index: 0)
            }
        }
    }
    
    
    private func handleTitleItemClick(animation: Bool, index: Int) {
        isBigSwitch = true
        let replaceViewPosition = {(symbol: Int) -> Void in
            let pageIndex = self.currentPageIndex + symbol
            let currentView = self.scrollView.viewWithTag(pageIndex + 1)
            let replaceView = self.scrollView.viewWithTag(index + 1)
            let currentViewX = currentView!.whc_X
            self.replaceTag1 = currentView!.tag
            self.replaceTag2 = replaceView!.tag
            currentView?.whc_X = (replaceView?.whc_X)!
            replaceView?.whc_X = currentViewX
            self.scrollView.setContentOffset(CGPoint(x: CGFloat(self.currentPageIndex + symbol) * self.whc_Width, y: 0), animated: animation)
        }
        if index > currentPageIndex + 1 {
            replaceViewPosition(1)
        }else if index < currentPageIndex - 1 {
            replaceViewPosition(-1)
        }else {
            isBigSwitch = false
            let scrollWidth = CGFloat(index) * scrollView.whc_Width
            scrollView.setContentOffset(CGPoint(x: scrollWidth, y: 0), animated: animation)
        }
        titleBar.resetItemState(currentIndex: index, oldIndex: currentPageIndex)
        currentPageIndex = index
    }
    
    private func handleScrollStop() {
        let pageIndex = Int(floor((scrollView.contentOffset.x - scrollView.whc_Width / 2.0) / scrollView.whc_Width)) + 1
        if pageIndex != currentPageIndex {
            delegate?.whcPageView?(pageView: self, willUpdateView: views[pageIndex], index: pageIndex)
        }
        currentPageIndex = pageIndex
        handleTitleItemClick(animation: true, index: pageIndex)
        titleBar.dynamicDidEndChange(contentOffsetX: scrollView.contentOffset.x,pageIndex: currentPageIndex)
    }
    
    //MARK: - UIScrollViewDelegate -

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isClickSwitch = false
        currentPageIndex = Int(floor((scrollView.contentOffset.x - scrollView.whc_Width / 2.0) / scrollView.whc_Width)) + 1
        let draggingPoint = scrollView.panGestureRecognizer.velocity(in: scrollView)
        titleBar.dynamicBeginChange(offsetX: scrollView.contentOffset.x, draggingX: draggingPoint.x)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isClickSwitch {
            let draggingPoint = scrollView.panGestureRecognizer.velocity(in: scrollView)
            titleBar.dynamicChangeWithScrollViewContentOffsetX(contentOffsetX: scrollView.contentOffset.x, draggingX: draggingPoint.x,changeFont: layoutParam.canChangeFont, changeTextColor: layoutParam.canChangeTextColor, changeBackColor: layoutParam.canChangeBackColor)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.handleScrollStop()
        }else {
            let draggingPoint = scrollView.panGestureRecognizer.velocity(in: scrollView)
            titleBar.dynamicWillEndChange(contentOffsetX: scrollView.contentOffset.x, draggingX: draggingPoint.x)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.handleScrollStop()
    }

    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if isBigSwitch && replaceTag1 > 0 && replaceTag2 > 0 {
            let replaceView1 = self.scrollView.viewWithTag(replaceTag1)
            let replaceView2 = self.scrollView.viewWithTag(replaceTag2)
            let replaceView1X = replaceView1!.whc_X
            replaceView1?.whc_X = (replaceView2?.whc_X)!
            replaceView2?.whc_X = replaceView1X
            scrollView.setContentOffset(CGPoint(x: CGFloat(currentPageIndex) * self.whc_Width, y: 0), animated: false)
        }
        isClickSwitch = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: DispatchTime.now().rawValue + dispatch_time_t(0.05))) {
            self.delegate?.whcPageView?(pageView: self, willUpdateView: self.views[self.currentPageIndex], index: self.currentPageIndex)
        }
        
    }
}
