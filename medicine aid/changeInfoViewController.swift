//
//  changeInfoViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/7/9.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class changeInfoViewController: UIViewController, UITextFieldDelegate {
    
    
    // 屏幕信息
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    //设置状态码（确定修改的是哪个信息）
    var key = 0
    
    var infoTextfield = UITextField()
    
    //
    var checkBtn1 = UIButton()
    var checkBtn2 = UIButton()
    
    //密码修改窗口
    var oldPassword = UITextField()
    var newPassword1 = UITextField()
    var newPassword2 = UITextField()
    
    let defaults = UserDefaults.standard
   

    override func viewDidLoad() {
        super.viewDidLoad()

        //标题
        changeNaviagtionBar()
        
        //首先加载背景
        let bgView = UIView(frame:UIScreen.main.bounds)
        bgView.backgroundColor = UIColor(red:226/255,green:226/255,blue:226/255 ,alpha: 1)
        self.view.addSubview(bgView)
        
        //
        switch key {
        case 0,1,3,4:
            labelChange()
        case 2:
            chooseChange()
        case 5:
            passwordChange()
        default:
            print("error")
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //使用一条状态条修改的方法
    func labelChange() {
        
        //定义底层白条
        let whiteView = UIView(frame:CGRect(x:0,y:70,width:screenWidth,height:40))
        whiteView.backgroundColor = UIColor.white
        self.view.addSubview(whiteView)
        
        infoTextfield = UITextField(frame:CGRect(x:10,y:0,width:screenWidth-10,height:40))
        infoTextfield.clearButtonMode = UITextFieldViewMode.whileEditing
        whiteView.addSubview(infoTextfield)
        infoTextfield.delegate = self
        
        let UserID = defaults.value(forKey: "UserID")!
        
        let realm = try! Realm()
        let User = realm.objects(UserText.self).filter("UserID = '\(UserID)'")[0]
        
        //依然使用状态码识别
        switch key {
        case 0:
            infoTextfield.text = User.UserNickname
        case 1:
            infoTextfield.text = User.UserName
        case 3:
            infoTextfield.text = User.UserAge
        case 4:
            infoTextfield.text = User.UserPhoneNum
        default:
            print("error")
        }
        
    }
    
    //修改信息 return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let UserID = defaults.value(forKey: "UserID")!
        
        let realm = try! Realm()
        let User = realm.objects(UserText.self).filter("UserID = '\(UserID)'")[0]
        
        realm.beginWrite()
        
        switch key {
        case 0:
            User.UserNickname = infoTextfield.text
            synchronizationInfoInNet(newNickname: infoTextfield.text!)
        case 1:
            User.UserName = infoTextfield.text
        case 3:
            User.UserAge = infoTextfield.text
        case 4:
            User.UserPhoneNum = infoTextfield.text
        case 5:
            print("修改密码")
            synchronizationPassword()
        default:
            print("error")
        }
        
        try! realm.commitWrite()
        
        textField.resignFirstResponder()
        
        _ = self.navigationController?.popViewController(animated: true)
        
        return true
    }
    
    
    //密码修改
    func passwordChange(){
        
        ///定义两行选择
        //定义底层白条
        let whiteView1 = UIView(frame:CGRect(x:0,y:70,width:screenWidth,height:40))
        let whiteView2 = UIView(frame:CGRect(x:0,y:112,width:screenWidth,height:40))
        let whiteView3 = UIView(frame:CGRect(x:0,y:154,width:screenWidth,height:40))
        whiteView1.backgroundColor = UIColor.white
        whiteView2.backgroundColor = UIColor.white
        whiteView3.backgroundColor = UIColor.white
        self.view.addSubview(whiteView1)
        self.view.addSubview(whiteView2)
        self.view.addSubview(whiteView3)
        
        //密码窗口
        oldPassword = UITextField(frame:CGRect(x:10,y:0,width:screenWidth-10,height:40))
        newPassword1 = UITextField(frame:CGRect(x:10,y:0,width:screenWidth-10,height:40))
        newPassword2 = UITextField(frame:CGRect(x:10,y:0,width:screenWidth-10,height:40))
        oldPassword.clearButtonMode = UITextFieldViewMode.whileEditing
        newPassword1.clearButtonMode = UITextFieldViewMode.whileEditing
        newPassword2.clearButtonMode = UITextFieldViewMode.whileEditing
        oldPassword.delegate = self
        newPassword1.delegate = self
        newPassword2.delegate = self
        oldPassword.isSecureTextEntry = true
        newPassword1.isSecureTextEntry = true
        newPassword2.isSecureTextEntry = true
        oldPassword.keyboardType = .namePhonePad
        newPassword1.keyboardType = .namePhonePad
        newPassword2.keyboardType = .namePhonePad
        oldPassword.placeholder = "请输入旧密码"
        newPassword1.placeholder = "请输入新密码"
        newPassword2.placeholder = "再次输入新密码"
        
        whiteView1.addSubview(oldPassword)
        whiteView2.addSubview(newPassword1)
        whiteView3.addSubview(newPassword2)
        
        // 导出按钮
        let doneBtn = UIButton(frame:CGRect(x:80,y:screenHeight*5/7+90,width:screenWidth-165,height:55))
        doneBtn.setBackgroundImage(UIImage(named:"register_done_bt"), for: UIControlState.normal)
        doneBtn.addTarget(self, action: #selector(synchronizationPassword) , for: UIControlEvents.touchUpInside)
        self.view.addSubview(doneBtn)
        
    }
    
    //使用选择修改性别
    func chooseChange() {
        
        ///定义两行选择
        //定义底层白条
        let whiteView1 = UIView(frame:CGRect(x:0,y:70,width:screenWidth,height:40))
        let whiteView2 = UIView(frame:CGRect(x:0,y:112,width:screenWidth,height:40))
        whiteView1.backgroundColor = UIColor.white
        whiteView2.backgroundColor = UIColor.white
        let gesture1 = UITapGestureRecognizer()
        gesture1.addTarget(self, action: #selector(tapMale))
        let gesture2 = UITapGestureRecognizer()
        gesture2.addTarget(self, action: #selector(tapFemale))
        whiteView1.isUserInteractionEnabled = true
        whiteView2.isUserInteractionEnabled = true
        whiteView1.addGestureRecognizer(gesture1)
        whiteView2.addGestureRecognizer(gesture2)
        self.view.addSubview(whiteView1)
        self.view.addSubview(whiteView2)
        
        //label
        let maleLabel = UILabel(frame:CGRect(x:10,y:0,width:screenWidth-10,height:40))
        let femaleLabel = UILabel(frame:CGRect(x:10,y:0,width:screenWidth-10,height:40))
        maleLabel.text = "男"
        femaleLabel.text = "女"
        whiteView1.addSubview(maleLabel)
        whiteView2.addSubview(femaleLabel)
        
        //button
        checkBtn1 = UIButton(frame:CGRect(x:screenWidth-30,y:10,width:20,height:20))
        checkBtn2 = UIButton(frame:CGRect(x:screenWidth-30,y:10,width:20,height:20))
        checkBtn1.setBackgroundImage(UIImage(named:"checkBtn"), for: .normal)
        checkBtn2.setBackgroundImage(UIImage(named:"checkBtn"), for: .normal)
        whiteView1.addSubview(checkBtn1)
        whiteView2.addSubview(checkBtn2)
        
        getSex()
        
    }
    
    //修改navigation title
    func changeNaviagtionBar() {
        
        switch key {
        case 0:
            self.navigationItem.title = "昵称"
        case 1:
            self.navigationItem.title = "姓名"
        case 2:
            self.navigationItem.title = "性别"
        case 3:
            self.navigationItem.title = "年龄"
        case 4:
            self.navigationItem.title = "电话"
        case 5:
            self.navigationItem.title = "密码修改"
        default:
            self.navigationItem.title = "error"
        }
    }
    
    
    //性别确认方法
    func getSex() {
        
        let UserID = defaults.value(forKey: "UserID")!
        
        let realm = try! Realm()
        let User = realm.objects(UserText.self).filter("UserID = '\(UserID)'")[0]
        
        if User.UserSex == "男"{
            checkBtn2.isHidden = true
        }else{
            checkBtn1.isHidden = true
        }
        
    }
    
    func tapMale() {
        
        let UserID = defaults.value(forKey: "UserID")!
        let realm = try! Realm()
        let User = realm.objects(UserText.self).filter("UserID = '\(UserID)'")[0]
        
        if User.UserSex == "男"{
            
        }else{
            realm.beginWrite()
            User.UserSex = "男"
            
            try! realm.commitWrite()
            
            checkBtn1.isHidden = false
            checkBtn2.isHidden = true
            
        }
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func tapFemale() {
        
        let UserID = defaults.value(forKey: "UserID")!
        let realm = try! Realm()
        let User = realm.objects(UserText.self).filter("UserID = '\(UserID)'")[0]
        
        if User.UserSex == "女"{
            
        }else{
            realm.beginWrite()
            User.UserSex = "女"
            
            try! realm.commitWrite()
            
            checkBtn1.isHidden = true
            checkBtn2.isHidden = false
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //网路接口_信息修改同步(nickname)
    func synchronizationInfoInNet(newNickname: String) {
        
        //用户Id
        let UserID = String(describing: defaults.value(forKey: "UserID")!)
        
        let url = AESEncoding.myURL + "igds/app/user/updateNickname"
        let parameters : Parameters = [
            
            "idString": UserID,
            "newNickname": AESEncoding.Endcode_AES_ECB(strToEncode: newNickname, typeCode: .nickName)
        
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            classValue in
            
            if let value = classValue.result.value{
                
                let json = JSON(value)
                let code = json["code"]
                
                print("修改昵称code:\(code)")
            
            }
        
        }
    }
    
    //网路接口_信息修改同步(password)
    func synchronizationPassword() {
        
        //用户Id
        let UserID = String(describing: defaults.value(forKey: "UserID")!)
        
        //密码
        let oldP = oldPassword.text
        let newP1 = newPassword1.text
        let newP2 = newPassword2.text
        
        if newP1 == newP2 {
            
            let url = AESEncoding.myURL + "igds/app/user/updatePassword"
            let parameters : Parameters = [
            
                "idString": UserID,
                "oldPassword": AESEncoding.Endcode_AES_ECB(strToEncode: oldP!, typeCode: .passWord),
                "newPassword": AESEncoding.Endcode_AES_ECB(strToEncode: newP1!, typeCode: .passWord)
            
            ]
        
            Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
                classValue in
            
                if let value = classValue.result.value{
                
                    let json = JSON(value)
                    let code = json["code"]
                
                    print("修改密码code:\(code)")
                    
                    if code == 422 {
                    
                        let alert = UIAlertController(title: "错误提示", message: "旧密码错误", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "好", style: .cancel, handler: {
                            _ in
                            self.dismiss(animated: true, completion: nil)
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }else if code == 201 {
                    
                        let alert = UIAlertController(title: "提示", message: "修改成功", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "好", style: .cancel, handler: {
                            _ in
                            self.dismiss(animated: true, completion: nil)
                            _ = self.navigationController?.popViewController(animated: true)
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    
                    }
                }
            }
            
        }else{
            
            let alert = UIAlertController(title: "错误提示", message: "新密码不一致", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好", style: .cancel, handler: {
                _ in
                self.dismiss(animated: true, completion: nil)
                
                self.newPassword1.text = ""
                self.newPassword2.text = ""
                
            }))
            self.present(alert, animated: true, completion: nil)
        
        }
        
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
