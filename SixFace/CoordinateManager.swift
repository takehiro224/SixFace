//
//  CoordinateManager.swift
//  SixFace
//
//  Created by Watanabe Takehiro on 2019/05/18.
//  Copyright © 2019 Watanabe Takehiro. All rights reserved.
//

import Foundation
import UIKit

struct CoordinateManager {
    
    func calculateDistance(center: CGPoint, point: CGPoint) -> CGFloat {
        let dx = point.x - center.x
        let dy = point.y - center.y
        return CGFloat(sqrt(dx*dx + dy*dy)) //ピタゴラスの定理より
    }
    
    func isIgnoreRange(distance: CGFloat, size: CGSize) -> Bool {
        if (distance < size.width/10 || size.width/2 < distance) {
            return true
        }
        
        if (distance < size.height/10 || size.height/2 < distance) {
            return true
        }
        
        return false
    }
    
    func makeDeltaAngle(targetPoint: CGPoint, center: CGPoint) -> CGFloat {
        // 中心点を座標の(0, 0)に揃える
        let dx = targetPoint.x - center.x
        let dy = targetPoint.y - center.y
        // 座標と中心の角度を返却
        return atan2(dy, dx)
    }
    
}
