//
//  ViewPresenter.swift
//  SixFace
//
//  Created by Watanabe Takehiro on 2019/05/18.
//  Copyright © 2019 Watanabe Takehiro. All rights reserved.
//

import Foundation
import UIKit

final class ViewPresenter {
    
    weak var view: ViewController!
    var timer: Timer!
    
    init(view: ViewController) {
        self.view = view
        
        self.timer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(self.sendCircleViewAngle),
            userInfo: nil,
            repeats: true)
    }
    
    @objc func sendCircleViewAngle(timer: Timer) {
        let circleViewTransform: CATransform3D = self.view.circleView.layer.presentation()!.transform
        let circleViewDegress = self.radiansToDegress(transform: circleViewTransform)
        let imageViewTransform: CATransform3D = self.view.circleView.imageView.layer.presentation()!.transform
        let imageViewDegress = self.radiansToDegress(transform: imageViewTransform)
        let circleViewAngle: CGFloat = CGFloat((-circleViewDegress * CGFloat(Double.pi)) / 180.0)
        let imageViewAngle: CGFloat = CGFloat((-imageViewDegress * CGFloat(Double.pi)) / 180.0)
        print(imageViewAngle)
        let angle = circleViewAngle + imageViewAngle
        self.view.faceView1.transform = CGAffineTransform(rotationAngle: angle)
        self.view.faceView2.transform = CGAffineTransform(rotationAngle: angle)
        self.view.faceView3.transform = CGAffineTransform(rotationAngle: angle)
        self.view.faceView4.transform = CGAffineTransform(rotationAngle: angle)
        self.view.faceView5.transform = CGAffineTransform(rotationAngle: angle)
        self.view.faceView6.transform = CGAffineTransform(rotationAngle: angle)
        
    }
    
    func radiansToDegress(transform: CATransform3D) -> CGFloat {
        //radians
        let radians: CGFloat = atan2(transform.m12, transform.m11)
        var angle = (radians * 180 / CGFloat(Double.pi))// + 90.0
        if angle < 0 {
            angle = 360 + angle
        }
        return angle
    }
    
}

enum HexPosition {
    case one
    case two
    case three
    case four
    case five
    case six
    
    func position(radius: Double, coefficient: Double = 0) -> CGPoint {
        // x: radius * √3 /2
        let basePositionX: Double = radius * sqrt(3)  / 2.0
        // y: radius * √1 / 2
        let basePositionY: Double = radius / 2.0
        switch self {
        case .one:
            return CGPoint(x: radius - coefficient, y: 0 - coefficient)
        case .two:
            return CGPoint(x: basePositionX + radius - coefficient, y: radius - basePositionY - coefficient)
        case .three:
            return CGPoint(x: basePositionX + radius - coefficient, y: radius * 2 - basePositionY - coefficient)
        case .four:
            return CGPoint(x: radius - coefficient, y: radius * 2 - coefficient)
        case .five:
            return CGPoint(x: radius - basePositionX - coefficient, y: radius * 2 - basePositionY - coefficient)
        case .six:
            return CGPoint(x: radius - basePositionX - coefficient, y: radius - basePositionY - coefficient)
        }
    }
}
