//
//  UserTest.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/7/10.
//  Copyright © 2017年 NMID. All rights reserved.
//

import Foundation
import RealmSwift

class UserText :Object{
    
    //用户属性
    dynamic var UserID: String!
    dynamic var UserName: String!
    dynamic var UserNickname: String!
    dynamic var UserSex: String!
    dynamic var UserAge: String!
    dynamic var UserPhoneNum: String!
    dynamic var UserHeadImage: NSData!
    dynamic var UserType: String!
    
    //主键
    override class func primaryKey() -> String? {
        return "UserID"
    }
    
}
