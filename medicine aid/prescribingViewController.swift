
//
//  prescribingViewController.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/5/13.
//  Copyright © 2017年 NMID. All rights reserved.
//

import UIKit
import TextFieldEffects
import CocoaAsyncSocket

class prescribingViewController: UIViewController,UISearchBarDelegate,GCDAsyncSocketDelegate{

    var clientSocket:GCDAsyncSocket!
    // 预设IP地址
    //let beforeIP = "113.250.152.75"
    let beforeIP = "192.168.2.141"
    let beforePort = UInt16(5566)
    
    
    // 屏幕信息
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // 药材信息输入
    var MedicineName = HoshiTextField()
    var MedicineWeight = HoshiTextField()
    
    // 显示活动条目
    var showView = UIScrollView()
    var listHight = 0
    var viewTag = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置navigationbar标题
        self.navigationItem.title = "开药"
        
        /// 设置背景
        let bgView = UIView(frame:UIScreen.main.bounds)
        bgView.backgroundColor = UIColor.gray
        self.view.addSubview(bgView)
        
        /// 顶部info
        let infoView = UIView(frame: CGRect(x:0,y:64,width:screenWidth,height:screenHeight/5))
        infoView.backgroundColor = UIColor.white
        bgView.addSubview(infoView)
        // 设置头像
        let HeadIamge = UIImageView(frame:CGRect(x:screenWidth*8/12,y:screenHeight/10-45,width:90,height:90))
        HeadIamge.image = UIImage(named:"head") //读取处理
        HeadIamge.layer.masksToBounds = true
        HeadIamge.layer.cornerRadius = 45
        infoView.addSubview(HeadIamge)
        
        /// 设置添加药方view
        let addBgView = UIView(frame: CGRect(x:0,y:screenHeight/5 + 69 ,width:screenWidth,height:screenHeight*4/5))
        addBgView.backgroundColor = UIColor.white
        self.view.addSubview(addBgView)
        
        // 显示窗口
        showView = UIScrollView(frame: CGRect(x:0,y:50 ,width:screenWidth,height:screenHeight*4/5))
        addBgView.addSubview(showView)
        
        
        // 设置输入框
        MedicineName = HoshiTextField(frame:CGRect(x:0, y:0, width:(screenWidth - 40)/2, height:50))
        MedicineName.placeholder = "名称"
        MedicineName.borderActiveColor = UIColor(red:255/255,green:60/255,blue:40/255 ,alpha: 1)
        MedicineName.autocorrectionType = UITextAutocorrectionType.no
        MedicineName.returnKeyType = UIReturnKeyType.next
        MedicineName.clearButtonMode = UITextFieldViewMode.whileEditing
        MedicineName.keyboardAppearance = UIKeyboardAppearance.light
        addBgView.addSubview(MedicineName)
        //
        MedicineWeight = HoshiTextField(frame:CGRect(x:(screenWidth - 40)/2, y:0, width:(screenWidth - 40)/2, height:50))
        MedicineWeight.placeholder = "重量(g)"
        MedicineWeight.borderActiveColor = UIColor(red:255/255,green:60/255,blue:40/255 ,alpha: 1)
        MedicineWeight.autocorrectionType = UITextAutocorrectionType.no
        MedicineWeight.returnKeyType = UIReturnKeyType.next
        MedicineWeight.clearButtonMode = UITextFieldViewMode.whileEditing
        MedicineWeight.keyboardType = UIKeyboardType.phonePad
        MedicineWeight.keyboardAppearance = UIKeyboardAppearance.light
        addBgView.addSubview(MedicineWeight)
        
        
        // 设置添加按钮
        let addBtn = UIButton(frame:CGRect(x:screenWidth - 30, y:20, width:20, height:20))
        addBtn.setBackgroundImage(UIImage(named:"Add"), for: UIControlState.normal)
        addBtn.addTarget(self, action: #selector(addBtnTap(_:)), for: UIControlEvents.touchUpInside)
        addBgView.addSubview(addBtn)
        
        // 设置确定发送按钮
        let DoneBtn = UIButton(frame: CGRect(x:80,y:screenHeight*3/7+70,width:screenWidth-165,height:55))
        DoneBtn.setBackgroundImage(UIImage(named:"register_done_bt"), for: UIControlState.normal)
        DoneBtn.addTarget(self, action: #selector(DoneBtn(_:)), for: .touchUpInside)
        addBgView.addSubview(DoneBtn)
        
        
        // 链接
        TCPLink(IPAddr: beforeIP, serverPort: beforePort)
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 按钮事件(添加药物条目)
    func addBtnTap(_ button:UIButton){
        
        let medicalList = medicalListView(frame:CGRect(x:5, y:listHight, width: Int(screenWidth - 5) , height:50))
        medicalList.tag = viewTag
        
        medicalList.addSubview(medicalList.medicineName)
        medicalList.addSubview(medicalList.medicineWeight)
        medicalList.backgroundColor = UIColor(patternImage:medicalList.image!)
        medicalList.deleteBtn.setBackgroundImage(UIImage(named:"deleteBtn"), for: .normal)
        medicalList.deleteBtn.tag = viewTag //绑定按钮
        medicalList.deleteBtn.addTarget(self, action: #selector(deleteMedicineList(sender:)), for: .touchUpInside)
        medicalList.addSubview(medicalList.deleteBtn)
        showView.addSubview(medicalList)
        
        
        medicalList.medicineName.text = self.MedicineName.text
        medicalList.medicineWeight.text = self.MedicineWeight.text
        
        //更新事件
        self.MedicineName.text = ""
        self.MedicineWeight.text = ""
        viewTag = viewTag + 1
        listHight = listHight + 50
        
        //删除光标
        MedicineName.resignFirstResponder()
        MedicineWeight.resignFirstResponder()
        
    }
    
    //删除药物列表
    func deleteMedicineList(sender:UIButton?){
        
      let btnTag = sender?.tag

        let maView = view.viewWithTag(btnTag!) as! medicalListView
        maView.removeFromSuperview()
        
        guard btnTag! < viewTag - 1 else {
            
            listHight = listHight - 50
            viewTag = viewTag - 1
            
            return
        }
        
        //删除后的位置处理
        for mytag in (btnTag!+1)...viewTag-1{
           
            let nowView = view.viewWithTag(mytag) as! medicalListView
            
            nowView.tag = mytag - 1
            nowView.deleteBtn.tag = mytag - 1
            //视图位置上移
            nowView.frame = CGRect(x:5, y:Int(nowView.frame.minY - 50), width: Int(screenWidth - 5) , height:50)
        
        }
        
        listHight = listHight - 50
        viewTag = viewTag - 1
    }

    // TCP链接
    func TCPLink(IPAddr: String,serverPort: UInt16){
        // 设置IP地址 IPAddr
        // 设置端口号 serverPort
        clientSocket = GCDAsyncSocket()
        clientSocket.delegate = self
        clientSocket.delegateQueue = DispatchQueue.global()
        do {
            try clientSocket.connect(toHost: IPAddr, onPort: serverPort)
        } catch {
            NSLog("连接失败")
        }
    }
    
    //链接成功
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        NSLog("链接成功")
        clientSocket.readData(withTimeout: -1, tag: 0)
        let alertController = UIAlertController(title: "连接成功",
                                                message: "与硬件设备链接成功", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // 断开链接操作
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) -> Void {
        NSLog("与服务器断开了连接")
        let alertController = UIAlertController(title: "连接断开",
                                                message: "请选择操作？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "重试", style: .default, handler: {
            action in
            NSLog("重新连接")
            self.TCPLink(IPAddr: self.beforeIP, serverPort: self.beforePort)
        })
        let changIpAction = UIAlertAction(title: "更换IP", style: .default, handler: {
            action in
            NSLog("跟换IP")
            self.changeIp()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        alertController.addAction(changIpAction)
        self.present(alertController, animated: true, completion: nil)
    }
    

    
    // 接收数据
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) -> Void {
        // 获取发来的数据，把 NSData 转 NSString
        let readClientDataString: NSString? = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
        NSLog("-Data Recv-")
        NSLog(readClientDataString as! String)
        
        // 处理请求，返回数据OK
        let serviceStr: NSMutableString = NSMutableString()
        serviceStr.append("OK\n")
        clientSocket.write(serviceStr.data(using: String.Encoding.utf8.rawValue)!, withTimeout: -1, tag: 0)
        
        // 每次读完数据后，都要调用一次监听数据的方法
        clientSocket.readData(withTimeout: -1, tag: 0)
    }
    
    // 确定按钮
    func DoneBtn(_ button:UIButton){
        
        let serviceStr: NSMutableString = NSMutableString()
        serviceStr.append("OPEN")
        //serviceStr.append("\n")
        clientSocket.write(serviceStr.data(using: String.Encoding.utf8.rawValue)!, withTimeout: -1, tag: 0)
        clientSocket.readData(withTimeout: -1, tag: 0)
    }
    
    // 设置另一个弹窗
    func changeIp(){
        
        let alertController = UIAlertController(title: "重设链接",
                                                message: "请输入IP地址和端口号", preferredStyle: .alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "IP地址"
            textField.text = self.beforeIP
        }
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "端口号"
            textField.text = String(self.beforePort)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "链接", style: .default, handler: {
            action in
            //获取textField let login = alertController.textFields![0]
            let newIP = alertController.textFields!.first!
            let newPort = alertController.textFields!.last!
            NSLog("用户名：\(newIP.text) 密码：\(newPort.text)")
            self.TCPLink(IPAddr: newIP.text!, serverPort: UInt16(newPort.text!)! )
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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
