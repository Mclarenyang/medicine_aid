//
//  tabBarViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/5/11.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController,TabBarDelegate{
    
    weak var customTabBar = TabBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabbar()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for child in self.tabBar.subviews {
            if child.isKind(of: UIControl.self) {
                child.removeFromSuperview()
            }
        }
    }
    
    func setupTabbar() -> Void {
        /// 生成
        let customTabBar = TabBar.init(frame: self.tabBar.bounds)
        customTabBar.tabbarDelegate = self
        self.tabBar.addSubview(customTabBar)
        self.customTabBar = customTabBar
    }
    
    //    MARK:TabBarDelegate
    func tabbar(_ tabbar: TabBar, formWhichItem: Int, toWhichItem: Int) {
        self.selectedIndex = toWhichItem
    }
    
    func setupChildVC(_ childVC: UIViewController,title: String,imageName: String,selectImageName: String){
        
        childVC.title = title
        childVC.tabBarItem.image = UIImage.init(named: imageName)
        // 不再渲染图片
        childVC.tabBarItem.selectedImage = UIImage.init(named: selectImageName)?.withRenderingMode(.alwaysOriginal)
        
        let navigationCtrl = UINavigationController(rootViewController: childVC)
        self.addChildViewController(navigationCtrl)
        
        // 添加tabbar内部按钮
        self.customTabBar!.addTabbarButtonWith(childVC.tabBarItem)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
