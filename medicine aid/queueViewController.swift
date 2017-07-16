//
//  queueViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/5/10.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import Alamofire

class queueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    // 屏幕信息
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // tableview
    var tableView: UITableView!
    
    //刷新
    let rc = UIRefreshControl()
    var page = 1
    
    //医生ID——用于来自患者的跳转
    var doctorID = ""
    
    // 测试预设参数
    var anmtest :[(String,String,String,String)] = [("","","","")]
    
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
    
        //设置刷新UIRefreshControl
        rc.attributedTitle = NSAttributedString(string: "正在拼命刷新")
        rc.addTarget(self, action: #selector(queueViewController.refreshTableView), for: UIControlEvents.valueChanged)
        rc.tintColor = UIColor(red:255/255,green:60/255,blue:40/255 ,alpha: 1)
        self.tableView.refreshControl = rc
        
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        //每次显示加载
        refreshTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //编辑权限
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //删除按钮
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        //ID
        let defaults = UserDefaults.standard
        let UserID = defaults.value(forKey: "UserID")!
        
        //读Type
        let realm = try! Realm()
        
        let type = realm.objects(UserText.self).filter("UserID = '\(UserID)'")[0].UserType
        
        guard type != "doctor" else {
            return "删除挂号"
        }
        
        guard type != "patient" else {
            return "取消挂号"
        }
        
        return "error"
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        self.tableView!.deselectRow(at: indexPath, animated: true)
       
    }
    
    //删除行
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        print("选中的Cell 为\(self.anmtest[indexPath.row])")
        
        //ID
        let defaults = UserDefaults.standard
        let UserID = defaults.value(forKey: "UserID")!
        
        //读Type
        let realm = try! Realm()
        
        let type = realm.objects(UserText.self).filter("UserID = '\(UserID)'")[0].UserType

        guard type != "doctor" else{
            
            //提示
            let alert = UIAlertController(title: "提示", message: "确定挂号排队?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let doneAction = UIAlertAction(title: "好", style: .default, handler: {
                action in
            
            self.cancelLink(CdoctorID: UserID as! String, CpatientId: self.anmtest[indexPath.row].2, type: "删除")
            
        })
                alert.addAction(cancelAction)
                alert.addAction(doneAction)
                self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard type != "patient" else {
          
            if UserID as! String == self.anmtest[indexPath.row].2 {
                
                //提示
                let alert = UIAlertController(title: "提示", message: "确定挂号排队?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let doneAction = UIAlertAction(title: "好", style: .default, handler: {
                    action in
                    
                   self.cancelLink(CdoctorID: self.doctorID, CpatientId: self.anmtest[indexPath.row].2, type: "取消")
                    
                })
                alert.addAction(cancelAction)
                alert.addAction(doneAction)
                self.present(alert, animated: true, completion: nil)
                
             
                
            }else{
            
                //警告
                let alert = UIAlertController(title: "警告", message: "没有权限", preferredStyle: .alert)
                let action = UIAlertAction(title: "好", style: .default, handler: nil)
                
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
            return
        }
        
        refreshTableView()
    }
    
    // tableview行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight/10
    }
    
    // tableview行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return anmtest.count
    }
    
    // tableview 加载cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// 定义cell
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cellId")
        // 读取数据
        let name = anmtest[indexPath.row].0
        let phone = anmtest[indexPath.row].1
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = phone
        
        return cell
    }
    
    // 点击跳转事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //ID
        let defaults = UserDefaults.standard
        let UserID = defaults.value(forKey: "UserID")!
        
        //读Type
        let realm = try! Realm()
        
        let type = realm.objects(UserText.self).filter("UserID = '\(UserID)'")[0].UserType
        
        //判断权限
        if type == "doctor" && self.anmtest[indexPath.row].3 != "" {
            
            // 点击行
            NSLog(String(indexPath.row))
            // 跳转传值
            let prescribingView = prescribingViewController()
            prescribingView.doctorId = self.doctorID
            prescribingView.patientId = self.anmtest[indexPath.row].2
            prescribingView.nickname = self.anmtest[indexPath.row].0
            prescribingView.phonenumber = self.anmtest[indexPath.row].1
            self.navigationController?.pushViewController(prescribingView, animated: true)
            
        }else{
            
            //警告
            let alert = UIAlertController(title: "警告", message: "没有权限", preferredStyle: .alert)
            let action = UIAlertAction(title: "好", style: .default, handler: nil)
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    // 刷新表格
    func refreshTableView(){
    
        getInfo()
        
        rc.endRefreshing()
        
    }
    
    // 数据更新
    func getInfo() {
        
        self.anmtest.removeAll()
        
        let url = AESEncoding.myURL + "igds/app/link/list"
        let parameters:Parameters = [
            "doctorId": doctorID,
            "currentPage": page
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            classValue in
            
            if let value = classValue.result.value{
            
                let json = JSON(value)
        
                let code = json["code"]
                
                print("读取列表code:\(code)")
                
                if code == 200{
                
                    let list = json["body"]["list"]
                    
                    for (_ , subJson):(String, JSON) in list{
                    
                        var getit :(String,String,String,String) = ("","","","")
                        getit.0 = AESEncoding.Decode_AES_ECB(strToDecode: subJson["nickName"].string!, typeCode: .nickName)
                        getit.1 = AESEncoding.Decode_AES_ECB(strToDecode: subJson["phoneNumber"].string!, typeCode: .phoneNumber)
                        getit.2 = subJson["idString"].string!
                        getit.3 = subJson["type"].string!
                        
                        self.anmtest.append(getit)
                        
                    }
                    
                    self.tableView.reloadData()
                    
                    
                }else{
                    print("返回错误")
                }
            }
        }
    }
    
    //删除医患链接
    func cancelLink(CdoctorID:String, CpatientId:String, type: String) {
        
        ///在这里断开医生和患者链接
        let url = AESEncoding.myURL + "igds/app/link/cancle"
        let parameters:Parameters = [
            "doctorId": CdoctorID,
            "patientId": CpatientId
        ]
        
        print("提交参数:\(parameters)")
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            classValue in
            
            if let value = classValue.result.value{
                
                let json = JSON(value)
                let code = json["code"]
                
                print("断开患者code:\(code)")
                //判断是否提交成功
                if code == 204{
                    
                    let alert = UIAlertController(title: "提示", message: "\(type)成功", preferredStyle: .alert)
                    let doneAction = UIAlertAction(title: "好", style: .default, handler: {
                        action in
                        
                    })
                    
                    alert.addAction(doneAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }else if code == 410{
                
                    let alert = UIAlertController(title: "Error", message: "已经\(type)挂号", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "好", style: .cancel, handler: nil)
                    
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                
                
                }else{
                    
                    let alert = UIAlertController(title: "Error", message: "\(type)失败", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "好", style: .cancel, handler: nil)
                    
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }

        refreshTableView()
        
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
