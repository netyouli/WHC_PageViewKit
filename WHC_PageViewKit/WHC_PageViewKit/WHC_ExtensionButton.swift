//
//  HZExtension_Button.swift
//  Htinns
//
//  Created by WHC on 16/10/26.
//  Copyright © 2016年 hangting. All rights reserved.
//
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

import UIKit
import WHC_Layout
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


/// 按钮布局样式
public enum UIButtonLayoutStyle: Int {
    /// 只有文字
    case text
    /// 左文字右图片
    case text_Image
    /// 右图片左文字
    case image_Text
    /// 只有图片
    case image
    /// 文字上图片下
    case text_Top_Image_Bottom
    /// 图片上文字下
    case image_Top_Text_Bottom
}


public extension UIButton {
    
    fileprivate  struct HZButtonKey {
        static var kLayoutStyleKey     = "kLayoutStyleKey"
        static var kTextImageMarginKey = "kTextImageMarginKey"
        static var kCustomImageSizeKey = "kCustomImageSizeKey"
    }
    
    public func titleSize() -> CGSize {
        if let title = self.currentTitle, !title.isEmpty {
            if self.currentAttributedTitle?.length > 0 {
                let drawingOptions = NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue)
                return (self.currentAttributedTitle?.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: drawingOptions, context: nil).size)!
            }else {
                let txt: NSString = NSString(cString: (self.currentTitle!.cString(using: String.Encoding.utf8))!,
                                             encoding: String.Encoding.utf8.rawValue)!;
                return txt.size(withAttributes: [NSAttributedStringKey.font:(self.titleLabel?.font)!]);
            }
        }
        return CGSize.zero;
    }
    
   public func imageSize() -> CGSize {
        let image = self.image(for: UIControlState())
        if image != nil {
            return image!.size
        }
        return CGSize.zero
    }
    
    fileprivate func updateLayout() {
        var imageEdge = self.imageEdgeInsets
        var titleEdge = self.titleEdgeInsets
        switch layoutStyle {
        case .image:
            break
        case .text:
            break
        case .image_Text:
            imageEdge.left = -textImageMargin / 2.0
            titleEdge.left = textImageMargin / 2.0
            titleEdge.right = -textImageMargin / 2.0
        case .image_Top_Text_Bottom:
            let imageSize = (customImageSize == CGSize.zero ? self.imageSize() : customImageSize)
            let titleSize = self.titleSize()
            
            imageEdge.left = (self.whc_w - imageSize.width) / 2.0
            imageEdge.right = (self.whc_w - imageSize.width) / 2.0
            imageEdge.top = (self.whc_h - imageSize.height) / 2.0 - (titleSize.height - textImageMargin) / 2.0
            imageEdge.bottom = (self.whc_h - imageSize.height) / 2.0 + (titleSize.height - textImageMargin) / 2.0
            
            titleEdge.left = -self.imageSize().width
            titleEdge.top = imageEdge.top + imageSize.height
        case .text_Top_Image_Bottom:
            let imageSize = (customImageSize == CGSize.zero ? self.imageSize() : customImageSize)
            let titleSize = self.titleSize()
            
            titleEdge.left = -imageSize.width
            titleEdge.top = -titleSize.height - textImageMargin / 2.0
            
            imageEdge.left = (self.whc_w - imageSize.width) / 2.0
            imageEdge.right = (self.whc_w - imageSize.width) / 2.0
            imageEdge.top = imageSize.height + textImageMargin / 2.0
        case .text_Image:
            let imageSize = (customImageSize == CGSize.zero ? self.imageSize() : customImageSize)
            let titleSize = self.titleSize()
            
            titleEdge.left = -imageSize.width - textImageMargin / 2.0
            titleEdge.right = imageSize.width + textImageMargin / 2.0
            
            imageEdge.left = titleSize.width + textImageMargin / 2.0
            imageEdge.right = -titleSize.width - textImageMargin / 2.0
        }
        self.titleEdgeInsets = titleEdge
        self.imageEdgeInsets = imageEdge
    }
    
    public var customImageSize: CGSize {
        set {
            objc_setAssociatedObject(self, &HZButtonKey.kCustomImageSizeKey, NSValue(cgSize: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            if let value = objc_getAssociatedObject(self, &HZButtonKey.kCustomImageSizeKey) as? NSValue {
                return value.cgSizeValue
            }
            return CGSize.zero
        }
    }
    
    /// 设置按钮布局样式
    public var layoutStyle: UIButtonLayoutStyle {
        set {
            objc_setAssociatedObject(self, &HZButtonKey.kLayoutStyleKey, NSNumber(value: newValue.rawValue as Int), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateLayout()
        }
        
        get {
            if let value = objc_getAssociatedObject(self, &HZButtonKey.kLayoutStyleKey) {
                return UIButtonLayoutStyle(rawValue: (value as! NSNumber).intValue)!
            }
            return .text
        }
    }
    
    /// 设置文字和图片间隙
    public var textImageMargin: CGFloat {
        set {
            objc_setAssociatedObject(self, &HZButtonKey.kTextImageMarginKey, NSNumber(value: Float(newValue) as Float), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateLayout()
        }
        
        get {
            if let value = objc_getAssociatedObject(self, &HZButtonKey.kTextImageMarginKey) {
                return CGFloat((value as! NSNumber).floatValue)
            }
            return 0
        }
    }
}

