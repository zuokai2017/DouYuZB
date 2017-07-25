//
//  PageContentView.swift
//  DouYuZB
//
//  Created by zuokai on 2017/6/2.
//  Copyright © 2017年 zuokai. All rights reserved.
//

import UIKit
protocol  PageContentViewDelegate: class{
    func pageContentView(pageContentView: PageContentView,progress: CGFloat, sourceIndex: Int, targetIndex: Int )
}
private let ContentCellID = "ContentCellID"

class PageContentView: UIView {
    
    //MARK:- 自定义属性
    fileprivate var childVcs: [UIViewController]
    fileprivate weak var parentViewController: UIViewController?
    weak var delegate: PageContentViewDelegate?
    fileprivate var startOffsetX: CGFloat = 0
    fileprivate var isForbidscrollDalegate: Bool = false
     //MARK:- 懒加载UICollectionView
    fileprivate lazy var  collectionView: UICollectionView = {[weak self] in
        //创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        // 注册cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        return collectionView
    }()
     //MARK:- 自定义构造函数
    init(frame: CGRect,childVcs:[UIViewController], parentViewController: UIViewController?) {
        
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        
        super.init(frame: frame)
        
        // 设置ui
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

 //MARK:- 设置ui界面
extension PageContentView {
    fileprivate func setupUI() {
         //MARK:- 将所有子控制器加入父控制器中
        for childVc in childVcs {
parentViewController?.addChildViewController(childVc)
        }
        // 添加uicollectionView，用于cell中存放控制器器的View
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}
 //MARK:- 遵守UICollectionDataSource协议
extension PageContentView:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        // cell内容
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}
 //MARK:- 遵循uiolletionViewDelegate
extension PageContentView: UICollectionViewDelegate {
    // scrollView开始拖动
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidscrollDalegate = false
       startOffsetX = scrollView.contentOffset.x
    }
    // scrollView的滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 判断是否是点击事件
        if isForbidscrollDalegate {
            return
        }
        // 获取所需的数据
        //1.滚动的进度progreess
        var progress : CGFloat = 0
        //2.原来的index的label的颜色渐变
        var sourceIndex: Int = 0
        //3.目标的index的label颜色渐变
        var targetIndex: Int = 0
        //判断左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX {
            //左滑
            //计算 progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            // 计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            // 如果完全划过去了
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1;
                targetIndex = sourceIndex
            }
        }else {
            //右滑
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            // 计算sourceIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
        }
        // 将progress 、sourceIndex、targetIndex、传给titleView
        delegate?.pageContentView(pageContentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    
}
 //MARK:- 对外暴露的方法
extension PageContentView {
    func setCureentIndex(cureentIndex: Int) -> Void {
        // 记录需要执行代理方法
        isForbidscrollDalegate = true
        let offsetX = CGFloat(cureentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: false)
    }
}

