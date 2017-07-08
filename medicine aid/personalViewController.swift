//
//  personalViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/5/10.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class personalViewController: UIViewController , UIPopoverPresentationControllerDelegate {
    
    // 屏幕信息
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    var rightbtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 设置导航栏
        self.navigationItem.title = "个人中心"
        self.navigationController?.navigationBar.barTintColor = UIColor(red:255/255,green:60/255,blue:40/255 ,alpha:1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // 右边按钮
        rightbtn = UIButton(frame: CGRect(x:0,y:0,width:20,height:20))
        rightbtn.setBackgroundImage(UIImage(named:"addpop"), for: UIControlState.normal)
        rightbtn.addTarget(self, action: #selector(rightBtnTap(_:)), for: UIControlEvents.touchUpInside)
        let item = UIBarButtonItem(customView: rightbtn)
        self.navigationItem.rightBarButtonItem = item
        
        /// 设置背景
        let bgView = UIView(frame:UIScreen.main.bounds)
        bgView.backgroundColor = UIColor.gray
        self.view.addSubview(bgView)
        
        /// 设置个人显示view
        let personView = UIView(frame: CGRect(x:0,y:64,width:screenWidth,height:screenHeight/5))
        personView.backgroundColor = UIColor.white
        bgView.addSubview(personView)
        
        // 设置头像
        let personHeadIamge = UIImageView(frame:CGRect(x:screenWidth/12,y:screenHeight/10-45,width:90,height:90))
        personHeadIamge.image = UIImage(named:"head") //读取处理
        personHeadIamge.layer.masksToBounds = true
        personHeadIamge.layer.cornerRadius = 45
        personView.addSubview(personHeadIamge)
        // 设置昵称
        let nickname = UILabel(frame: CGRect(x:screenWidth/9+100,y:screenHeight/10-45,width:300,height:100))
        nickname.font = UIFont.boldSystemFont(ofSize: 22)
        nickname.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(personalInfo))
        nickname.addGestureRecognizer(gestureRecognizer)
        nickname.text = "一只生病的兔纸🐰" //读取处理
        personView.addSubview(nickname)
        
        /// 设置中间条目
        let numView = UIView(frame: CGRect(x:0,y:screenHeight/3.25,width:screenWidth,height:screenHeight/6))
        numView.backgroundColor = UIColor.white
        bgView.addSubview(numView)
        
        /// 设置info按钮view
        let infoView = UIView(frame: CGRect(x:0,y:screenHeight/2.05,width:screenWidth,height:screenHeight/2))
        infoView.backgroundColor = UIColor.white
        bgView.addSubview(infoView)
        //  设置按钮
        //   问诊记录
        let prescribeRecordBtn = UIButton(frame: CGRect(x:screenWidth*1/12,y:screenHeight/22,width:screenWidth*4.75/12,height:screenHeight/6))
        prescribeRecordBtn.setBackgroundImage(UIImage(named:"prescribe_record_bt"), for: UIControlState.normal)
        //prescribeRecordBtn.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControlEvents#>)
        infoView.addSubview(prescribeRecordBtn)
        //   就诊记录
        let treatRecordBtn = UIButton(frame: CGRect(x:screenWidth*6.25/12,y:screenHeight/22,width:screenWidth*4.75/12,height:screenHeight/6))
        treatRecordBtn.setBackgroundImage(UIImage(named:"treat_record_bt"), for: UIControlState.normal)
        //treatRecordBtn.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControlEvents#>)
        infoView.addSubview(treatRecordBtn)
        //   服药提醒
        let cautionBtn = UIButton(frame: CGRect(x:screenWidth*1/12,y:screenHeight/4.2,width:screenWidth*4.75/12,height:screenHeight/6))
        cautionBtn.setBackgroundImage(UIImage(named: "caution_bt"), for: UIControlState.normal)
        cautionBtn.addTarget(self, action: #selector(cautionBtnTap(_:)), for:UIControlEvents.touchUpInside )
        infoView.addSubview(cautionBtn)
        //   关于我们
        let aboutUsBtn = UIButton(frame: CGRect(x:screenWidth*6.25/12,y:screenHeight/4.2,width:screenWidth*4.75/12,height:screenHeight/6))
        aboutUsBtn.setBackgroundImage(UIImage(named:"about_us_bt"), for: UIControlState.normal)
        aboutUsBtn.addTarget(self, action: #selector(aboutUsBtnTap(_:)), for: UIControlEvents.touchUpInside)
        infoView.addSubview(aboutUsBtn)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 按键响应事件
    
    // 服药提醒
    func cautionBtnTap(_ button:UIButton){
        
        if UIApplication.shared.canOpenURL(NSURL(string:"x-apple-reminder://")! as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(NSURL(string:"x-apple-reminder://") as! URL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(NSURL(string:"x-apple-reminder://")! as URL)
            }
        }
        
    }
    // 跳转事件
    func aboutUsBtnTap(_ button:UIButton){
        
        /// push界面
        let aboutUsView = aboutUsViewController()
        // 隐藏tabbar
        aboutUsView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(aboutUsView, animated: true)
        
    }

    // popview弹出
    func rightBtnTap(_ button:UIButton){
        
        let popover = selectTableViewController()
        popover.modalPresentationStyle = .popover
        popover.preferredContentSize = CGSize(width:50,height:50)
        popover.popoverPresentationController?.delegate = self
        popover.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        popover.popoverPresentationController?.sourceRect = rightbtn.bounds
        popover.popoverPresentationController?.permittedArrowDirections = .up
        self.present(popover, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func personalInfo(){
        
        let personalInfoView = selectTableViewController()
        // 隐藏tabbar
        personalInfoView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(personalInfoView, animated: true)
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
