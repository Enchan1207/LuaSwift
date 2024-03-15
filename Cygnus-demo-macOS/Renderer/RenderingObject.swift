//
//  RenderingObject.swift
//  Asteroid for mac
//
//  Created by EnchantCode on 2024/03/14.
//

import Cocoa

/// 描画オブジェクト
enum RenderingObject {
    
    /// 背景を塗り潰す
    case background(color: NSColor)
    
    /// 塗り潰しに使う色を設定する
    case fill(color: NSColor)
    
    /// 線の色を設定する
    case stroke(color: NSColor)
    
    /// 線の太さを設定する
    case strokeWeight(weight: CGFloat)
    
    /// 線を引く
    case line(from: CGPoint, to: CGPoint)
    
    /// 矩形を描く
    case rect(origin: CGPoint, size: CGSize)
    
    /// 楕円を描く
    case ellipse(origin: CGPoint, size: CGSize)
    
    /// 文字列を描く
    case text(origin: CGPoint, content: String)
    
    /// 文字のフォントサイズを設定する
    case textSize(point: CGFloat)
    
}

