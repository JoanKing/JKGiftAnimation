//
//  JKGiftChannelView.swift
//  礼物动画
//
//  Created by 王冲 on 2020/7/31.
//  Copyright © 2020 王冲. All rights reserved.
//

import UIKit
import Kingfisher
enum JKGiftChannelState {
    /// 空闲状态
    case idle
    /// 正在执行动画的状态
    case animating
    /// 将要结束的状态(等待是否还有礼物的3秒)
    case willEnd
    /// 正在执行消失的动画
    case endAnimating
}

class JKGiftChannelView: UIView {
    /// 背景视图
    var bgView: UIView!
    /// 头像
    var iconImageView: UIImageView!
    /// 发送礼物人的名字
    var senderLabel: UILabel!
    /// 送出礼物的描述
    var giftDescLabel: UILabel!
    /// 送出礼物的图片
    var giftImageView: UIImageView!
    /// 连击礼物的 Label
    var digitLabel: JKGiftDigitLabel!
    /// 缓存的数量
    var cacheNumber : Int = 0
    /// 当前的数量
    var currentNumber : Int = 0
    /// 礼物的状态
    var state : JKGiftChannelState = .idle
    /// 动画执行完的闭包
    var complectionCallBack: ((JKGiftChannelView) -> Void)?
    /// 礼物模型
    var model: JKGiftModel? {
        didSet {
            guard let model = model else {
               return
            }
            // 1.给控件设置信息
            iconImageView.kf.setImage(with: URL(string: model.giftURL), placeholder: UIImage(named: ""))
            senderLabel.text = model.senderName
            giftDescLabel.text = "送出礼物：[\(model.giftName)]"
            giftImageView.kf.setImage(with: URL(string: model.giftURL), placeholder: UIImage(named: ""))
            // 2.将 JKGiftChannelView 弹出
            state = .animating
            performAnimation()
        }
    }
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 对外提供的函数-(一个人同时送多个相同礼物)
extension JKGiftChannelView {
    func addOnceToCatch() {
        if state == .willEnd {
            performDigitAnimation()
            // 取消所有的 perform 方法，延时执行的方法被取消
            NSObject.cancelPreviousPerformRequests(withTarget: self)
        } else {
            // 
            cacheNumber += 1
        }
    }
}

// MARK:- 动画相关
extension JKGiftChannelView {
    // MARK: 执行动画
    /// 执行动画
    fileprivate func performAnimation() {
        
        self.digitLabel.alpha = 1.0
        self.digitLabel.text = " x1 "
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.frame.origin.x = 0
        }, completion: { isFinished in
            self.performDigitAnimation()
        })
    }
    // MARK: 展示多少礼物的动画
    /// 展示多少礼物的动画
    fileprivate func performDigitAnimation() {
        currentNumber += 1
        digitLabel.text = " x\(currentNumber) "
        digitLabel.showDigitAnimation {
            
            if self.cacheNumber > 0 {
                // 执行 +1 操作，递归调用
                self.cacheNumber -= 1
                self.performDigitAnimation()
            } else {
                self.state = .willEnd
                self.perform(#selector(self.performEndAnimation), with: nil, afterDelay: 3.0)
            }
            
        }
    }
    // MARK: 动画结束
    /// 动画结束
    @objc fileprivate func performEndAnimation() {
        
        state = .endAnimating
        
        UIView.animate(withDuration: 0.25, animations: {
            self.frame.origin.x = UIScreen.main.bounds.width
            self.alpha = 0.0
        }, completion: { isFinished in
            self.model = nil
            self.frame.origin.x = -self.frame.width
            self.state = .idle
            self.digitLabel.alpha = 0
            self.currentNumber = 0
            self.cacheNumber = 0
            if self.complectionCallBack != nil {
                // 告诉外界动画结束，可以去取缓存里面的动画了
                self.complectionCallBack!(self)
            }
        })
    }
}

// MARK:- UI布局
extension JKGiftChannelView {
    
    func initUI() {
        let imageW: CGFloat = self.bounds.height
        let bgViewW: CGFloat = imageW + 100 + imageW
      
        bgView = UIView(frame: CGRect(x: 0, y: 0, width: bgViewW, height: imageW))
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.47)
        bgView.layer.cornerRadius = frame.height * 0.5
        bgView.layer.masksToBounds = true
        addSubview(bgView)
        
        iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageW, height: imageW))
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.layer.cornerRadius = frame.height * 0.5
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = UIColor.green.cgColor
        addSubview(iconImageView)
        
        senderLabel = UILabel(frame: CGRect(x: imageW + 10, y: 5, width: 80, height: 18))
        senderLabel.font = UIFont.systemFont(ofSize: 16)
        senderLabel.textColor = .white
        senderLabel.textAlignment = .left
        addSubview(senderLabel)
        
        giftDescLabel = UILabel(frame: CGRect(x: imageW + 10, y: imageW - 17, width: 80, height: 14))
        giftDescLabel.font = UIFont.systemFont(ofSize: 12)
        giftDescLabel.textAlignment = .left
        giftDescLabel.textColor = .white
        giftDescLabel.adjustsFontSizeToFitWidth = true
        addSubview(giftDescLabel)
        
        giftImageView = UIImageView(frame: CGRect(x:bgView.frame.size.width - 37, y: bgView.frame.size.height / 2.0 - 12, width: 37, height: 24))
        giftImageView.contentMode = .scaleAspectFill
        addSubview(giftImageView)
        
        digitLabel = JKGiftDigitLabel(frame: CGRect(x: giftImageView.frame.maxX + 10, y: bgView.frame.size.height / 2.0 - 15, width: 40, height: 30))
        digitLabel.textAlignment = .left
        addSubview(digitLabel)
    }
    
    class func loadFromNib() -> JKGiftChannelView {
        return Bundle.main.loadNibNamed("JKGiftChannelView", owner: nil, options: nil)?.first as! JKGiftChannelView
    }
}
