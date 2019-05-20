//
//  ArrowViewController.swift
//  SixFace
//
//  Created by Watanabe Takehiro on 2019/05/18.
//  Copyright © 2019 Watanabe Takehiro. All rights reserved.
//

import UIKit

class ArrowViewController: UIViewController {

    @IBOutlet weak var circleView: CircleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.circleView.delegate = self
    }
    
}

extension ArrowViewController: RotaryProtocol {
    func touchesBegan() {

    }
    
    func touchesEnded() {

    }
    
    func updatedRagianAngle(circleView: CircleView, angle: CGFloat) {

        let digree = angle * 180 / .pi
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.positiveFormat = "0.0" // "0.#" -> 0パディングしない
        formatter.roundingMode = .halfUp // 四捨五入 // .floor -> 切り捨て
        let digreeString = formatter.string(for: digree) ?? ""
        
        print("角度: \(digreeString)°")

    }
}
