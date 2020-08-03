//
//  JKGiftDigitLabel.swift
//  礼物动画
//
//  Created by 王冲 on 2020/7/31.
//  Copyright © 2020 王冲. All rights reserved.
//

import UIKit

class JKGiftDigitLabel: UILabel {

    // 画一个空心的，再次画，填充（实心的），好处就是可以自己定字体的粗细：
    override func drawText(in rect: CGRect) {
        
        // 1.获取上下文
        let context = UIGraphicsGetCurrentContext()
        // 2.给上下文线段设置一个宽度，通过该宽度画出文本
        // 画线的宽度
        context?.setLineWidth(5)
        // 画线的模式,round画出的线不是方正的，有圆角
        context?.setLineJoin(.round)
        // 画一个空心的
        context?.setTextDrawingMode(.stroke)
        // 设置颜色
        textColor = UIColor.orange
        // 把我们设置的文本画到 rect 里面
        super.drawText(in: rect)
        
        // 再次画，填充（实心的）
        context?.setTextDrawingMode(.fill)
        // 设置描边的色
        textColor = UIColor.white
        
        super.drawText(in: rect)
    }
    
    func showDigitAnimation(_ complection: @escaping () -> ()) {
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                // 放大
                self.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                // 缩小
                self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }
        }) { (isFinished) in
            /*
             usingSpringWithDamping: 阻力系数(0~1)，越小弹动越明显
             initialSpringVelocity: 初始化的速度
             options：刚开始快，还是刚开始慢
             */
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: [], animations: {
                // 弹动式恢复
                self.transform = CGAffineTransform.identity
            }) { (_) in
                complection()
            }
        }
    }
    
    /// 执行动画
    func showDigitAnimation1(_ complection: @escaping () -> ()) {
        UIView.animate(withDuration: 0.1, animations: {
            // 放大
            self.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                // 缩小
                self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }) { (_) in
                /*
                 usingSpringWithDamping: 阻力系数(0~1)，越小弹动越明显
                 initialSpringVelocity: 初始化的速度
                 options：刚开始快，还是刚开始慢
                 */
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: [], animations: {
                    // 弹动式恢复
                    self.transform = CGAffineTransform.identity
                }) { (_) in
                    complection()
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
