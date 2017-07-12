//
//  changeInfoViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/7/9.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit
import RealmSwift

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
        case 1:
            User.UserName = infoTextfield.text
        case 3:
            User.UserAge = infoTextfield.text
        case 4:
            User.UserPhoneNum = infoTextfield.text
        default:
            print("error")
        }
        
        try! realm.commitWrite()
        
        textField.resignFirstResponder()
        
        _ = self.navigationController?.popViewController(animated: true)
        
        return true
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
