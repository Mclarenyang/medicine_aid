//
//  loginViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/5/5.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit
import TextFieldEffects


class loginViewController: UIViewController,UITextFieldDelegate {

    /// 屏幕信息
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // 密码栏
    var passwordText = MadokaTextField()
    
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
        
        
        // 创建icon
        let iconImageX = Int(screenWidth/2-55)
        let iconImageY = Int(screenHeight/6)
        let iconImageView = UIImageView(frame:CGRect(x:iconImageX,y:iconImageY,width:110,height:86))
        iconImageView.image = UIImage(named:"welcome_logo")
        bgImageView.addSubview(iconImageView)
        
        // 创建textfiled
        let phoneText = MadokaTextField(frame:CGRect(x:50,y:screenHeight*2.5/7,width:screenWidth-100,height:50))
        phoneText.placeholder = "电话"
        phoneText.borderColor = UIColor(red:255/255,green:60/255,blue:40/255 ,alpha: 1)
        phoneText.autocorrectionType = UITextAutocorrectionType.no
        phoneText.returnKeyType = UIReturnKeyType.next
        phoneText.clearButtonMode = UITextFieldViewMode.whileEditing
        phoneText.keyboardType = UIKeyboardType.phonePad
        phoneText.keyboardAppearance = UIKeyboardAppearance.light
        phoneText.delegate = self
        self.view.addSubview(phoneText)
        
        passwordText = MadokaTextField(frame:CGRect(x:50,y:screenHeight*2.5/7+70,width:screenWidth-100,height:50))
        passwordText.placeholder = "密码"
        passwordText.borderColor = UIColor(red:255/255,green:60/255,blue:40/255 ,alpha: 1)
        passwordText.autocorrectionType = UITextAutocorrectionType.no
        passwordText.returnKeyType = UIReturnKeyType.next
        //passwordText.clearButtonMode = UITextFieldViewMode.whileEditing
        passwordText.keyboardType = UIKeyboardType.default
        passwordText.keyboardAppearance = UIKeyboardAppearance.light
        passwordText.delegate = self
        passwordText.isSecureTextEntry = true
        self.view.addSubview(passwordText)
        
        // 秘码按钮
        let showPassWordBtn = UIButton(frame:CGRect(x:screenWidth-135,y:5,width:30,height:20))
        showPassWordBtn.setBackgroundImage(UIImage(named:"showPassWord"), for: UIControlState.normal)
        showPassWordBtn.addTarget(self, action: #selector(showPassWords(_:)), for: UIControlEvents.touchDown)
        passwordText.addSubview(showPassWordBtn)
        
        // 创建按钮
        let loginBtn = UIButton(frame:CGRect(x:75,y:screenHeight*4/7+10,width:screenWidth-150,height:50))
        loginBtn.setBackgroundImage(UIImage(named:"log_in_bt"), for: UIControlState.normal)
        loginBtn.addTarget(self, action: #selector(homeViewTap(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(loginBtn)
        
        let registerBtn = UIButton(frame:CGRect(x:80,y:screenHeight*4/7+70,width:screenWidth-165,height:40))
        registerBtn.setBackgroundImage(UIImage(named:"log_in_reg_bt"), for: UIControlState.normal)
        registerBtn.addTarget(self, action: #selector(registerTap(_:)) , for: UIControlEvents.touchUpInside)
        self.view.addSubview(registerBtn)

        let forgetPWBtn = UIButton(frame:CGRect(x:screenWidth/2-50,y:screenHeight-20,width:100,height:10))
        forgetPWBtn.setTitle("忘记密码？", for: UIControlState.normal)
        forgetPWBtn.setTitleColor(UIColor.red, for: UIControlState.normal)
        forgetPWBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(forgetPWBtn)
        
    }

    // 跳转事件
    func registerTap(_ button:UIButton){
       
        // 模态弹出
        let registerView = registerViewController()
        registerView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(registerView, animated: true, completion: nil)
        /*
        let registerView = registerViewController()
        self.navigationController?.pushViewController(registerView, animated: true)
        */
        
    }
    
    // 进入主界面
    func homeViewTap(_ button:UIButton){
        
        // 模态弹出
        let homeView = mainTabbarController()
        self.navigationController?.pushViewController(homeView, animated: true)
        
    }
    
    // 显示密码
    func showPassWords(_ button:UIButton){
        
       passwordText.isSecureTextEntry = false
        
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
