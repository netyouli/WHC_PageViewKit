//
//  ContentView.swift
//  WHC_PageViewKit
//
//  Created by WHC on 16/11/11.
//  Copyright © 2016年 WHC. All rights reserved.
//

import UIKit

class ContentView: UIView , UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    private let image: UIImage = UIImage(named: "cell")!
    private let kCellName = "WHCCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(tableView)
        tableView.whc_AutoSize(left: 0, top: 0, right: 0, bottom: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK - tableview代理 -
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: kCellName)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: kCellName)
            let imageView = UIImageView(image: image)
            cell?.contentView.addSubview(imageView)
            imageView.whc_Left(0)
            .whc_Right(0)
            .whc_Top(0)
            .whc_Height(self.whc_sw * (image.size.height / image.size.width))
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.whc_sw * (image.size.height / image.size.width)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
}
