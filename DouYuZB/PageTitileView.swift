
//
//  PageTitileView.swift
//  DouYuZB
//
//  Created by zuokai on 2017/6/1.
//  Copyright © 2017年 zuokai. All rights reserved.
//

import UIKit
 //MARK:- 协议
protocol PageTitileViewDelegate: class {
    func pageTitileView(titleView: PageTitileView, selectedIndex index: Int)
}
 //MARK:- 定义常量
private let kNormalColor: (CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectedColor: (CGFloat,CGFloat,CGFloat) = (255,128,0)

private let KScrollerLineH: CGFloat = 2
 //MARK:- 定义类
class PageTitileView: UIView {
    
    //MARK:- 定义属性
    fileprivate var currentIndex :Int = 0
    fileprivate var titles: [String]
    weak var delegate: PageTitileViewDelegate?
     //MARK:- 懒加载数组
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
     //MARK:- 懒加载
      fileprivate lazy var scrollView : UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = false
        scrollView.bounces = false
        return scrollView
    }()
     //MARK:- 懒加载下滑线
    fileprivate lazy var scrollLine: UIView = {
       let scollLine = UIView()
       scollLine.backgroundColor = UIColor.orange
       return scollLine
    }()
     //MARK:- 自定义一个构造函数
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        // 设置ui界面
        setupUI()
    }
    // 必须重写这个构造函数
    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
}
 //MARK:- 设置ui界面
extension PageTitileView {
    fileprivate func setupUI () {
        //1. 添加uiscrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        //2. 添加title对应的label
        setupTitleLabel()
        
        //3.设置滚动条
        setupBottomLineAndScrollViewLine()
    }
    
    private func setupTitleLabel() {
         //MARK:- label的一些frame的值
        // 设置farem
        let labelW: CGFloat = frame.width / CGFloat(titles.count)
        let labelH: CGFloat = frame.height - KScrollerLineH
        let labelY: CGFloat = 0
        for (index , title) in titles.enumerated() {
             //MARK:- 创建label
            let label = UILabel()
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            let labelX: CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            titleLabels.append(label)
            scrollView.addSubview(label)
            // 添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClicked(tapGes:)))
            label .addGestureRecognizer(tapGes)
        }
    }
    
    private func setupBottomLineAndScrollViewLine() {
        // 添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH: CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        // 添加scollLine
        //获取第一个label
       guard let firstLabel:UILabel = titleLabels.first else {
            return
        }
        firstLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: frame.origin.x, y: frame.height - KScrollerLineH, width: firstLabel.frame.width, height: KScrollerLineH)
    }
    
}
 //MARK:- 监听label的点击
extension PageTitileView {
    @objc fileprivate func titleLabelClicked(tapGes: UITapGestureRecognizer) {
       // 获取当前label
        guard let currentLabel = tapGes.view as? UILabel   else {return}
        currentLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
       // 获取之前的label
        let oldLabel = titleLabels[currentIndex]
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        //保存最新的label下标
        currentIndex = currentLabel.tag
        // 切换文字的颜色
        //滚动条位置发生改变
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {[weak self] in
            self?.scrollLine.frame.origin.x = scrollLineX
        }
        // 通知代理
        delegate?.pageTitileView(titleView: self, selectedIndex: currentIndex)
    }
}
 //MARK:- 对外暴露方法
extension PageTitileView {
    func setTitleWithProgress(pageContentView: PageContentView,progress: CGFloat, sourceIndex: Int, targetIndex: Int ) {
       // 1.取出source对应的label和targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 处理滑块
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        // 颜色的渐变
        // 取出变化的范围
        let colorDeta = (kSelectedColor.0 - kNormalColor.0,kSelectedColor.1 - kNormalColor.1, kSelectedColor.2 - kNormalColor.2)
        // 变化的sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectedColor.0 - colorDeta.0 * progress, g: kSelectedColor.1 - colorDeta.1 * progress, b: kSelectedColor.2 - colorDeta.2 * progress)
        // 变化的targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDeta.0 * progress, g: kNormalColor.1 + colorDeta.1 * progress, b: kNormalColor.2 + colorDeta.2 * progress)
        // 记录最新的index
        currentIndex = targetIndex
    }
}

