//
//  StyleTwoVC.swift
//  WHC_PageViewKit
//
//  Created by WHC on 16/11/13.
//  Copyright © 2016年 WHC. All rights reserved.
//

import UIKit

class StyleTwoVC: UIViewController,WHC_PageViewDelegate {

    let views = [ContentView(),ContentView(),ContentView(),ContentView(),ContentView(),ContentView(),ContentView()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let pageView = WHC_PageView()
        pageView.delegate = self
        self.view.addSubview(pageView)
        pageView.whc_Left(0)
            .whc_Top(0)
            .whc_Right(0)
            .whc_Bottom(0)
        
        let layoutParam = WHC_PageViewLayoutParam()
        layoutParam.titles = ["原油","白银","股票","现货"]
//        layoutParam.itemWidth = 80   /// 由于只有四个标题一屏幕放得下所以该参数可以忽略
        layoutParam.selectedTextColor = UIColor.orange
        layoutParam.normalBackgorundColor = UIColor.white
        layoutParam.normalTextColor = UIColor.black
        layoutParam.selectedBackgorundColor = UIColor(red: 252 / 255.0, green: 240 / 255.0, blue: 220 / 255.0, alpha: 1.0)
        
        pageView.layoutIfNeeded()
        pageView.layoutParam = layoutParam
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
