//
//  UIImage+LPK.swift
//  LPIM
//
//  Created by lipeng on 2017/6/23.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import UIKit
import CoreGraphics

extension UIImage {
    
    class func lp_image(named: String) -> UIImage? {
        let namePath = "\(LPKKit.shared.resourceBundleName)/\(named)"
        let image = UIImage(named: namePath)
        return image ?? UIImage(named: named)
    }
    
    class func lp_emoticon(named: String) -> UIImage? {
        let namePath = "\(LPKKit.shared.emoticonBundleName)/\(named)"
        let image = UIImage(named: namePath)
        return image ?? UIImage(named: named)
    }
    
    class func lp_fetchEmoticon(namedOrPath: String) -> UIImage? {
        var image = UIImage.lp_emoticon(named: namedOrPath)
        if image == nil {
            image = UIImage(contentsOfFile: namedOrPath)
        }
        return image
    }
    
    class func lp_fetchChartlet(named: String, chartletId: String) -> UIImage? {
        if chartletId == LPK_EmojiCatalog {
            return UIImage(named: named)
        }
        
        let subDirectory = "\(LPK_ChartletChartletCatalogPath)/\(chartletId)/\(LPK_ChartletChartletCatalogContentPath)"
        /// 先拿2倍图
        let doubleImage = "\(named)@2x"
        let tribleImage = "\(named)@3x"
        let bundlePath = Bundle.main.bundlePath + "/\(subDirectory)"
        
        var path: String? = nil
        let array = Bundle.paths(forResourcesOfType: nil, inDirectory: bundlePath)
        if let first = array.first {
            let fileExt = ((first as NSString).lastPathComponent as NSString).pathExtension
            if UIScreen.main.scale == 3.0 {
                path = Bundle.path(forResource: tribleImage, ofType: fileExt, inDirectory: bundlePath)
            }
            
            path = path ?? Bundle.path(forResource: doubleImage, ofType: fileExt, inDirectory: bundlePath) //取二倍图
            path = path ?? Bundle.path(forResource: named, ofType: fileExt, inDirectory: bundlePath) //实在没了就去取一倍图
            if let path = path {
                return UIImage(contentsOfFile: path)
            }
        }
        return nil
    }
    
    class func lp_size(withImageOriginSize originSize: CGSize, minSize: CGSize, maxSize: CGSize) -> CGSize {
        var size: CGSize = .zero
        let imgWidth = originSize.width
        let imgHeight = originSize.height
        let imgMinWidth = minSize.width
        let imgMinHeight = minSize.height
        let imgMaxWidth = maxSize.width
        let imgMaxHeight = maxSize.height
        
        if imgWidth > imgHeight { //宽图
            size.height = imgMinHeight  //高度取最小高度
            size.width = imgWidth * imgMinHeight / imgHeight
            if size.width > imgMaxWidth {
                size.width = imgMaxWidth
            }
        } else if imgWidth < imgHeight { //高图
            size.width = imgMinWidth
            size.height = imgHeight * imgMinWidth / imgWidth
            if size.height > imgMaxHeight {
                size.height = imgMaxHeight
            }
        } else { //方图
            if imgWidth > imgMaxWidth {
                size.width = imgMaxWidth
                size.height = imgMaxHeight
            } else if imgWidth > imgMinWidth {
                size.width = imgWidth
                size.height = imgHeight
            } else {
                size.width = imgMinWidth
                size.height = imgMinHeight
            }
        }
        return size
    }
    
    func lp_imageForAvatarUpload() -> UIImage? {
        let pixels = LPKDevice.shared.suggestImagePixels
        let image = lp_imageForUpload(pixels)
        return image?.lp_fixOrientation()
    }
    
    // MARK: - Private
    
    private func lp_imageForUpload(_ suggestPixels: CGFloat) -> UIImage? {
        let maxPixels: CGFloat = 4000000.0
        let maxRatio: CGFloat = 3.0
        let width = size.width
        let height = size.height
        
        /// 对于超过建议像素，且长宽比超过max ratio的图做特殊处理
        if width * height > suggestPixels && (width / height > maxRatio || height / width > maxRatio) {
            return lp_scale(withMaxPixels: maxPixels)
        }
        return lp_scale(withMaxPixels: suggestPixels)
    }
    
    private func lp_scale(withMaxPixels maxPixels: CGFloat) -> UIImage? {
        let width  = size.width
        let height = size.height
        
        if width * height < maxPixels || maxPixels == 0 {
            return self
        }
        
        let ratio = sqrt(width * height / maxPixels)
        if fabs(ratio - 1) <= 0.01 {
            return self
        }
        
        let newSizeWidth  = width / ratio
        let newSizeHeight = height / ratio
        return lp_scale(to: CGSize(width: newSizeWidth, height: newSizeHeight))
    }
    
    /// 内缩放，一条变等于最长边，另外一条小于等于最长边
    private func lp_scale(to newSize: CGSize) -> UIImage? {
        let width  = size.width
        let height = size.height
        let newSizeWidth  = newSize.width
        let newSizeHeight = newSize.height
        
        if width <= newSizeWidth && height <= newSizeHeight {
            return self
        }
        if width == 0 || height == 0 || newSizeHeight == 0 || newSizeWidth == 0 {
            return nil
        }
        
        var s: CGSize
        if width / height > newSizeWidth / newSizeHeight {
            s = CGSize(width: newSizeWidth, height: newSizeWidth * height / width)
        } else {
            s = CGSize(width: newSizeHeight * width / height, height: newSizeHeight)
        }
        return lp_drawImage(with: s)
    }
    
    private func lp_drawImage(with size: CGSize) -> UIImage? {
        let drawSize = CGSize(width: floor(size.width), height: floor(size.height))
        UIGraphicsBeginImageContext(drawSize)
        draw(in: CGRect(origin: .zero, size: drawSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private func lp_fixOrientation() -> UIImage {
        // No-op if the orientation is already correct
        if imageOrientation == .up {
            return self
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform = CGAffineTransform.identity
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -CGFloat.pi / 2.0)
        default:
            break
        }
        
        switch imageOrientation {
        case .up, .upMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }

        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        guard let cgImage = cgImage, let colorSpace = cgImage.colorSpace else { return self }
        guard let ctx = CGContext(data: nil,
                                  width: Int(size.width),
                                  height: Int(size.height),
                                  bitsPerComponent: cgImage.bitsPerComponent,
                                  bytesPerRow: 0,
                                  space: colorSpace,
                                  bitmapInfo: cgImage.bitmapInfo.rawValue) else { return self }
        
        ctx.concatenate(transform)
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            // Grr...
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        }
        
        // And now we just create a new UIImage from the drawing context
        guard let cgimage = ctx.makeImage() else { return self }
        return UIImage(cgImage: cgimage)
    }
}
