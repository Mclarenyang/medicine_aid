# medicine_aid
iOS client program and design diagram of National College Students Connected Smarter System Innovation Competition in 2017 

## 目录

---

1.概述

* 1.1 [项目概述](#项目描述)
* 1.2 [iOS客户端功能描述](#iOS客户端功能描述)

2.开发环境及技术实现

* 2.1 开发环境及运行环境
  * 2.1.1 [开发环境](#开发环境)
  * 2.1.2 [运行环境](#运行环境)
* 2.2 技术实现 
  * 2.2.1 [技术大纲](#技术大纲) 
  * 2.2.2 [建模技术](#建模技术)
  * 2.2.3 [Sketch](#Sketch)
  * 2.2.4 [Principle](#Principle)

---

## 1.概述
---
###  1.1 项目概述
<a name='项目概述'/>
&emsp;项目拟实现一个对于中小型中药药店的辅助系统，主要帮助零散在各个城市街道的中小型中药药店实现快速抓药，并且形成病人的信息整合，方便将全国中小型药店实现系统化、科技化的管理与运作。本项目中我作为iOS客户端开发人员，在此对iOS客户端所要完成的功能呢及其中所用到学到的技术进行描述。

### 1.2 iOS客户端功能描述
<a name='iOS客户端功能描述'/>
&emsp;从用户角度来看，iOS客户端负责与用户交互实现患者端的二维码扫描挂号排队、挂号查询、患者服药提醒、患者药方查询;并实现医生端的挂号处理、生成药方、药方查询、医生二维码生成;同时提供药材百科功能，实现药材生长样式环境、药材疗效及服药禁忌的展现;提供客户端修改个人信息的功能。
从系统角度来看，iOS客户端负责系统硬件及后台的对接，实现药方及个人信息同步到后台数据库、药方传递到系统硬件的功能。

---
## 2.开发环境及技术实现
---
### 2.1 开发环境及运行平台
#### 2.1.1 开发环境
<a name='开发环境'/>
&emsp;项目iOS客户端开发环境为：

* Xcode8开发平台
* sketch UI设计平台
* principle动效设计平台
* CocoaPods项目依赖管理平台
* swift 2.0开发语言

#### 2.1.2 运行环境
<a name='运行环境'/>
&emsp;项目iOS客户端可以实现运行的环境如下：

* 系统环境：iOS7.0+系统
* 硬件环境：
  * iPhone5以上机型
  * iPadmini2以上机型
  * 装有Simulator的Mac电脑

### 2.2 技术实现
#### 2.2.1 技术大纲
<a name='技术大纲'/>
&emsp;项目iOS客户端主要使用的技术实现有：

  * 界面交互
    * sketch - Principle搭配交互设计
    * iOS UIkit框架
    * TextFieldEffects（swift语言下文本框优化库）
  * 数据传输
    * CocoaAsyncSocket（iOS客户端TCP／IP请求协议封装库）
    * Alamofire（基于swift语言的iOS客户端Http协议网络请求库）
  * 数据处理
    * SwiftyJSON（swift语言Json格式数据解析库）
    * CryptoSwift加密编码库
  * 数据存储
    * RealmSwift（swift语言环境下文件型数据库存储库） 

#### 2.2.2 建模技术
<a name='建模技术'/>
&emsp;以下是客户端模块在运作情况下的建模流程图：

![IMAGE](https://github.com/Mclarenyang/medicine_aid/raw/master/resources/F4D2238FB546A5F2BAD4C356AB5300E7.jpg =554x160)

![IMAGE](https://github.com/Mclarenyang/medicine_aid/raw/master/resources/26A796D64988E74BC3C652A67FDEB116.jpg =554x194)

#### 2.2.3 Sketch
<a name='Sketch'/>
&emsp;项目iOS客户端采用Sketch作为设计平台对客户端平台的原型进行设计，最后形成的项目静态原型设计图如下：
  
* 图标及滚动页面
![IMAGE](https://github.com/Mclarenyang/medicine_aid/raw/master/resources/761490956AAFB7E0442F5F48353D64D1.jpg =844x115)

* 启动欢迎与登陆页面
![IMAGE](https://github.com/Mclarenyang/medicine_aid/raw/master/resources/906B1EA511A008E689D1610261F8C63C.jpg =719x564)

* 注册与排号就医页面
![IMAGE](https://github.com/Mclarenyang/medicine_aid/raw/master/resources/F10996AB7A46086D913353E511C23294.jpg =698x566)

* 主选项与药材百科查询页面
![IMAGE](https://github.com/Mclarenyang/medicine_aid/raw/master/resources/E226F55966B6C1B2F4D1A9734BFFC808.jpg =735x616)

* 个人信息中心与开药页面
![IMAGE](https://github.com/Mclarenyang/medicine_aid/raw/master/resources/FD457B20A109C64720FCBFD6B1558A54.jpg =745x593)

#### 2.2.4 Principle
<a name='Principle' />
&emsp;项目iOS客户端采用Principle作为动画效果设计平台对客户端平台的原型进行设计，最后形成的项目动态交互原型展示如下：

![principle.gif](https://github.com/Mclarenyang/medicine_aid/raw/master/resources/53214F8DDBAF4C2E9AACEC196A61C1AE.gif =800x600)
