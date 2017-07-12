//
//  queueViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/5/10.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit

class queueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    // 屏幕信息
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // tableview
    var tableView: UITableView!
    
    // 测试预设参数
    let anm :[(String,String)] = [("大象","2:15"),("兔子","3:00"),("松鼠","3:40"),("河豚","4:00"),("袋鼠","4:02"),("袋熊","5:00")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 设置导航栏标题
        self.navigationItem.title = "排号"
        
        /// 设置tableview
        self.tableView = UITableView(frame: CGRect(x:0,y:0,width:screenWidth,height:screenHeight))
        self.tableView.tableHeaderView?.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
    
        //初始化UIRefreshControl
        let rc = UIRefreshControl()
        rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        //rc.addTarget(self, action: "refreshTableView", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.refreshControl = rc
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // tableview行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight/10
    }
    
    // tableview行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return anm.count
    }
    
    // tableview 加载cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// 定义cell
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cellId")
        // 读取数据
        let name = anm[indexPath.row].0
        let time = anm[indexPath.row].1
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = time
        
        return cell
    }
    
    // 点击跳转事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 点击行
        NSLog(String(indexPath.row))
        // 跳转传值
        let prescribingView = prescribingViewController()
        self.navigationController?.pushViewController(prescribingView, animated: true)
    }
    
    // 刷新表格
    func refreshTableView(){
    
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
