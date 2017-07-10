//
//  selectTableViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/5/16.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit

class selectTableViewController: UITableViewController {
    
    
    // 测试预设参数
    let titles :[String] = ["昵称","姓名","性别","出生日期","电话号码"]
    var indexI = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        /// 设置导航栏
        self.navigationItem.title = "个人信息"
        self.navigationController?.navigationBar.barTintColor = UIColor(red:255/255,green:60/255,blue:40/255 ,alpha:1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titles.count
    }

    // tableview 加载cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// 定义cell
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cellId")
        // 读取数据
        let title = titles[indexI]
        
        indexI += 1
        
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = "读取数据库"
        
        return cell
    }
  
    // 点击跳转事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 点击行
        NSLog(String(indexPath.row))
        
        let rowIndex = indexPath.row
        switch rowIndex {
        case 0...2,4:
            let infochange = changeInfoViewController()
            infochange.key = rowIndex
            self.navigationController?.pushViewController(infochange, animated: true)
        case 3:
            print("出生日期")
        default:
            print("无效操作")
        }

    }

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
