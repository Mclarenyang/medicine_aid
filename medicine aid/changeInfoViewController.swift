//
//  changeInfoViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/7/9.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit

class changeInfoViewController: UIViewController {
    
    
    // 屏幕信息
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    //设置状态码（确定修改的是哪个信息）
    var key = 0

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
        case 0,1,4:
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
        
        let infoTextfield = UITextField(frame:CGRect(x:10,y:0,width:screenWidth-10,height:40))
        infoTextfield.clearButtonMode = UITextFieldViewMode.whileEditing
        whiteView.addSubview(infoTextfield)
        
        //依然使用状态码识别
        switch key {
        case 0:
            infoTextfield.text = "从数据库读取昵称"
        case 1:
            infoTextfield.text = "从数据库读取姓名"
        case 4:
            infoTextfield.text = "从数据库读取电话"
        default:
            print("error")
        }
        
    }
    
    //使用选择修改性别
    func chooseChange() {
        
        ///定义两行选择
        //定义底层白条
        let whiteView1 = UIView(frame:CGRect(x:0,y:70,width:screenWidth,height:40))
        let whiteView2 = UIView(frame:CGRect(x:0,y:112,width:screenWidth,height:40))
        whiteView1.backgroundColor = UIColor.white
        whiteView2.backgroundColor = UIColor.white
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
        let checkBtn1 = UIButton(frame:CGRect(x:screenWidth-30,y:10,width:20,height:20))
        let checkBtn2 = UIButton(frame:CGRect(x:screenWidth-30,y:10,width:20,height:20))
        checkBtn1.setBackgroundImage(UIImage(named:"checkBtn"), for: .normal)
        checkBtn2.setBackgroundImage(UIImage(named:"checkBtn"), for: .normal)
        whiteView1.addSubview(checkBtn1)
        whiteView2.addSubview(checkBtn2)
        
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
        case 4:
            self.navigationItem.title = "电话"
        default:
            self.navigationItem.title = "error"
        }
    }
    
    
    //性别确认方法
    func getSex() {
        
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
