//
//  DoctorQR.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/7/12.
//  Copyright © 2017年 NMID. All rights reserved.
//

import Foundation
import RealmSwift

class DoctorQR: Object {
    
    //用户属性
    dynamic var DoctorID: String!
    dynamic var DoctorQRImage: NSData!
    
    //主键
    override class func primaryKey() -> String? {
        return "DoctorID"
    }

}
