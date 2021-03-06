//
//  QRCodeViewController.swift
//  CodeScanner
//
//  Created by zhuxuhong on 2017/4/19.
//  Copyright © 2017年 zhuxuhong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class QRCodeViewController: UIViewController {
    
    
    static var QRResult = ""
    
    
    fileprivate lazy var topBar: UINavigationBar = {
        let bar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 64))
        bar.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        
        let item = UINavigationItem(title: "扫一扫")
        let leftBtn = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(QRCodeViewController.actionForBarButtonItemClicked(_:)))
        let rightBtn = UIBarButtonItem(title: "相册", style: .plain, target: self, action: #selector(QRCodeViewController.actionForBarButtonItemClicked(_:)))
        
        item.leftBarButtonItem = leftBtn
        item.rightBarButtonItem = rightBtn
        
        
        bar.items = [item]
        
        return bar
    }()
    
    fileprivate lazy var readerView: QRCodeReaderView = {
        let h = self.topBar.bounds.height
        let frame = CGRect(x: 0, y: h, width: self.view.bounds.width, height: self.view.bounds.height-h)
        let v = QRCodeReaderView(frame: frame)
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return v
    }()
    
    public var completion: QRCodeReaderCompletion?
    
    convenience init(completion: QRCodeReaderCompletion?) {
        self.init()
        self.completion = completion
        
    }
}

extension QRCodeViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBtn = UIBarButtonItem(title: "相册", style: .plain, target: self, action: #selector(QRCodeViewController.actionForBarButtonItemClicked(_:)))
        self.navigationItem.rightBarButtonItem = rightBtn
        
        //view.addSubview(topBar)
        
        if QRCodeReader.isDeviceAvailable() && !QRCodeReader.isCameraUseDenied(){
            setupReader()
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        guard QRCodeReader.isDeviceAvailable() else{
            let alert = UIAlertController(title: "Error", message: "相机无法使用", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好", style: .cancel, handler: {
                _ in
                self.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if QRCodeReader.isCameraUseDenied(){
            hanldeAlertForAuthorization(isCamera: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if QRCodeReader.isCameraUseAuthorized(){
            readerView.updateRectOfOutput()
        }
    }
    
    // MARK: - action & IBOutletAction
    @IBAction func actionForBarButtonItemClicked(_ sender: UIBarButtonItem){
        guard let item = topBar.items!.first else {
            return
        }
        if sender == item.leftBarButtonItem! {
            completionFor(result: nil, isCancel: true)
        }
        else if sender == self.navigationItem.rightBarButtonItem! {
            handleActionForImagePicker()
        }
    }
    
    fileprivate func completionFor(result: String?, isCancel: Bool){
        readerView.reader.stopScanning()
        
        dismiss(animated: true, completion: {
            isCancel ? nil : self.completion?(result ?? "没有发现任何信息")
        })
    }
}


extension QRCodeViewController{
    fileprivate func handleActionForImagePicker(){
        if QRCodeReader.isAlbumUseDenied() {
            hanldeAlertForAuthorization(isCamera: false)
            return
        }
        
        readerView.reader.stopScanning()
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        picker.allowsEditing = false
        
        present(picker, animated: true, completion: nil)
    }
    
    fileprivate func setupReader(){
        view.addSubview(readerView)
        
        readerView.setup(completion: {[unowned self]
            (result) in
            self.completionFor(result: result, isCancel: false)
        })
    }
    
    fileprivate func openSystemSettings(){
        let url = URL(string: UIApplicationOpenSettingsURLString)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    fileprivate func hanldeAlertForAuthorization(isCamera: Bool){
        let str = isCamera ? "相机" : "相册"
        let alert = UIAlertController(title: "\(str)没有授权", message: "在[设置]中找到应用，开启[允许访问\(str)]", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "去设置", style: .cancel, handler: { _ in
            self.openSystemSettings()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func handleQRCodeScanningFor(image: UIImage){
        let ciimage = CIImage(cgImage: image.cgImage!)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        if let features = detector?.features(in: ciimage),
            let first = features.first as? CIQRCodeFeature{
            self.completionFor(result: first.messageString, isCancel: false)
            
            ///相册扫描结果
            NSLog(first.messageString!)
            QRCodeViewController.QRResult = first.messageString!
            
            //ID
            let defaults = UserDefaults.standard
            let UserID = defaults.value(forKey: "UserID")!
            
            //直接链接
            //提示
            let alert = UIAlertController(title: "提示", message: "确定挂号排队?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let doneAction = UIAlertAction(title: "好", style: .default, handler: {
                action in
                
                let url = AESEncoding.myURL + "igds/app/link"
                
                let parameters: Parameters = [
                    "doctorId":first.messageString!,
                    "patientId":UserID
                ]
                
                
                Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
                    classValue in
                    
                    if let value = classValue.result.value{
                        
                        let json = JSON(value)
                        let code = json["code"]
                        
                        print("患者挂号code:\(code)")
                        
                        if code == 201{
                            
                            //挂号信息本地化
                            saveRegister(doctorID: first.messageString!)
                            
                            let queueView = queueViewController()
                            queueView.doctorID = first.messageString!
                            self.navigationController?.pushViewController(queueView, animated: true)
                            
                            //储存挂号医生的ID，用于已挂查询
                            let defaults = UserDefaults.standard
                            defaults.set(first.messageString!, forKey: "doctorID")
                            //更新挂号状态
                            defaults.set("yes", forKey: "status")
                            
                            
                        }else if code == 403{
                            
                            let alert = UIAlertController(title: "提示", message: "您已经挂号，请勿重复提交", preferredStyle: .alert)
                            let doneAction = UIAlertAction(title: "好", style: .default, handler:{
                                action in
                                
                                let queueView = queueViewController()
                                queueView.doctorID = first.messageString!
                                self.navigationController?.pushViewController(queueView, animated: true)
                                
                                
                            })
                            alert.addAction(doneAction)
                            self.present(alert, animated: true, completion: nil)
                            
                        }else{
                            
                            let alert = UIAlertController(title: "链接错误", message: "你可能扫了一个假的二维码", preferredStyle: .alert)
                            let doneAction = UIAlertAction(title: "好", style: .default, handler:{
                                action in
                                
                                _ = self.navigationController?.popViewController(animated: true)
                                
                            })
                            alert.addAction(doneAction)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            
            })
            
            alert.addAction(cancelAction)
            alert.addAction(doneAction)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}


//挂号本地化
func saveRegister(doctorID: String){

    //读取储存信息
    //ID
    let defaults = UserDefaults.standard
    let UserID =  String(describing: defaults.value(forKey: "UserID")!)
    
    //读Type
    let realm = try! Realm()
    let patientNickname = realm.objects(UserText.self).filter("UserID = '\(UserID)'")[0].UserNickname
    
    //时间
    let now = Date()
    let dformatter = DateFormatter()
    dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
    print("当前日期时间：\(dformatter.string(from: now))")
    let time = dformatter.string(from: now)
    
    //存储
    let dprlist = DPRList()
    
    dprlist.DoctorID = doctorID
    dprlist.PatientID = UserID
    //dprlist.DocrorNickname = doctorNickname
    dprlist.PatientNickname = patientNickname
    dprlist.Time = time
    //dprlist.MedicalList = medicalStr
    
    try! realm.write {
        realm.add(dprlist)
    }


}


extension QRCodeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
        readerView.reader.startScanning(completion: completion)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: {
                self.handleQRCodeScanningFor(image: image)
            })
        }
    }
}


extension QRCodeViewController{
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if QRCodeReader.isDeviceAvailable() && QRCodeReader.isCameraUseAuthorized() {
            readerView.updateRectOfOutput()
        }
    }
}
