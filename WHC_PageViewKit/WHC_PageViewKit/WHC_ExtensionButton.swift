//
//  WHC_ExtensionButton.swift
//  WHC_PageViewKit
//
//  Created by WHC on 16/11/13.
//  Copyright © 2016年 WHC. All rights reserved.
//
//  Github <https://github.com/netyouli/WHC_PageViewKit>

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

// VERSION:(1.0.1)

import UIKit

/// 按钮布局样式
enum UIButtonLayoutStyle: Int {
    /// 只有文字
    case Text
    /// 左文字右图片
    case Text_Image
    /// 右图片左文字
    case Image_Text
    /// 只有图片
    case Image
    /// 文字上图片下
    case Text_Top_Image_Bottom
    /// 图片上文字下
    case Image_Top_Text_Bottom
}

extension UIButton {
    
    private  struct HZButtonKey {
        static var kLayoutStyleKey = "kLayoutStyleKey"
        static var kTextImageMarginKey = "kTextImageMarginKey"
        static var kImageSizeKey = "kImageSizeKey"
    }
    
    func titleSize() -> CGSize {
        if self.currentTitle != nil {
            if self.currentAttributedTitle != nil {
                let drawingOptions = NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue)
                return (self.currentAttributedTitle?.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: drawingOptions, context: nil).size)!
            }else {
                let txt: NSString = NSString(cString: (self.currentTitle!.cString(using: String.Encoding.utf8))!,
                                             encoding: String.Encoding.utf8.rawValue)!;
                return txt.size(attributes: [NSFontAttributeName:(self.titleLabel?.font)!]);
            }
        }
        return CGSize.zero;
    }
    
    func getImageSize() -> CGSize {
        let image = self.image(for: .normal)
        if image != nil {
            return image!.size
        }
        return CGSize.zero
    }
    
    private func updateLayout() {
        var imageEdge = self.imageEdgeInsets
        var titleEdge = self.titleEdgeInsets
        switch layoutStyle {
        case .Image:
            break
        case .Text:
            break
        case .Image_Text:
            imageEdge.left = -textImageMargin / 2.0
            titleEdge.left = textImageMargin / 2.0
            titleEdge.right = -textImageMargin / 2.0
        case .Image_Top_Text_Bottom:
            let actualImageSize = self.getImageSize()
            var imageSize = self.imageSize
            let titleSize = self.titleSize()
            if imageSize.equalTo(CGSize.zero) {
                imageSize = actualImageSize
            }
            
            imageEdge.left = (self.whc_Width - imageSize.width) / 2.0
            imageEdge.right = (self.whc_Width - imageSize.width) / 2.0
            imageEdge.top = (self.whc_Height - imageSize.height) / 2.0 - (titleSize.height + textImageMargin) / 2.0
            imageEdge.bottom = (self.whc_Height - imageSize.height) / 2.0 + (titleSize.height + textImageMargin) / 2.0
            
            titleEdge.left = -actualImageSize.width
            titleEdge.top = imageEdge.top + imageSize.height
        case .Text_Top_Image_Bottom:
            let imageSize = self.getImageSize()
            let titleSize = self.titleSize()
            
            titleEdge.left = -imageSize.width
            titleEdge.top = -titleSize.height - textImageMargin / 2.0
            
            imageEdge.left = (self.whc_Width - imageSize.width) / 2.0
            imageEdge.right = (self.whc_Width - imageSize.width) / 2.0
            imageEdge.top = imageSize.height + textImageMargin / 2.0
        case .Text_Image:
            let imageSize = self.getImageSize()
            let titleSize = self.titleSize()
            
            titleEdge.left = -imageSize.width - textImageMargin / 2.0
            titleEdge.right = imageSize.width + textImageMargin / 2.0
            
            imageEdge.left = titleSize.width + textImageMargin / 2.0
            imageEdge.right = -titleSize.width - textImageMargin / 2.0
        }
        self.titleEdgeInsets = titleEdge
        self.imageEdgeInsets = imageEdge
    }
    
    /// 设置按钮布局样式
    var layoutStyle: UIButtonLayoutStyle {
        set {
            objc_setAssociatedObject(self, &HZButtonKey.kLayoutStyleKey, NSNumber(value: newValue.rawValue), .OBJC_ASSOCIATION_RETAIN)
            updateLayout()
        }
        
        get {
            let value = objc_getAssociatedObject(self, &HZButtonKey.kLayoutStyleKey)
            if value != nil {
                return UIButtonLayoutStyle(rawValue: (value as! NSNumber).intValue)!
            }
            return .Text
        }
    }
    
    /// 设置文字和图片间隙
    var textImageMargin: CGFloat {
        set {
            objc_setAssociatedObject(self, &HZButtonKey.kTextImageMarginKey, NSNumber(value: Float(newValue)), .OBJC_ASSOCIATION_RETAIN)
            updateLayout()
        }
        
        get {
            let value = objc_getAssociatedObject(self, &HZButtonKey.kTextImageMarginKey)
            if value != nil {
                return CGFloat((value as! NSNumber).floatValue)
            }
            return 0
        }
    }
    
    /// 设置图片自定义尺寸
    var imageSize: CGSize {
        set {
            objc_setAssociatedObject(self, &HZButtonKey.kImageSizeKey, NSValue(cgSize: newValue), .OBJC_ASSOCIATION_RETAIN)
            updateLayout()
        }
        get {
            let value = objc_getAssociatedObject(self, &HZButtonKey.kImageSizeKey)
            if value != nil {
                return (value as! NSValue).cgSizeValue
            }
            return CGSize.zero
        }
    }
    
}
