//
//  ViewController.swift
//  StretchyHeader-Swift
//
//  Created by shihao on 2017/8/30.
//  Copyright © 2017年 shihao. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{

    // MARK: - properties
    
    @IBOutlet weak var tableView: UITableView!
  
    var headerView : UIView!
    
    var entries = [
        Animals(animal:"🐥"),
        Animals(animal:"🐶"),
        Animals(animal:"🐱"),
        Animals(animal:"🐭"),
        Animals(animal:"🐹"),
        Animals(animal:"🐰"),
        Animals(animal:"🦊"),
        Animals(animal:"🐻"),
        Animals(animal:"🐼"),
        Animals(animal:"🐨"),
    ]
    
    
    let tableHeaderHeight : CGFloat = 350.0
    
    // MARK: - Life circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.hidesBarsOnSwipe =  true
        
        tableView?.delegate = self
        tableView?.dataSource = self
    
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        
        // 添加到tableview （根据自身frame）控件上
        tableView.addSubview(headerView)
    }
    
    override func viewDidLayoutSubviews() {
        // 内边距：内容从哪里开始 tip（重点）:会加到内容的上面
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 0, right: 0)
        // 内容偏移量：
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight)
          updateFrame()
    }

    // MARK: - <UITableViewDataSource>
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID" ,for:indexPath)
        cell.textLabel?.text = entries[indexPath.row].animal
        return cell
    }
    
    // MARK: - <UIScrollViewDelegate>
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        updateFrame()
    }
    
    // MARK: - convince
    
    func updateFrame() {
        
        // tips：需要把 图片的contentmode 设置为 aspectfill 才会有效果
        var headerRect = CGRect(x: 0, y: -tableHeaderHeight, width: tableView.bounds.width, height: tableHeaderHeight)
        if tableView.contentOffset.y < -tableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        
        headerView.frame = headerRect
    }
    
}

