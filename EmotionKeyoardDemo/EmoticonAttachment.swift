//
//  EmoticonAttachment.swift
//  EmotionKeyoardDemo
//
//  Created by cxc on 15/7/8.
//  Copyright © 2015年 rockcxc. All rights reserved.
//

import UIKit

class EmoticonAttachment: NSTextAttachment {
    //表情文字
    var chs: String?
    
    // 使用表情模型，生成一个“属性字符窜”
    class func emoticonString(emoticon:Emoticon,font:UIFont) -> NSAttributedString {
        // 图片的附件
        let attachment = EmoticonAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.imagePath!)
        let s = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: s, height: s)
        
        // 生成一个属性文本
        let imageText = NSAttributedString(attachment: attachment)
        
        // 生成可变文本 - 设置字体
        let strM = NSMutableAttributedString(attributedString: imageText)
        strM.addAttributes([NSFontAttributeName:font], range: NSMakeRange(0, 1))
        return strM
    }
}
