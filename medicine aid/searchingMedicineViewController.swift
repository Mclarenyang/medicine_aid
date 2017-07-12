//
//  searchingMedicineViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/5/10.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit

class searchingMedicineViewController: UIViewController,UISearchBarDelegate {

    // 屏幕信息
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 导航栏显示
        self.navigationController?.navigationBar.isHidden = false
        //  隐藏返回按钮
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red:255/255,green:60/255,blue:40/255 ,alpha:1)
        self.navigationItem.title = "药材百科"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

//        // 创建搜索框
//        let searchingbar = UISearchBar(frame:CGRect(x:0, y:64, width:screenWidth, height:30))
//        searchingbar.keyboardType = UIKeyboardType.alphabet
//        searchingbar.placeholder = "输入药材名称"
//        self.view.addSubview(searchingbar)
        
        /// 设置网页
        let searchingWebView = UIWebView(frame: CGRect(x:0,y:0,width:screenWidth,height:screenHeight))
        self.view.addSubview(searchingWebView)
        
        let webAddress = "http://baike.baidu.com/item/%E5%BD%93%E5%BD%92"
        let url = NSURL(string: webAddress)
        let request = NSURLRequest(url: url as! URL)
        searchingWebView.loadRequest(request as URLRequest)
        
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
