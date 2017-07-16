//
//  myPMedicineTableViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/7/16.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit

class myPMedicineTableViewController: UITableViewController {
    
    var medicienlist = ""
    
    var mlist:[(String,String)] = [("","")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 设置导航栏
        self.navigationItem.title = "药方"
        self.navigationController?.navigationBar.barTintColor = UIColor(red:255/255,green:60/255,blue:40/255 ,alpha:1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        strAnalysis()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mlist.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        /// 定义cell
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cellId")
        // 读取数据
        let title = mlist[indexPath.row].0
        let value = mlist[indexPath.row].1
        
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = value
        
        return cell

    }

    //解析字符串
    
    func strAnalysis() {
        
        mlist.removeAll()
        
        var myindex = 1
        var namestar = 0
        var nameend = 0
        var weightstar = 1
        var weightend = 1
      
        
        
        for index in medicienlist.characters.indices{
            
            if medicienlist[index] == "#" && myindex != 1 {

                var new = ("","")
                weightend = myindex - 1
                
                let d1 = nameend - namestar
                let d2 = weightend - weightstar
                let str = medicienlist as NSString
                
                new.1 = str.substring(with: NSMakeRange(weightstar, d2))
                
                switch str.substring(with: NSMakeRange(namestar, d1)){
                case "Heshouwu":
                    new.0 = "何首乌"
                case "Dongchongxiacao":
                    new.0 = "冬虫夏草"
                case "Renshen":
                    new.0 = "人参"
                case "Danggui":
                    new.0 = "当归"
                default:
                    new.0 = "未解析"
                }

                
                mlist.append(new)
                
                //新一轮
                namestar = myindex

            }
            
            if medicienlist[index] == "@" {
                
                nameend = myindex - 1
                weightstar = myindex
            }
            
            myindex = myindex + 1
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
