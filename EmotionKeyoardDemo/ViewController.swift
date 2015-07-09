//
//  ViewController.swift
//  EmotionKeyoardDemo
//
//  Created by cxc on 15/7/8.
//  Copyright © 2015年 rockcxc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // 如果调用函数，同样会有循环引用！
    private lazy var emoticonKeyboardVC: EmoticonViewController = EmoticonViewController { [unowned self] (emoticon)  in
        
        self.textView.insertEmoticon(emoticon)
    }
    
 
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func emotionText(sender: AnyObject) {
        print("最终结果 \(textView.emoticonText())")
    }

    
    deinit {
        print("88")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let array = EmoticonPackage.packages()
        for p in array {
            print("\(p.groupName) \(p.emoticons?.count)")
        }
        
        // 1. 添加子控制器
        addChildViewController(emoticonKeyboardVC)
        // 2. 设置输入视图
        textView.inputView = emoticonKeyboardVC.view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

