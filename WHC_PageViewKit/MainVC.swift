//
//  ViewController.swift
//  WHC_PageViewKit
//
//  Created by WHC on 16/11/11.
//  Copyright © 2016年 WHC. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    var currentView: UIView!
    let vcs = [StyleOneVC(nibName: "StyleOneVC", bundle: nil),StyleTwoVC(nibName: "StyleTwoVC", bundle: nil)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.edgesForExtendedLayout = []
        currentView = vcs.first!.view
        self.view.addSubview(currentView)
        self.navigationItem.title = "样式一"
        currentView.whc_Left(0)
                    .whc_Top(0)
                    .whc_Right(0)
                    .whc_Bottom(50)
        
        let bottomBar = WHC_TitlesBar()
        self.view.addSubview(bottomBar)
        bottomBar.whc_Left(0)
                .whc_Right(0)
                .whc_Bottom(0)
                .whc_Height(50)
        
        
        var images = [UIImage]()
        var selectedImages = [UIImage]()
        
        images.append(UIImage(named: "home_uncheck")!)
        images.append(UIImage(named: "calendar_uncheck")!)
        images.append(UIImage(named: "news_1_uncheck")!)
        images.append(UIImage(named: "my_uncheck")!)
        
        selectedImages.append(UIImage(named: "home_check")!)
        selectedImages.append(UIImage(named: "calendar_check")!)
        selectedImages.append(UIImage(named: "news_1_check")!)
        selectedImages.append(UIImage(named: "my_check")!)
        
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
        layoutParam.selectedTextColor = UIColor(red: 252 / 255.0, green: 54 / 255.0, blue: 29 / 255.0, alpha: 1)
        layoutParam.itemTextImageMargin = 3
        layoutParam.defaultSelectIndex = 0
        layoutParam.itemImageSize = CGSize(width: 25, height: 25)
        layoutParam.itemLayoutStyle = .image_Top_Text_Bottom
        bottomBar.layoutIfNeeded()
        bottomBar.layoutParam = layoutParam
        
        /// 设置点击回调
        bottomBar.clickButtonCallback = {(index: Int) in
            switch index {
            case 0:
                self.navigationItem.title = "样式"
                if self.currentView !== self.vcs.first!.view {
                    self.currentView.whc_ResetConstraints().removeFromSuperview()
                    self.currentView = self.vcs.first!.view
                    self.view.addSubview(self.currentView)
                    self.currentView.whc_AutoSize(left: 0, top: 0, right: 0, bottom: 50)
                }
            case 1:
                self.navigationItem.title = "样式二"
                if self.currentView !== self.vcs[1].view {
                    self.currentView.whc_ResetConstraints().removeFromSuperview()
                    self.currentView = self.vcs[1].view
                    self.view.addSubview(self.currentView)
                    self.currentView.whc_AutoSize(left: 0, top: 0, right: 0, bottom: 50)
                }
            default:
                UIAlertView(title: "WHC", message: "暂未开放", delegate: nil, cancelButtonTitle: "OK").show()
            }
            self.view.bringSubview(toFront: bottomBar)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

