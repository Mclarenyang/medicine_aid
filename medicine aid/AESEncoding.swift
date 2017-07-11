//
//  AESEncoding.swift
//  medicine aid
//
//  Created by nexuslink mac 2 on 2017/7/11.
//  Copyright © 2017年 NMID. All rights reserved.
//

import Foundation
import CryptoSwift

//解密状态码枚举
enum typeCode{
    
    case nickName, phoneNumber, passWord
    
}

class AESEncoding: NSObject {
    
    //AES-ECB加密
    static func Endcode_AES_ECB(strToEncode:String, typeCode: typeCode)->String
    {
        
        //-----------加密算法--------------//
        //密钥字符串(字符串 1)进行 MD5 加密后，得到一组新的字符串(字符串 2)
        //将字符串 2 打散成为 byte 数组，并用此数组对需要加密的字符串(字符串 3)进行 AES 加密，得到加密字符串(字符串 4)
        
        var key: String!
        //密钥字符串
        switch typeCode {
        case .nickName:
             key = "nmid.igds.nick_name"
        case .phoneNumber:
             key = "nmid.igds.phone_number"
        case .passWord:
             key = "nmid.igds.password"
        }
        
        //md5加密
        let hash = key.md5()
        
        //打散称为Byte
        let byteKey = Array<UInt8>(hex: hash)
        let iv:[UInt8] = []
        
        var encrypted :[UInt8]!
        //加密
        do{
            
            let aes = try AES(key: byteKey, iv: iv, blockMode: .ECB, padding: PKCS7())
            let ps = strToEncode.data(using: String.Encoding.utf8)
            encrypted = try aes.encrypt(ps!.bytes)
            
        }catch{
            
            print("加密错误")
            
        }
        
        //16进制
        let encode = encrypted.toHexString()

        return encode
    }
    
    
    //AES-ECB解密
    static func Decode_AES_ECB(strToDecode:String, typeCode:typeCode)->String
    {
        //-----------解密算法--------------//
        //密钥字符串(字符串 1)进行 MD5 加密后，得到一组新的字符串(字符串 2)
        //将字符串 2 打散成为 byte 数组，并用此数组对需要解密的字符串(字符串 4)进行 AES 解密，得到解密字符串(字符串 3)
        
        //接收到的数据转成Byte数组
        let data = Array<UInt8>(hex: strToDecode)
        
        var key: String!
        //密钥字符串
        switch typeCode {
        case .nickName:
            key = "nmid.igds.nick_name"
        case .phoneNumber:
            key = "nmid.igds.phone_number"
        case .passWord:
            key = "nmid.igds.password"
        }

        //md5加密
        let hash = key.md5()
        
        //打散称为Byte
        let byteKey = Array<UInt8>(hex: hash)
        let iv:[UInt8] = []
        
        //解密
        var decrypted :[UInt8]!
        
        do{
            
        decrypted = try AES(key: byteKey, iv: iv, blockMode: .ECB, padding: PKCS7()).decrypt(data)
        
        }catch{
        
            print("解密错误")
        }
        
        //转码
        let dataStr = NSData(bytes: decrypted, length: decrypted.count)
        let str = String(data: dataStr as Data, encoding: String.Encoding.utf8)!
        
        return str
    }
    
    
    
}
