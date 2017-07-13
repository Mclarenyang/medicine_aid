//
//  doctorQRViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/7/12.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

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
        doneBtn.addTarget(self, action: #selector(doneBtnTap) , for: UIControlEvents.touchUpInside)
        self.view.addSubview(doneBtn)
        
        updateDoctorQR()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // 更新二维码
    func updateDoctorQR() {
    
        //读取ID
        let defaults = UserDefaults.standard
        let UserID = defaults.value(forKey: "UserID")!

            
            let url = AESEncoding.myURL + "igds/app/link/QR.png"
            let parameters: Parameters = ["idString": UserID]
        
            Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
                classValue in
     
                if let data = classValue.data{
                    
                    self.QRImage.image = UIImage(data: data)

            }
        }
    
    }
    
    //保存二维码
    func doneBtnTap() {
        
        UIImageWriteToSavedPhotosAlbum(QRImage.image!, nil, nil, nil)
        
        let alert = UIAlertController(title: "提示", message: "二维码成功保存到相册", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "好", style: .cancel, handler:nil)

        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
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
