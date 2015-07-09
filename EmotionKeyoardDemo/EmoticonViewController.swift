//
//  EmoticonViewController.swift
//  EmotionKeyoardDemo
//
//  Created by cxc on 15/7/8.
//  Copyright © 2015年 rockcxc. All rights reserved.
//

import UIKit
/// 可重用表情符
private let CCEmoticonKeyboardIdentifier = "CCEmoticonKeyboardIdentifier"

class EmoticonViewController: UIViewController {
    /**
    *  选中表情的回调
    */
    var didSelectedEmoticonCallBack: (emoticon:Emoticon) -> ()
    init(didSelectedEmoticon:(emoticon:Emoticon) ->()){
        // 记录闭包
        didSelectedEmoticonCallBack = didSelectedEmoticon
        super.init(nibName: nil, bundle: nil)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    *  选中表情分组
    */
    func selectItem(item:UIBarButtonItem){
        let indexPath = NSIndexPath(forItem: 0, inSection: item.tag)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
    }
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.redColor()
        prepareUI()
    }
    private func prepareUI(){
        view.addSubview(toolBar)
        view.addSubview(collectionView)
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        let viewDict = ["collectionView":collectionView,"toolBar":toolBar]
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolBar]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-[toolBar(44)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        view.addConstraints(cons)
        prepareToolBar()
        prepareCollectionView()
    }
    private func prepareCollectionView(){
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.pagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.registerClass(EmoticonCell.self, forCellWithReuseIdentifier: CCEmoticonKeyboardIdentifier)
    }
    private func prepareToolBar(){
        toolBar.tintColor = UIColor.darkGrayColor()
        var items = [UIBarButtonItem]()
        
        var index = 0
        for s in packages{
            let item = UIBarButtonItem(title: s.groupName, style: UIBarButtonItemStyle.Plain, target: self, action: "selectItem:")
            item.tag = index++
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolBar.items = items
    }
    // MARK: - 懒加载
    private lazy var toolBar = UIToolbar()
    private lazy var collectionView:UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout:EmoticonLayout())
    
    // MARK: - 定义一个私有的布局类
    private class EmoticonLayout:UICollectionViewFlowLayout{
        // 在collectionView 大小设置完成之后，准备布局之前会调用一次
        private override func prepareLayout() {
            super.prepareLayout()
            let s = collectionView!.bounds.width/7
            itemSize = CGSize(width: s, height: s)
            minimumInteritemSpacing = 0
            minimumLineSpacing = 0
            
            let y = (collectionView!.bounds.height-3*s) * 0.45
            sectionInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
            scrollDirection = UICollectionViewScrollDirection.Horizontal
        }
    }
    /// 表情分组数据
    private lazy var packages:[EmoticonPackage] = EmoticonPackage.packages()
    
}

extension EmoticonViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return packages.count
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons?.count ?? 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CCEmoticonKeyboardIdentifier, forIndexPath: indexPath) as! EmoticonCell
        cell.emoticon = packages[indexPath.section].emoticons![indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let emoticon = packages[indexPath.section].emoticons![indexPath.item]
        
        if emoticon.chs != nil || emoticon.emoji != nil{
            emoticon.times++
            packages[0].addFavouriteEmoticon(emoticon)
        }
        didSelectedEmoticonCallBack(emoticon: emoticon)
    }
}

private class EmoticonCell:UICollectionViewCell {
    /**
    *  表情模型
    */
    var emoticon:Emoticon? {
        didSet{
            //设置图片 使用path只需要计算一次
            if let path = emoticon?.imagePath{
                emoticonButton.setImage(UIImage(contentsOfFile: path), forState: UIControlState.Normal)
            } else {
                emoticonButton.setImage(nil, forState: UIControlState.Normal)
            }
            
            emoticonButton.setTitle(emoticon!.emoji ?? "", forState: UIControlState.Normal)
            if emoticon!.removeButton{
                emoticonButton.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
                emoticonButton.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(emoticonButton)
        emoticonButton.frame = CGRectInset(bounds, 4, 4)
        emoticonButton.backgroundColor = UIColor.whiteColor()
        emoticonButton.titleLabel?.font = UIFont.systemFontOfSize(32)
        emoticonButton.userInteractionEnabled = false
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var emoticonButton = UIButton()
}
