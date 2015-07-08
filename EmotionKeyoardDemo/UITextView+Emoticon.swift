//
//  UITextView+Emoticon.swift
//  EmotionKeyoardDemo
//
//  Created by cxc on 15/7/8.
//  Copyright © 2015年 rockcxc. All rights reserved.
//

import UIKit

extension UITextView {
    func insertEmoticon(emoticon:Emoticon){
        /**
        *  emoji
        */
        if emoticon.emoji != nil{
            replaceRange(selectedTextRange!, withText: emoticon.emoji ?? "")
        }
        /**
        *  图片表情
        */
        if emoticon.chs != nil{
           // 生成一个属性文本，字体已经设置
            let imageText = EmoticonAttachment.emoticonString(emoticon, font: font!)
            // 获得文本框完整的属性文本
            let strM = NSMutableAttributedString(attributedString: attributedText)
            strM.replaceCharactersInRange(selectedRange, withAttributedString: imageText)
            
            // 将属性文本重新设置给 textView
            let range = selectedRange
            attributedText = strM
            selectedRange = NSMakeRange(range.location+1, 0)
        }
    }
    /**
    :returns: textView 完整的表情字符窜
    */
    func emoticonText() -> String{
        var strM = String()
        
        //遍历内部细节
        attributedText.enumerateAttributesInRange(NSMakeRange(0, attributedText.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (dict, range, _) -> Void in
            if let attachment = dict["NSAttachment"] as? EmoticonAttachment{
                strM += attachment.chs ?? ""
            } else{
                let str = (self.attributedText.string as NSString).substringWithRange(range)
                strM += str
            }
        }
        return strM
    }
}
