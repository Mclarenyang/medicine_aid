//
//  tabBarButton.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/5/11.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit

class tabBarButton: UIButton {
    
    let tabbarImageRatio = 0.65
    var item : UITabBarItem = UITabBarItem(){
        didSet{
            self.setTitle(self.item.title, for: UIControlState())
            self.setTitle(self.item.title, for: .selected)
            
            self.setImage(self.item.image, for: UIControlState())
            self.setImage(self.item.selectedImage, for: .selected)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //   图片居中
        self.imageView?.contentMode = .center
        //   去掉高亮状态
        self.adjustsImageWhenHighlighted = false
        //   文字居中
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        //  title两种状态的颜色
        self.setTitleColor(UIColor.white, for: .selected)
        self.setTitleColor(UIColor.black, for: UIControlState())
    }
    
    // title
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleY = contentRect.size.height * CGFloat(tabbarImageRatio)
        let titleH = contentRect.size.height - titleY
        let titleW = contentRect.size.width
        return CGRect(x: 0, y: titleY, width: titleW, height: titleH)
    }
    /// image
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageH = contentRect.size.height * CGFloat(tabbarImageRatio)
        let imageW = contentRect.size.width
        return CGRect(x: 0, y: 0, width: imageW, height: imageH)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
