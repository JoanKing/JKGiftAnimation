//
//  JKGiftContainerView.swift
//  礼物动画
//
//  Created by 王冲 on 2020/7/31.
//  Copyright © 2020 王冲. All rights reserved.
//

import UIKit

private let kChannelCount = 2
private let kChannelViewH : CGFloat = 40
private let kChannelMargin : CGFloat = 10

class JKGiftContainerView: UIView {
    
    // MARK: 定义属性
    fileprivate lazy var channelViews : [JKGiftChannelView] = [JKGiftChannelView]()
    /// 缓存的model
    fileprivate lazy var cacheGiftModels : [JKGiftModel] = [JKGiftModel]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI界面
extension JKGiftContainerView {
    fileprivate func setupUI() {
        // 1.根据当前的渠道数，创建HYGiftChannelView
        let w : CGFloat = frame.width
        let h : CGFloat = kChannelViewH
        let x : CGFloat = 0
        for i in 0..<kChannelCount {
            let y : CGFloat = (h + kChannelMargin) * CGFloat(i)
            let channelView = JKGiftChannelView(frame: CGRect(x: x, y: y, width: w, height: h))
            channelView.alpha = 0.0
            channelView.complectionCallBack = { [weak self] (channelView) in
                guard let weakSelf = self else {
                    return
                }
                // 1.取出缓存模型
                guard weakSelf.cacheGiftModels.count != 0 else {
                    return
                }
                // 2.取出缓存的第一个模型
                let firstGiftModel = weakSelf.cacheGiftModels.first!
                weakSelf.cacheGiftModels.removeFirst()
                // 3.让空闲的模型执行动画
                channelView.model = firstGiftModel
                // 4.将数组中剩余有和firstGiftModel相同的模型放到 ChannelView 缓存中
                for i in (0..<weakSelf.cacheGiftModels.count).reversed() {
                    let giftModel = weakSelf.cacheGiftModels[i]
                    if giftModel.isEqual(firstGiftModel) {
                        channelView.addOnceToCatch()
                        self?.cacheGiftModels.remove(at: i)
                    }
                }
            }
            addSubview(channelView)
            channelViews.append(channelView)
        }
    }
}


extension JKGiftContainerView {
    
    /// 展示礼物
    /// - Parameter model: 对应的model
    func showGiftModel(_ giftModel: JKGiftModel) {
        // 1、判断正在忙的 ChanelView 和赠送的新礼物(username和giftname)
        if let channelView = checkUsingChanelView(giftModel) {
            // 礼物一样，且是同一个人
            channelView.addOnceToCatch()
            return
        }
        
        // 2.判断有没有空闲的 ChanelView
        if let channelView = checkIdleChannelView() {
            channelView.model = giftModel
            return
        }
        
        // 3.没有空闲的通道，就把模型放到缓存模型里面
        cacheGiftModels.append(giftModel)
    }
    
    /// 检查正在使用的
    /// - Parameter giftModel: 礼物模型
    /// - Returns: 返回礼物
    fileprivate func checkUsingChanelView(_ giftModel: JKGiftModel) -> JKGiftChannelView? {
        
        for channelView in channelViews {
            if giftModel.isEqual(channelView.model) && channelView.state != .endAnimating {
                return channelView
            }
        }
        return nil
    }
    
    func checkIdleChannelView() -> JKGiftChannelView? {
        for channelView in channelViews {
            if channelView.state == .idle {
                return channelView
            }
        }
        return nil
    }
}
