//
//  RootViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/5/5.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    // 屏幕信息
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 启动页隐藏导航条
        self.navigationController?.navigationBar.isHidden = true
        
        // 创建底层视图
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.white
        bottomView.frame = UIScreen.main.bounds
        self.view.addSubview(bottomView)
        
        // 创建背景
        let backgroundImageView = UIImageView(frame:UIScreen.main.bounds)
        backgroundImageView.image = UIImage(named:"welcome_bg")
        bottomView.addSubview(backgroundImageView)
    
        // 创建动态icon
        let iconImageX = Int(screenWidth/2-55)
        let iconImageY = Int(screenHeight/4+3)
        let iconImageView = UIImageView(frame:CGRect(x:iconImageX,y:iconImageY,width:110,height:90))
        iconImageView.image = UIImage(named:"welcome_logo")
        backgroundImageView.addSubview(iconImageView)
        // 放大动画
        UIView.animate(withDuration: 1 , delay:0.01,
                                   options:UIViewAnimationOptions.curveEaseIn, animations:
            {
                ()-> Void in
                iconImageView.layer.setAffineTransform(CGAffineTransform(scaleX: 1.2,y: 1.2))
        },completion:{
            (finished:Bool) -> Void in
            UIView.animate(withDuration: 0.08, animations:{()-> Void in
            })
        })

    
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        // 延时
        let time: TimeInterval = 1
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            // 场景转换
            let loginView = loginViewController()
            loginView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.navigationController?.pushViewController(loginView, animated: true)
        }

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

    }
    

}
