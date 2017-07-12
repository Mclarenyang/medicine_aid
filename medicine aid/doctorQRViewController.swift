//
//  doctorQRViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/7/12.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit

class doctorQRViewController: UIViewController {
    
    // 屏幕信息
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    // 二维码显示页
    var QRImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置navigationbar标题
        self.navigationItem.title = "二维码"
        
        /// 设置背景
        let bgView = UIView(frame:UIScreen.main.bounds)
        bgView.backgroundColor = UIColor.white
        self.view.addSubview(bgView)
        
        // 显示QR
        let QRBgView = UIView(frame:CGRect(x:(screenWidth-250)/2,y:screenHeight*1/4,width:250,height:250))
        QRBgView.backgroundColor = UIColor(patternImage: UIImage(named:"QRbackground")!)
        self.view.addSubview(QRBgView)

        // 二维码image设置
        QRImage = UIImageView(frame:CGRect(x:15,y:15,width:216,height:216))
        QRImage.image = UIImage(named: "testQR")
        QRBgView.addSubview(QRImage)
        
        // 导出按钮
        let doneBtn = UIButton(frame:CGRect(x:80,y:screenHeight*5/7+90,width:screenWidth-165,height:55))
        doneBtn.setBackgroundImage(UIImage(named:"putOutQR"), for: UIControlState.normal)
        //doneBtn.addTarget(self, action: #selector() , for: UIControlEvents.touchUpInside)
        self.view.addSubview(doneBtn)
        
        // Do any additional setup after loading the view.
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
