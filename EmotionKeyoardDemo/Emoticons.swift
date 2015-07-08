//
//  Emoticons.swift
//  EmotionKeyoardDemo
//
//  Created by cxc on 15/7/8.
//  Copyright © 2015年 rockcxc. All rights reserved.
//

import UIKit
class EmoticonPackage: NSObject {
    var id: String?
    /// 分组名称
    var groupName: String?
    var emoticons: [Emoticon]?
    
    init(id:String) {
        self.id = id
    }
    
/// 添加喜爱的表情
    func addFavouriteEmoticon(emoticon: Emoticon){
        let contain = emoticons!.contains(emoticon)
        if !contain {
            emoticons?.append(emoticon)
        }
        var result = emoticons!
        result = result.sort{$0.times > $1.times}
        if !contain{
            result.removeLast()
        }
        
        emoticons = result
    }
    
    class func packages() -> [EmoticonPackage] {
        var list = [EmoticonPackage]()
        
        let p = EmoticonPackage(id: "")
        p.groupName = "最近"
        p.appendEmptyEmoticons()
        list.append(p)
        
        let path = NSBundle.mainBundle().pathForResource("emoticons.plist", ofType: nil, inDirectory: "Emoticons.boudle")!
        let dict = NSDictionary(contentsOfFile: path)!
        let array = dict["packages"] as! [[String:AnyObject]]
        
        // 遍历数组
        for d in array{
            let p = EmoticonPackage(id: d["id"] as! String)
            p.loadEmoticons()
            p.appendEmptyEmoticons()
            
            list.append(p)
        }
        return list
    }
    private func loadEmoticons() {
        let dict = NSDictionary(contentsOfFile: plistPath())!
        groupName = dict["group_name_cn"] as? String
        let array = dict["emoticons"] as! [[String:String]]
        
        emoticons = [Emoticon]()
        var index = 0
        for d in array {
            emoticons?.append(Emoticon(id: id, dict: d))
            index++
            if index == 20{
                emoticons?.append(Emoticon(isRemoveButton: true))
                index = 0
            }
        }
    }
    private func appendEmptyEmoticons(){
        if emoticons == nil{
            emoticons = [Emoticon]()
        }
        let count = emoticons!.count % 21
        if count>0 || emoticons!.count == 0{
            for _ in count..<20 {
                emoticons?.append(Emoticon(isRemoveButton: false))
            }
            emoticons?.append(Emoticon(isRemoveButton: true))
        }
    }
    /// 返回info.plist的路径
    private func plistPath() -> String{
        return EmoticonPackage.bundlePath().stringByAppendingPathComponent(id!).stringByAppendingPathComponent("info.plist")
    }
    
    /// 返回表情包路径
    private class func bundlePath() -> String {
        return NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent("Emoticons.bundle")
    }
}
class Emoticon: NSObject {
    var id: String?
    var chs: String?
    var png: String?
    var imagePath: String? {
        return png == nil ? nil : EmoticonPackage.bundlePath().stringByAppendingPathComponent(id!).stringByAppendingPathComponent(png!)
       
    }
    var code: String? {
        didSet{
            // 扫描器，可以扫描指定字符窜中特定的文字
            let scanner = NSScanner(string: code!)
            var result: UInt32 = 0
            scanner.scanHexInt(&result)
            
            // 生成字符窜：UNICODE字符窜 --》转化成字符窜
            emoji = "\(Character(UnicodeScalar(result)))"
        }
    }
    
    var emoji: String?
    // 是否删除按钮标记
    var removeButton = false
    //用户使用次数
    var times = 0
    
    init(isRemoveButton:Bool) {
        removeButton = isRemoveButton
    }
    
    init(id:String?,dict:[String:String]){
        super.init()
        self.id = id
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
