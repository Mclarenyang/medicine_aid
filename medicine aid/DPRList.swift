//
//  DPRList.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/7/16.
//  Copyright © 2017年 NMID. All rights reserved.
//

import Foundation
import RealmSwift

class DPRList: Object {
    
    //条目属性
    dynamic var DoctorID: String!
    dynamic var DocrorNickname: String!
    
    dynamic var PatientID: String!
    dynamic var PatientNickname: String!
    
    dynamic var Time: String!
    
    dynamic var MedicalList:String!
    
    
}
