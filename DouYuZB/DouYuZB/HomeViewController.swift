//
//  HomeViewController.swift
//  DouYuZB
//
//  Created by zuokai on 2017/6/1.
//  Copyright © 2017年 zuokai. All rights reserved.
//

import UIKit
private let kTitleViewH: CGFloat = 40

class HomeViewController: UIViewController {
    
    //MARK:- 懒加载属性
    fileprivate lazy var pageTitleView : PageTitileView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: KNavigationBarH + KStatueBarH , width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitileView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
     //MARK:- 懒加载contentView
    fileprivate lazy var pageContentView: PageContentView = {[weak self] in
         //MARK:- 1内容的frame
        let contentH = kScreenH - KStatueBarH - KNavigationBarH - kTitleViewH
        let contentFrame = CGRect(x: 0, y: KStatueBarH + KNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)
         //MARK:- 确定所有子自控制器
        var childVcs = [UIViewController]()
        for _ in 0..<4 {
          let vc = UIViewController()
          vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(UInt32(255.0))), g: CGFloat(arc4random_uniform(UInt32(255.0))), b: CGFloat(arc4random_uniform(UInt32(255.0))))
            childVcs.append(vc)
        }
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        contentView.delegate = self
        return contentView
    }()
    
    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置ui界面
        setupUI()
    }
}

// 设置ui界面
extension HomeViewController {
    fileprivate func setupUI() {
        // 不需要设置uiscrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
         //MARK:- 设置导航栏
        setNavigationBar()
        // 添加titleView
        view.addSubview(pageTitleView)
        // 添加contentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.purple
    }
    private func setNavigationBar() {
        
        // 设置左侧放入item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        // 设置右侧的items
        let size = CGSize(width: 40, height: 40)
        
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size);

        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size);
        
        let qrcordeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)

        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcordeItem];
        
    }
}
 //MARK:- 遵守PageTitileViewDelegate协议
extension HomeViewController: PageTitileViewDelegate {
    func pageTitileView(titleView: PageTitileView, selectedIndex index: Int) {
       pageContentView.setCureentIndex(cureentIndex: index)
    }
}
 //MARK:- 遵守PageContentViewDelegate协议
extension HomeViewController: PageContentViewDelegate {
    func pageContentView(pageContentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
       pageTitleView.setTitleWithProgress(pageContentView: pageContentView, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

