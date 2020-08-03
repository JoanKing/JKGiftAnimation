//
//  UIImageView+Gif.swift
//  JKPlayGifAnimation
//
//  Created by 王冲 on 2020/8/3.
//  Copyright © 2020 王冲. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /// 加载本地的图片
    /// - Parameters:
    ///   - localGifName: 图片的名字
    ///   - playCount: 播放的次数
    ///   - isPlaceholder: 是否设置第一帧为占位图
    func loadGifAnimation(localGifName: String, playCount: Int = 1, isPlaceholder: Bool = false) {
        // 1.加载Gif图片, 并且转成Data类型
        guard let path = Bundle.main.path(forResource: "\(localGifName).gif", ofType: nil) else { return }
        guard let data = NSData(contentsOfFile: path) else { return }
        playGifAnimation(data: data, playCount: playCount, isPlaceholder: isPlaceholder)
    }
    
    /// 加载网络
    /// - Parameters:
    ///   - url: 图片的链接
    ///   - playCount: 播放的次数
    ///   - isPlaceholder: 是否设置第一帧为占位图
    func loadGifAnimation(url: String, playCount: Int = 1, isPlaceholder: Bool = false) {
        guard let imgUrl = URL(string: url) else {
            return
        }
        guard let imgData = try? Data(contentsOf: imgUrl) else {
            return
        }
        playGifAnimation(data: NSData(data: imgData), playCount: playCount, isPlaceholder: isPlaceholder)
    }
    
    private func playGifAnimation(data: NSData, playCount: Int = 1, isPlaceholder: Bool = false) {
        // 2.从data中读取数据: 将data转成CGImageSource对象
        guard let imageSource = CGImageSourceCreateWithData(data, nil) else { return }
        let imageCount = CGImageSourceGetCount(imageSource)
        // 3.便利所有的图片
        var images = [UIImage]()
        var totalDuration : TimeInterval = 0
        for i in 0..<imageCount {
            // 3.1.取出图片
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            let image = UIImage(cgImage: cgImage)
            if i == 0 && isPlaceholder {
                self.image = image
            }
            images.append(image)
            // 3.2.取出持续的时间
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? NSDictionary else { continue }
            guard let gifDict = properties[kCGImagePropertyGIFDictionary] as? NSDictionary else { continue }
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }
            totalDuration += frameDuration.doubleValue
        }
        // 4.设置imageView的属性
        self.animationImages = images
        self.animationDuration = totalDuration
        self.animationRepeatCount = 1
        // 5.开始播放
        self.startAnimating()
    }
}
