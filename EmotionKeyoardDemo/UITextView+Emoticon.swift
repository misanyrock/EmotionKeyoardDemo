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
           // let imageText = EmoticonAtt
            // MARK: - TODO something
        }
    }
    
}
