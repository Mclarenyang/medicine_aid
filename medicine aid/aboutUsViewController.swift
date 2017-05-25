
//
//  aboutUsViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/5/12.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit

class aboutUsViewController: UITabBarController {

    // 屏幕信息
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// 设置导航标题
        self.navigationItem.title = "NMID"
        // 隐藏tabbar
        self.tabBarController?.tabBar.isHidden = true
        
        /// 设置网页
        let NMIDHomeWebView = UIWebView(frame: CGRect(x:0,y:64,width:screenWidth,height:screenHeight-64))
        self.view.addSubview(NMIDHomeWebView)
        
        let webAddress = "http://nmid.cqupt.edu.cn/"
        let url = NSURL(string: webAddress)
        let request = NSURLRequest(url: url as! URL)
        NMIDHomeWebView.loadRequest(request as URLRequest)
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
