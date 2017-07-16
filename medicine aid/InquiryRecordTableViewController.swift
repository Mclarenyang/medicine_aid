//
//  InquiryRecordTableViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/7/16.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit
import RealmSwift

class InquiryRecordTableViewController: UITableViewController {
    
    
    // 屏幕信息
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // 显示列表参数
    var list :[(String,String,String)] = [("","","")]
    
    //刷新
    let rc = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 设置导航栏
        self.navigationItem.title = "问诊记录"
        self.navigationController?.navigationBar.barTintColor = UIColor(red:255/255,green:60/255,blue:40/255 ,alpha:1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        

        //设置刷新UIRefreshControl
        rc.attributedTitle = NSAttributedString(string: "正在拼命刷新")
        rc.addTarget(self, action: #selector(InquiryRecordTableViewController.refreshTableView), for: UIControlEvents.valueChanged)
        rc.tintColor = UIColor(red:255/255,green:60/255,blue:40/255 ,alpha: 1)
        self.tableView.refreshControl = rc
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        refreshTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    // tableview行高
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight/10
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.count
    }
    
    // tableview 加载cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// 定义cell
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cellId")
        // 读取数据
        let name = list[indexPath.row].0
        let time = list[indexPath.row].1
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = time
        
        return cell
    }

    
    // 点击跳转事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let myPMedicalView = myPMedicineTableViewController()
        myPMedicalView.medicienlist = list[indexPath.row].2
        self.navigationController?.pushViewController(myPMedicalView, animated: true)
        
    }
    
    
    // 刷新表格
    func refreshTableView(){
        
        getList()
        rc.endRefreshing()
        
    }
    
    func getList() {
        
        self.list.removeAll()
        
        //读取储存信息
        //ID
        let defaults = UserDefaults.standard
        let UserID =  String(describing: defaults.value(forKey: "UserID")!)
        
        //读取所有条目
        let realm = try! Realm()
        let mylist = realm.objects(DPRList.self).filter("DoctorID = '\(UserID)'").filter("MedicalList != nil")
        
        guard mylist.count != 0 else {
            
            let newlistsub = ("暂无数据","","")
            list.append(newlistsub)
            
            self.tableView.reloadData()
            
            return
        }
        
        for i in 0...mylist.count-1{
            
            var newlistsub: (String,String,String) = ("","","")
            newlistsub.0 = mylist[i].PatientNickname
            newlistsub.1 = mylist[i].Time
            newlistsub.2 = mylist[i].MedicalList
  
            
            list.append(newlistsub)
            
        }
        
        self.tableView.reloadData()
        
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
