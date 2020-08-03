//
//  JKGiftModel.swift
//  礼物动画
//
//  Created by 王冲 on 2020/7/31.
//  Copyright © 2020 王冲. All rights reserved.
//

import UIKit
import ObjectMapper
class JKGiftModel: NSObject, Mappable {
    /// 送礼物人的名字
    var senderName: String = ""
    /// 送礼物人的图片
    var senderURL: String = ""
    /// 礼物的名字
    var giftName: String = ""
    /// 礼物的图片
    var giftURL: String = ""
    
    // MARK: - Mappable
    func mapping(map: Map) {
        senderName <- map["senderName"]
        senderURL <- map["senderURL"]
        giftName <- map["giftName"]
        giftURL <- map["giftURL"]
    }
    required init?(map: Map) {}
    override init() {
        super.init()
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? JKGiftModel else {
            return false
        }
        
        guard object.giftName == giftName && object.senderName == senderName else {
            return false
        }
        
        return true
    }
}

