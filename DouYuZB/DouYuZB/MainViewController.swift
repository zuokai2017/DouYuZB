//
//  MainViewController.swift
//  DouYuZB
//
//  Created by zuokai on 2017/6/1.
//  Copyright © 2017年 zuokai. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVc(stroryName: "Home");
        addChildVc(stroryName: "Live");
        addChildVc(stroryName: "Follow");
        addChildVc(stroryName: "Profile");
    
    }
    
    private func addChildVc(stroryName: String) {
        // 通过storyboard获取就控制器
        let childVc = UIStoryboard(name: stroryName, bundle: nil).instantiateInitialViewController()!;
        // 将childVc添加主控制器中
        addChildViewController(childVc);
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
