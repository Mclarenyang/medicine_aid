//
//  registerViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/5/7.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit
import TextFieldEffects

class registerViewController: UINavigationController,UITextFieldDelegate{

    // 屏幕信息
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
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
        let phoneText = MadokaTextField(frame:CGRect(x:50,y:screenHeight*2.3/7,width:screenWidth-100,height:50))
        phoneText.placeholder = "电话"
        phoneText.borderColor = UIColor.red
        phoneText.autocorrectionType = UITextAutocorrectionType.no
        phoneText.returnKeyType = UIReturnKeyType.next
        phoneText.clearButtonMode = UITextFieldViewMode.whileEditing
        phoneText.keyboardType = UIKeyboardType.phonePad
        phoneText.keyboardAppearance = UIKeyboardAppearance.light
        phoneText.delegate = self
        self.view.addSubview(phoneText)
        
        let passwordText = MadokaTextField(frame:CGRect(x:50,y:screenHeight*2.3/7+70,width:screenWidth-100,height:50))
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
        
        let VerificationwordText = MadokaTextField(frame:CGRect(x:50,y:screenHeight*2.3/7+140,width:screenWidth-250,height:50))
        VerificationwordText.placeholder = "验证码"
        VerificationwordText.borderColor = UIColor.red
        VerificationwordText.autocorrectionType = UITextAutocorrectionType.no
        VerificationwordText.returnKeyType = UIReturnKeyType.next
        VerificationwordText.clearButtonMode = UITextFieldViewMode.whileEditing
        VerificationwordText.keyboardType = UIKeyboardType.default
        VerificationwordText.keyboardAppearance = UIKeyboardAppearance.light
        VerificationwordText.delegate = self
        self.view.addSubview(VerificationwordText)
        
        // 创建按钮
        let doneBtn = UIButton(frame:CGRect(x:80,y:screenHeight*4/7+70,width:screenWidth-165,height:55))
        doneBtn.setBackgroundImage(UIImage(named:"register_done_bt"), for: UIControlState.normal)
        //doneBtn.addTarget(self, action: #selector(//设置方法) , for: UIControlEvents.touchUpInside)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
