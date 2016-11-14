//
//  StyleOneVC.swift
//  WHC_PageViewKit
//
//  Created by WHC on 16/11/13.
//  Copyright © 2016年 WHC. All rights reserved.
//

import UIKit

class StyleOneVC: UIViewController,WHC_PageViewDelegate {

    let views = [ContentView(),ContentView(),ContentView(),ContentView(),ContentView(),ContentView(),ContentView()]
    private let layoutParam = WHC_PageViewLayoutParam()
    private let pageView = WHC_PageView()
    private var didLoadPageView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pageView.delegate = self
        self.view.addSubview(pageView)
        pageView.whc_Left(0)
                .whc_Top(0)
                .whc_Right(0)
                .whc_Bottom(0)
        
        layoutParam.titles = ["新闻","外汇","黄金","原油","白银","股票","现货"]
        layoutParam.itemWidth = 80 /***如果标题很多一屏放不下需要设定每个标题的固定宽度否则可以忽略***/
        layoutParam.selectedTextColor = UIColor.orange
        layoutParam.normalBackgorundColor = UIColor.white
        layoutParam.normalTextColor = UIColor.black
        layoutParam.selectedBackgorundColor = UIColor(red: 252 / 255.0, green: 240 / 255.0, blue: 220 / 255.0, alpha: 1.0)
        
        /******在使用自动布局的情况布局会有延迟所以在AutoLayout环境加载pageview放到下面，如果是frame布局无需放到下面*****/
        
    }
    
    //// 加载pageView布局
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didLoadPageView {
            didLoadPageView = true
            pageView.layoutIfNeeded()
            pageView.layoutParam = layoutParam
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - WHC_PageViewDelegate -
    func whcPageViewStartLoadingViews() -> [UIView]! {
        return views
    }
    
    func whcPageView(pageView: WHC_PageView, willUpdateView view: UIView, index: Int) {
        print("更新当前视图")
    }

}
