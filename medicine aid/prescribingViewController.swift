
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
import Alamofire
import SwiftyJSON
import RealmSwift

class prescribingViewController: UIViewController,UISearchBarDelegate,GCDAsyncSocketDelegate{

    var clientSocket:GCDAsyncSocket!
    
    //存药方的str
    var medicalStr = ""
    
    // 预设IP地址
    let beforeIP = "113.251.223.3"
//    let beforeIP = "192.168.2.141"
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
    
    //信息栏(UesrID用于区分并从数据库读数据)
    var infoView = UIView()
    var HeadIamge = UIImageView()
    
    //ID
    var doctorId = ""
    var patientId = ""
    
    //info
    var nickname = ""
    var phonenumber = ""
    
    //载入滚动
    var loadingIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置navigationbar标题
        self.navigationItem.title = "开药"
        
        /// 设置背景
        let bgView = UIView(frame:UIScreen.main.bounds)
        bgView.backgroundColor = UIColor.gray
        self.view.addSubview(bgView)
        
        /// 顶部info
        infoView = UIView(frame: CGRect(x:0,y:64,width:screenWidth,height:screenHeight/5))
        infoView.backgroundColor = UIColor.white
        bgView.addSubview(infoView)
        infoBox()
        
        /// 设置添加药方view
        let addBgView = UIView(frame: CGRect(x:0,y:screenHeight/5 + 69 ,width:screenWidth,height:screenHeight*4/5))
        addBgView.backgroundColor = UIColor.white
        self.view.addSubview(addBgView)
        
        // 显示窗口
        showView = UIScrollView(frame: CGRect(x:0,y:50 ,width:screenWidth,height:screenHeight*4/5))
        addBgView.addSubview(showView)
        
        
        // 设置输入框
        MedicineName = HoshiTextField(frame:CGRect(x:5, y:0, width:(screenWidth - 40)/2-5, height:50))
        MedicineName.placeholder = "名称"
        MedicineName.borderActiveColor = UIColor(red:255/255,green:60/255,blue:40/255 ,alpha: 1)
        MedicineName.autocorrectionType = UITextAutocorrectionType.no
        MedicineName.returnKeyType = UIReturnKeyType.next
        MedicineName.clearButtonMode = UITextFieldViewMode.whileEditing
        MedicineName.keyboardAppearance = UIKeyboardAppearance.light
        addBgView.addSubview(MedicineName)
        //
        MedicineWeight = HoshiTextField(frame:CGRect(x:(screenWidth - 40)/2-5, y:0, width:(screenWidth - 40)/2-5, height:50))
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
        
        
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 链接
        TCPLink(IPAddr: beforeIP, serverPort: beforePort)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func infoBox() {
        
        // 设置头像
        HeadIamge = UIImageView(frame:CGRect(x:screenWidth*8/12,y:screenHeight/10-45,width:90,height:90))
        HeadIamge.image = UIImage(named:"head") //读取处理
        HeadIamge.layer.masksToBounds = true
        HeadIamge.layer.cornerRadius = 45
        infoView.addSubview(HeadIamge)
        
        // 设置别的信息
        let patientname = UILabel(frame:CGRect(x:screenWidth*1/12,y:screenHeight/10-55,width:90,height:90))
        let patientSex = UILabel(frame:CGRect(x:screenWidth*4/12,y:screenHeight/10-55,width:90,height:90))
        let patientAge = UILabel(frame:CGRect(x:screenWidth*5/12,y:screenHeight/10-55,width:90,height:90))
        let patientTime = UILabel(frame:CGRect(x:screenWidth*1/12,y:screenHeight/10-25,width:200,height:70))
        patientTime.textColor = UIColor.gray
        
        infoView.addSubview(patientname)
        infoView.addSubview(patientSex)
        infoView.addSubview(patientAge)
        infoView.addSubview(patientTime)
        
        //测试设置
        patientname.text = nickname
        patientSex.text = ""
        patientAge.text = ""
        patientTime.text = "患者电话：\(phonenumber)"
        
        
    }
    
    
    
    // 按钮事件(添加药物条目)
    func addBtnTap(_ button:UIButton){
        
        //判断是否为空
        if self.MedicineName.text == "" || self.MedicineWeight.text == ""{
        
        }else{
        
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
            try clientSocket.connect(toHost: IPAddr, onPort: serverPort, withTimeout: TimeInterval(0.3))
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
        
        if readClientDataString == nil {
            
            NSLog("error:接收到空字符")
            
        }else{
            
            NSLog(readClientDataString as! String)
            
        }
        // 处理请求，返回数据OK
        let serviceStr: NSMutableString = NSMutableString()
        serviceStr.append("OK\n")
        clientSocket.write(serviceStr.data(using: String.Encoding.utf8.rawValue)!, withTimeout: -1, tag: 0)
        
        // 每次读完数据后，都要调用一次监听数据的方法
        clientSocket.readData(withTimeout: -1, tag: 0)
    }
    
    
    // 确定按钮
    func DoneBtn(_ button:UIButton){
        
        //判断是不是空操作
        guard viewTag-1 != 0 else {
            return
        }
        
        //判读是不是输入错误
        let InPutbool = scanIn()
        guard InPutbool == true else{
            
            let alert = UIAlertController(title: "警告", message: "输入错误", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好", style: .cancel, handler: {
                _ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            
            return
        
        }
        
        let serviceStr: NSMutableString = NSMutableString()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
        //获取数据
        for index in 1...self.viewTag - 1{
            
            let data = self.dataFlow(index: index)
            serviceStr.append(data)
            
        
            self.clientSocket.write(serviceStr.data(using: String.Encoding.utf8.rawValue)!, withTimeout: -1, tag: 0)
            self.clientSocket.readData(withTimeout: -1, tag: 0)
               
    
            print("发送:\(data)")
            sleep(1)
        
            }
        
        }
        //断开链接
        //cancelPatient()
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
    
    // 读取最终数据
    func dataFlow(index:Int) -> String {
        
        var data = ""
        
        
            let list = view.viewWithTag(index) as! medicalListView
            
            var tag = ""
            
            switch list.medicineName.text! {
            case "Heshouwu":
                tag = "a"
            case "Dongchongxiacao":
                tag = "b"
            case "Renshen":
                tag = "c"
            case "Danggui":
                tag = "d"
            default:
                print("输入错误")
            }
            
            data = tag + list.medicineWeight.text! + "g"
        
        return data
    }
    
    //扫描是否输入错误
    func scanIn() -> Bool{
        
        var bool : Bool = true
        
        for index in 1...viewTag-1 {
            
            let list = view.viewWithTag(index) as! medicalListView
            
            switch list.medicineName.text! {
            case "Heshouwu":
                print("输入a")
            case "Dongchongxiacao":
                print("输入b")
            case "Renshen":
                print("输入c")
            case "Danggui":
                print("输入d")
            default:
                bool = false
                
            }
        
        }
        
        return bool
    }
    
    //断开患者
      func cancelPatient() {
        
        ///在这里断开医生和患者链接
        let url = AESEncoding.myURL + "igds/app/link/cancle"
        let parameters:Parameters = [
            "doctorId": doctorId,
            "patientId": patientId
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
                    
                    let alert = UIAlertController(title: "提示", message: "提交成功", preferredStyle: .alert)
                    let doneAction = UIAlertAction(title: "好", style: .default, handler: {
                        action in
                        
                        //药方本地话
                        self.saveMedicalList()
                        
                        _ = self.navigationController?.popViewController(animated: true)
                        
                    })
                    
                    alert.addAction(doneAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    
                    let alert = UIAlertController(title: "Error", message: "提交失败", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "好", style: .cancel, handler: nil)
                    
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    //药方本地化
    func saveMedicalList(){
    
        //清空容器
        medicalStr = ""
        
        for index in 1...viewTag-1 {
            
            let list = view.viewWithTag(index) as! medicalListView
            medicalStr = medicalStr + list.medicineName.text! + "@" + list.medicineWeight.text! + "g" + "#"
        }
        
        //读取储存信息
        //ID
        let defaults = UserDefaults.standard
        let UserID =  String(describing: defaults.value(forKey: "UserID")!)
        
        //读Type
        let realm = try! Realm()
        let doctorNickname = realm.objects(UserText.self).filter("UserID = '\(UserID)'")[0].UserNickname
        
        //时间
        let now = Date()
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        print("当前日期时间：\(dformatter.string(from: now))")
        let time = dformatter.string(from: now)
        
        //存储
        let dprlist = DPRList()
        
        dprlist.DoctorID = UserID
        dprlist.PatientID = patientId
        dprlist.DocrorNickname = doctorNickname
        dprlist.PatientNickname = nickname
        dprlist.Time = time
        dprlist.MedicalList = medicalStr
        
        try! realm.write {
            realm.add(dprlist)
        }

    
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
