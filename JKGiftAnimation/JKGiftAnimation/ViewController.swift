//
//  ViewController.swift
//  JKGiftAnimation
//
//  Created by 王冲 on 2020/7/31.
//  Copyright © 2020 王冲. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var count: Int = 0
    
    var giftContainerView: JKGiftContainerView = JKGiftContainerView()
    
    /// 贵重礼物
    @IBOutlet weak var preciousGifImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        giftContainerView.frame = CGRect(x: 0, y: 100, width: 250, height: 100)
        giftContainerView.backgroundColor = .gray
        view.addSubview(giftContainerView)
    }

    @IBAction func gift1Click(_ sender: Any) {
    
        let model = JKGiftModel()
        model.senderName = "刘备"
        model.senderURL = "http://image.huajiao.com/11b2b33bafd02482edc18f9d42bb3d3d-100_100.jpg"
        model.giftName = "梦幻木马"
        model.giftURL = "https://img.sumeme.com/15/7/1593499283855.png"
        giftContainerView.showGiftModel(model)
    }
    
    
    @IBAction func gift2Click(_ sender: Any) {
        let model = JKGiftModel()
        model.senderName = "曹操"
        model.senderURL = "https://img.sumeme.com/26/2/1527749026394.jpg"
        model.giftName = "战靴"
        model.giftURL = "https://img.sumeme.com/26/2/1527749026394.jpg"
        giftContainerView.showGiftModel(model)
    }

    @IBAction func gift3Click(_ sender: Any) {
        let model = JKGiftModel()
        model.senderName = "吕布"
        model.senderURL = "https://img.sumeme.com/50/2/1557387849586.png"
        model.giftName = "鲜花"
        model.giftURL = "https://img.sumeme.com/50/2/1557387849586.png"
        giftContainerView.showGiftModel(model)
        
    }
    
    @IBAction func gift4Click(_ sender: Any) {
        preciousGifImageView.loadGifAnimation(url: "https://img.sumeme.com/52/4/1557810610676.gif")
    }
}

