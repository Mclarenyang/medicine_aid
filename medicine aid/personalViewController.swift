//
//  personalViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/5/10.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit
import CocoaAsyncSocket
import RealmSwift

class personalViewController: UIViewController , UIPopoverPresentationControllerDelegate , UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    // 屏幕信息
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    var rightbtn = UIButton()
    
    //个人
    var personView = UIView()
    //头像
    var personHeadIamge = UIImageView()
    //昵称
    var nickname = UILabel()
    
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
        personView = UIView(frame: CGRect(x:0,y:64,width:screenWidth,height:screenHeight/5))
        personView.backgroundColor = UIColor.white
        bgView.addSubview(personView)
        
        // 设置头像
        personHeadIamge = UIImageView(frame:CGRect(x:screenWidth/12,y:screenHeight/10-45,width:90,height:90))
        //personHeadIamge.image = UIImage(named:"head") //读取处理
        personHeadIamge.layer.masksToBounds = true
        personHeadIamge.layer.cornerRadius = 45
        personHeadIamge.isUserInteractionEnabled = true
        let heardImageGeesture = UITapGestureRecognizer(target: self, action: #selector(personalHeard))
        personHeadIamge.addGestureRecognizer(heardImageGeesture)
        personView.addSubview(personHeadIamge)
        
        // 设置昵称
        nickname = UILabel(frame: CGRect(x:screenWidth/9+100,y:screenHeight/10-45,width:300,height:100))
        nickname.font = UIFont.boldSystemFont(ofSize: 22)
        nickname.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(personalInfo))
        nickname.addGestureRecognizer(gestureRecognizer)
        //nickname.text = "一只生病的兔纸🐰" //读取处理
        personView.addSubview(nickname)
        
        //数据库读取数据
        getPersonInfo()
        
        /// 设置中间条目
        let numView = UIView(frame: CGRect(x:0,y:screenHeight/3.25 - 3,width:screenWidth,height:screenHeight/6 + 5))
        numView.backgroundColor = UIColor(patternImage: UIImage(named: "QRView")!)
        numView.isUserInteractionEnabled = true
        let gestureQR = UITapGestureRecognizer(target: self, action: #selector(QRViewTap))
        numView.addGestureRecognizer(gestureQR)
        bgView.addSubview(numView)
        
        /// 设置info按钮view
        let infoView = UIView(frame: CGRect(x:0,y:screenHeight/2.05,width:screenWidth,height:screenHeight/2))
        infoView.backgroundColor = UIColor.white
        bgView.addSubview(infoView)
        
        //  设置按钮
        //   问诊记录
        let prescribeRecordBtn = UIButton(frame: CGRect(x:screenWidth*1/12,y:screenHeight/22,width:screenWidth*4.75/12,height:screenHeight/6))
        prescribeRecordBtn.setBackgroundImage(UIImage(named:"prescribe_record_bt"), for: UIControlState.normal)
        prescribeRecordBtn.addTarget(self, action: #selector(openInquiryRecord), for: .touchUpInside)
        infoView.addSubview(prescribeRecordBtn)
        //   就诊记录
        let treatRecordBtn = UIButton(frame: CGRect(x:screenWidth*6.25/12,y:screenHeight/22,width:screenWidth*4.75/12,height:screenHeight/6))
        treatRecordBtn.setBackgroundImage(UIImage(named:"treat_record_bt"), for: UIControlState.normal)
        treatRecordBtn.addTarget(self, action: #selector(openVisitingRecord), for: .touchUpInside)
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        getPersonInfo()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    /// 按键响应事件
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
    
    //修改信息
    func personalInfo(){
        
        let personalInfoView = selectTableViewController()
        // 隐藏tabbar
        personalInfoView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(personalInfoView, animated: true)
    }
    
    ///头像点击事件
    func personalHeard(){
    
        let alert = UIAlertController(title: "修改头像", message: "", preferredStyle: .actionSheet)
        let photoAction = UIAlertAction(title: "相册", style: .default , handler: { (action:UIAlertAction)in
            self.photo()
        })
        let cameraAction = UIAlertAction(title: "相机", style: .default , handler: { (action:UIAlertAction)in
            self.camera()
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel , handler: nil)
        
        alert.addAction(photoAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // 相册方法
    func photo(){
        
        let pick:UIImagePickerController = UIImagePickerController()
        pick.delegate = self
        pick.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(pick, animated: true, completion: nil)
        
    }
    
    //相机方法
    func camera(){
        
        guard QRCodeReader.isDeviceAvailable() else{
            let alert = UIAlertController(title: "Error", message: "相机无法使用", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好", style: .cancel, handler: {
                _ in
                self.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let pick:UIImagePickerController = UIImagePickerController()
        pick.delegate = self
        pick.sourceType = UIImagePickerControllerSourceType.camera
        self.present(pick, animated: true, completion: nil)
        
    }
    
    //获取照片后的代理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //print(info)
        
        personHeadIamge.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //更新头像
        let defaults = UserDefaults.standard
        let UserID = defaults.value(forKey: "UserID")!
        
        let realm = try! Realm()
        let UserWhoUpdateHeard = realm.objects(UserText.self).filter("UserID = '\(UserID)'")[0]
        
        //
        realm.beginWrite()
        
        UserWhoUpdateHeard.UserHeadImage = UIImagePNGRepresentation(personHeadIamge.image!) as NSData!
        
        try! realm.commitWrite()
        
        
        //图片控制器退出
        picker.dismiss(animated: true, completion: {
            () -> Void in
        })
        
    }
    
    //读取数据
    func getPersonInfo() {
        
        let defaults = UserDefaults.standard
        let UserID = defaults.value(forKey: "UserID")!
        

        let realm = try! Realm()
        let User = realm.objects(UserText.self).filter("UserID = '\(UserID)'")[0]
        
        //头像
        if User.UserHeadImage == nil {
            personHeadIamge.image = UIImage(named:"SettingHeardImage")
        }else{
            personHeadIamge.image = UIImage(data: User.UserHeadImage as Data)
        }
        
        //昵称
        if User.UserNickname == nil{
            nickname.text = "点我设置"
        }else{
            nickname.text = User.UserNickname
        }
        
        
        //填充空值
        realm.beginWrite()
        
        if User.UserAge == nil{
            User.UserAge = "20"
        }
        if User.UserName == nil{
            User.UserName = "点我设置姓名"
        }
        if User.UserSex == nil{
            User.UserSex = "男"
        }
        
        try! realm.commitWrite()
    }
    
    //二维码跳转
    func QRViewTap() {
        
        //ID
        let defaults = UserDefaults.standard
        let UserID = defaults.value(forKey: "UserID")!
        
        //读Type
        let realm = try! Realm()
        
        let type = realm.objects(UserText.self).filter("UserID = '\(UserID)'")[0].UserType
        
        //判断权限
        if type == "doctor" {
            
             let QRView = doctorQRViewController()
            QRView.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(QRView, animated: true)
            
        }else{
            
            //警告
            let alert = UIAlertController(title: "警告", message: "没有权限", preferredStyle: .alert)
            let action = UIAlertAction(title: "好", style: .default, handler: nil)
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
       
        
    }
    
    //问诊记录
    func openInquiryRecord() {
        
        //ID
        let defaults = UserDefaults.standard
        let UserID = defaults.value(forKey: "UserID")!
        
        //读Type
        let realm = try! Realm()
        
        let type = realm.objects(UserText.self).filter("UserID = '\(UserID)'")[0].UserType
        
        //判断权限
        if type == "doctor" {
            
            let IRView = InquiryRecordTableViewController()
            IRView.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(IRView, animated: true)
            
        }else{
            
            //警告
            let alert = UIAlertController(title: "警告", message: "没有权限", preferredStyle: .alert)
            let action = UIAlertAction(title: "好", style: .default, handler: nil)
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    //就诊记录
    func openVisitingRecord() {
        
        let VRView = VisitingRecordTableViewController()
        VRView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(VRView, animated: true)
     
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
