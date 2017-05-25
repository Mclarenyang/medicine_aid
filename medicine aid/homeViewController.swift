//
//  homeViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/5/10.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit

class homeViewController: UIViewController,UIScrollViewDelegate {
    
    // 滚动页预设参数
    let SCROLL_WIDTH = UIScreen.main.bounds.width
    let SCROLL_HEIGHT = UIScreen.main.bounds.height/2
    
    var scrollView :UIScrollView?     //轮播图
    var pageC :UIPageControl?         //小点
    var timer :Timer?                 //定时器
    var scArray :NSMutableArray?      //图片数组

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        /// 设置状态栏颜色
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
        
        /// 导航栏显示
        self.navigationController?.navigationBar.isHidden = false
         //  隐藏返回按钮
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red:255/255,green:60/255,blue:40/255 ,alpha:1)
        self.navigationItem.title = "选择"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        /// 设置底部导航背景色
        //self.tabBarController?.tabBar.barTintColor = UIColor(red:255/255,green:60/255,blue:40/255 ,alpha:1)
        
        /// 创建按钮
        let prescribeBtn = UIButton(frame: CGRect(x:SCROLL_WIDTH*2/7-75,y:SCROLL_HEIGHT+SCROLL_HEIGHT*1/7,width:150,height:220))
        prescribeBtn.setBackgroundImage(UIImage(named:"prescribe_bt"), for: UIControlState.normal)
        prescribeBtn.addTarget(self, action: #selector(prescribeBtnTap(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(prescribeBtn)
        
        let treatBtn = UIButton(frame: CGRect(x:SCROLL_WIDTH*5/7-75,y:SCROLL_HEIGHT+SCROLL_HEIGHT*1/7,width:150,height:220))
        treatBtn.setBackgroundImage(UIImage(named:"treat_bt"), for: UIControlState.normal)
        self.view.addSubview(treatBtn)
        
        /// 创建滚动视图
        // 图片数组
        scArray = ["scroll_image_2","scroll_image_1","scroll_image_4","scroll_image_5","scroll_image_3"]
        
        // 初始化轮播图
        scrollView = UIScrollView.init(frame: CGRect(x:0,y:64, width:SCROLL_WIDTH, height:SCROLL_HEIGHT*4/5))
        // ScrollView背景颜色
        scrollView?.backgroundColor = UIColor.white
        // ScrollView滚动量
        scrollView?.contentSize = CGSize(width:SCROLL_WIDTH * CGFloat((scArray?.count)!), height:0)
        // ScrollView偏移量
        scrollView?.contentOffset = CGPoint(x:SCROLL_WIDTH, y:0)
        // 是否按页滚动
        scrollView?.isPagingEnabled = true
        // 是否显示水平滑条
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.showsVerticalScrollIndicator = false
        // 协议
        scrollView?.delegate = self
        self.view.addSubview(scrollView!)
        
        // 遍历图片数组
        for i in 0  ..< (scArray?.count)!  {
            
            let str :String = (scArray?.object(at: i))! as! String
            let img = UIImage(named: str)
            //初始化imageView
            let imgV :UIImageView = UIImageView()
            //添加图片
            imgV.image = img
            imgV.backgroundColor = UIColor.white
            //设置图片位置及大小
            imgV.frame = CGRect(x:(CGFloat(i) * SCROLL_WIDTH),y:0, width:SCROLL_WIDTH, height:SCROLL_HEIGHT*4/5)
            scrollView?.addSubview(imgV)
            //轻拍手势
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapImageV(tap:)))
            imgV.tag = 1000 + i
            //打开用户交互
            imgV.isUserInteractionEnabled = true
            //给图片添加轻拍手势
            imgV.addGestureRecognizer(tap)
            
        }
        
        //设置小点的位置大小
        pageC = UIPageControl.init(frame: CGRect(x:(SCROLL_WIDTH - 200) / 2, y:SCROLL_HEIGHT - 50, width:200, height:50))
        //设置小点背景色
        pageC?.backgroundColor = UIColor.clear
        //设置小点个数
        pageC?.numberOfPages = (scArray?.count)! - 2
        //设置小点当前页码颜色
        pageC?.currentPageIndicatorTintColor = UIColor.white
        //设置小点未选中页码颜色
        pageC?.pageIndicatorTintColor = UIColor.gray
        //设置当前选中页
        pageC?.currentPage = 0
        self.view.addSubview(pageC!)
        
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(change(timer:)), userInfo: nil, repeats: true)

        /// 创建云朵图案
        let cloudImage = UIImageView(frame:CGRect(x:0,y:SCROLL_HEIGHT-SCROLL_HEIGHT*2/11,width:SCROLL_WIDTH,height:100))
        cloudImage.image = UIImage(named:"Redcloud")
        self.view.addSubview(cloudImage)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //循环滚动方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //如果图片在第一张的位置
        if scrollView.contentOffset.x == 0 {
            //就变到倒数第二张的位置上
            scrollView.scrollRectToVisible(CGRect(x:scrollView.contentSize.width - 2 * SCROLL_WIDTH,y:0,width:SCROLL_WIDTH,height:SCROLL_HEIGHT), animated: false)
            //如果图片是倒数第一张的位置
        } else if scrollView.contentOffset.x == scrollView.contentSize.width - SCROLL_WIDTH {
            //就变到第二张的位置
            scrollView .scrollRectToVisible(CGRect(x:SCROLL_WIDTH, y:0, width:SCROLL_WIDTH, height:SCROLL_HEIGHT), animated: false)
        }
        
        pageC?.currentPage = Int(scrollView.contentOffset.x / SCROLL_WIDTH) - 1
        
    }
    
    //定时器执行方法
    func change(timer :Timer) {
        
        if pageC?.currentPage == (pageC?.numberOfPages)! - 1 {
            pageC?.currentPage = 0
        } else if (pageC?.currentPage)! < (pageC?.numberOfPages)! - 1 {
            pageC?.currentPage  = (pageC?.currentPage)! + 1
        }
        scrollView?.setContentOffset(CGPoint(x:(CGFloat(pageC!.currentPage + 1)) * SCROLL_WIDTH, y:0), animated: false)
    }
    
    //开启定时器
    func addTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(change(timer:)), userInfo: nil, repeats: true)
    }
    
    //关闭定时器
    func removeTimer() {
        timer?.invalidate()
    }
    
    //开始拖拽时调用
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //关闭定时器
        removeTimer()
    }
    
    //拖拽结束后调用
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //开启定时器
        addTimer()
    }
    
    //轻拍事件
    func tapImageV(tap :UITapGestureRecognizer) {
        
        print((tap.view?.tag)! - 1001)
        
    }
    
    // 按键响应事件
    // 跳转事件
    func prescribeBtnTap(_ button:UIButton){
        
        /// push界面
        let queueView = queueViewController()
        // 隐藏tabbar
        queueView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(queueView, animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
