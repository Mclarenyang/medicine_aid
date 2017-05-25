//
//  tabBar.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/5/11.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit

protocol TabBarDelegate {
    func tabbar(_ tabbar: TabBar,formWhichItem: Int, toWhichItem: Int)
}

class TabBar: UIView {
    
    // 生成一个可变的数组储存
    var tabBarButtons: NSMutableArray = []
    var selectedButton = tabBarButton()
    
    var tabbarDelegate: TabBarDelegate! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        /// 设置tabbar的颜色
        self.backgroundColor = UIColor(red:255/255,green:60/255,blue:40/255 ,alpha:1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTabbarButtonWith(_ item: UITabBarItem) -> Void {
        // 实例化button
        let button = tabBarButton()
        button.item = item
        self.tabBarButtons.add(button)
        button.addTarget(self, action: #selector(buttonDidTouch), for: .touchDown)
        self.addSubview(button)
        //  默认选中
        if self.tabBarButtons.count == 1 {
            self.buttonDidTouch((self.tabBarButtons[0] as? tabBarButton)!)
        }
    }
    
    func buttonDidTouch(_ button: tabBarButton) -> Void {
        tabbarDelegate.tabbar(self, formWhichItem: self.selectedButton.tag, toWhichItem: button.tag)
        // 控制器选中按钮
        self.selectedButton.isSelected = false
        button.isSelected = true
        self.selectedButton = button
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // button
        let buttonW = self.frame.size.width/CGFloat(self.tabBarButtons.count)
        let buttonH = self.frame.size.height
        let buttonY = 0
        
        for index in 0...self.tabBarButtons.count-1 {
            //  1.取出按钮
            let button: UIButton = self.tabBarButtons[index] as! UIButton
            //  2.设置按钮的frame
            let buttonX = CGFloat(index) * buttonW
            button.frame = CGRect(x: buttonX, y: CGFloat(buttonY), width: buttonW, height: buttonH)
            self.addSubview(button)
            //  3.绑定tag
            button.tag = index
        }
        
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
