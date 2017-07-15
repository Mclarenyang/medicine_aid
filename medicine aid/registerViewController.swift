//
//  registerViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/5/7.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire
import SwiftyJSON

class registerViewController: UINavigationController,UITextFieldDelegate{

    // 屏幕信息
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // 信息视图
    var phoneText = MadokaTextField()
    var passwordText = MadokaTextField()
    var nickNameText = MadokaTextField()
    
    //typeButton
    var checkBtn1 = UIButton()
    var checkBtn2 = UIButton()
    
    //type
    var type = "patient"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建底层视图
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.white
        bottomView.frame = UIScreen.main.bounds
        self.view.addSubview(bottomView)
        
        // 创建背景
        let bgImageView = UIImageView(frame:UIScreen.main.bounds)
        bgImageView.image = UIImage(named:"log_in_bg")
        self.view.addSubview(bgImageView)

        // 创建动态icon
        let iconImageX = Int(screenWidth/2-55)
        let iconImageY = Int(screenHeight/6)
        let iconImageView = UIImageView(frame:CGRect(x:iconImageX,y:iconImageY,width:110,height:86))
        iconImageView.image = UIImage(named:"welcome_logo")
        bgImageView.addSubview(iconImageView)
        
        // 创建textfiled
        phoneText = MadokaTextField(frame:CGRect(x:50,y:screenHeight*2.3/7,width:screenWidth-100,height:50))
        phoneText.placeholder = "电话"
        phoneText.borderColor = UIColor.red
        phoneText.autocorrectionType = UITextAutocorrectionType.no
        phoneText.returnKeyType = UIReturnKeyType.next
        phoneText.clearButtonMode = UITextFieldViewMode.whileEditing
        phoneText.keyboardType = UIKeyboardType.phonePad
        phoneText.keyboardAppearance = UIKeyboardAppearance.light
        phoneText.delegate = self
        self.view.addSubview(phoneText)
        
        passwordText = MadokaTextField(frame:CGRect(x:50,y:screenHeight*2.3/7+70,width:screenWidth-100,height:50))
        passwordText.placeholder = "密码"
        passwordText.borderColor = UIColor.red
        passwordText.autocorrectionType = UITextAutocorrectionType.no
        passwordText.returnKeyType = UIReturnKeyType.next
        passwordText.clearButtonMode = UITextFieldViewMode.whileEditing
        passwordText.keyboardType = UIKeyboardType.default
        passwordText.keyboardAppearance = UIKeyboardAppearance.light
        passwordText.delegate = self
        passwordText.isSecureTextEntry = true
        self.view.addSubview(passwordText)
        
        nickNameText = MadokaTextField(frame:CGRect(x:50,y:screenHeight*2.3/7+140,width:screenWidth-220,height:50))
        nickNameText.placeholder = "昵称"
        nickNameText.borderColor = UIColor.red
        nickNameText.autocorrectionType = UITextAutocorrectionType.no
        nickNameText.returnKeyType = UIReturnKeyType.next
        nickNameText.clearButtonMode = UITextFieldViewMode.whileEditing
        nickNameText.keyboardType = UIKeyboardType.default
        nickNameText.keyboardAppearance = UIKeyboardAppearance.light
        nickNameText.delegate = self
        self.view.addSubview(nickNameText)
        
        let patientLable = UILabel(frame:CGRect(x:230,y:screenHeight*2.3/7+145,width:screenWidth-250,height:30))
        let doctorlable = UILabel(frame:CGRect(x:230,y:screenHeight*2.3/7+175,width:screenWidth-250,height:30))
        patientLable.text = "患者"
        doctorlable.text = "医生"
        let gesture1 = UITapGestureRecognizer()
        gesture1.addTarget(self, action: #selector(patientTap))
        let gesture2 = UITapGestureRecognizer()
        gesture2.addTarget(self, action: #selector(doctorTap))
        patientLable.isUserInteractionEnabled = true
        doctorlable.isUserInteractionEnabled = true
        patientLable.addGestureRecognizer(gesture1)
        doctorlable.addGestureRecognizer(gesture2)

        self.view.addSubview(patientLable)
        self.view.addSubview(doctorlable)
        
        checkBtn1 = UIButton(frame:CGRect(x:280,y:screenHeight*2.3/7+148,width:20,height:20))
        checkBtn2 = UIButton(frame:CGRect(x:280,y:screenHeight*2.3/7+178,width:20,height:20))
        checkBtn1.setBackgroundImage(UIImage(named:"checkBtn"), for: .normal)
        checkBtn2.setBackgroundImage(UIImage(named:"checkBtn"), for: .normal)
        checkBtn2.isHidden = true
        self.view.addSubview(checkBtn1)
        self.view.addSubview(checkBtn2)
        
        // 创建按钮
        let doneBtn = UIButton(frame:CGRect(x:80,y:screenHeight*4/7+90,width:screenWidth-165,height:55))
        doneBtn.setBackgroundImage(UIImage(named:"register_done_bt"), for: UIControlState.normal)
        doneBtn.addTarget(self, action: #selector(doneBtnTap) , for: UIControlEvents.touchUpInside)
        self.view.addSubview(doneBtn)
        
        //返回按钮
        let backBtn = UIButton(frame:CGRect(x:20,y:40,width:60,height:20))
        backBtn.setBackgroundImage(UIImage(named:"backBTn"), for: UIControlState.normal)
        backBtn.addTarget(self, action: #selector(backToregisterView(_:)) , for: UIControlEvents.touchUpInside)
        self.view.addSubview(backBtn)
        
    }
    
    func backToregisterView(_ button:UIButton){
        
        // 模态弹出
        self.dismiss(animated: true, completion: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///切换按钮
    //患者
    func patientTap() {
        
        type = "patient"
        
        checkBtn1.isHidden = false
        checkBtn2.isHidden = true
    }
    
    //医生
    func doctorTap()  {
        
        type = "doctor"
        
        checkBtn1.isHidden = true
        checkBtn2.isHidden = false
    }
    
    //确定注册
    func doneBtnTap(){
    
        //加密
        let nickname = AESEncoding.Endcode_AES_ECB(strToEncode: nickNameText.text!, typeCode: .nickName)
        let password = AESEncoding.Endcode_AES_ECB(strToEncode: passwordText.text!, typeCode: .passWord)
        let phoneNumber = AESEncoding.Endcode_AES_ECB(strToEncode: phoneText.text!, typeCode: .phoneNumber)
        
        print(nickname,password,phoneNumber)
        
        //网络请求
        let parameters: Parameters = [
            "nickname": nickname,
            "password": password,
            "phoneNumber": phoneNumber,
            "type": type
        ]
        
        let url = AESEncoding.myURL + "igds/app/user/signUp"
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            classUser in
            
            if let value = classUser.result.value{
                
                let json = JSON(value)
                
                let code = json["code"]
                
                print("用户注册code:\(code)")
                
                switch code{
                    
                case 200:
                    print("注册成功")
                    
                    let alert = UIAlertController(title: "提示", message: "注册成功", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "好", style: .cancel, handler: {
                        _ in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                default:
                    print("注册失败")
                    
                    let alert = UIAlertController(title: "注册失败", message: "错误代码:\(code)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "好", style: .cancel, handler: {
                        _ in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
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
