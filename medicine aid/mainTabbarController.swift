//
//  mainTabbarController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/5/11.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit

class mainTabbarController: TabBarViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        setupSubViews()
    }
    
    
    func setupSubViews() -> Void {
        
        let firstVC = homeViewController()
        let secondVC = searchingMedicineViewController()
        let thirdVC = personalViewController()
        /**
         *  添加tabbar的主控制器
         *  @param firstVC                                 子控制器
         *  @param "first"                                 标题
         *  @param "first"                                 普通状态的图片
         *  @param "first_select"                          选中状态的图片
         *  @param TabbarHideStyle.TabbarHideWithAnimation 当push到下一界面tabbar的隐藏方式
         */
        self.setupChildVC(firstVC, title: "选择", imageName: "select_bt", selectImageName: "select_bt")
        self.setupChildVC(secondVC, title: "百科", imageName: "search_bt", selectImageName: "search_bt")
        self.setupChildVC(thirdVC, title: "个人", imageName: "personage_bt", selectImageName: "personage_bt")
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
