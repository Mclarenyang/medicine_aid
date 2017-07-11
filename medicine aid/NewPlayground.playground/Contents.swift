//: Playground - noun: a place where people can play

import UIKit
import CryptoSwift

//-----------加密算法--------------//
//密钥字符串(字符串 1)进行 MD5 加密后，得到一组新的字符串(字符串 2)，将字符串 2 打散成为 byte 数组，并用此数组对需要加密的字符串(字符串 3)进行 AES 加密，得到加密字符串(字符串 4)


//密钥字符串
let key = "nmid.igds.nick_name"

//md5加密
let hash = key.md5()

//打散称为Byte
let byteKey = Array<UInt8>(hex: hash)
let iv:[UInt8] = []

//加密
let aes = try AES(key: byteKey, iv: iv, blockMode: .ECB, padding: PKCS7())
let ps = "testUserNickname".data(using: String.Encoding.utf8)
let encrypted = try aes.encrypt(ps!.bytes)

//16进制
let encode = encrypted.toHexString()


//-----------解密算法--------------//
//密钥字符串(字符串 1)进行 MD5 加密后，得到一组新的字符串(字符串 2)， 将字符串 2 打散成为 byte 数组，并用此数组对需要解密的字符串(字符串 4)进行 AES 解密，得到解密字符串(字符串 3)

//接收到的数据
let data = Array<UInt8>(hex: encode)

//解密
let decrypted = try AES(key: byteKey, iv: iv, blockMode: .ECB, padding: PKCS7()).decrypt(data)

//转码
let dataStr = NSData(bytes: decrypted, length: decrypted.count)
let str = String(data: dataStr as Data, encoding: String.Encoding.utf8)!
