//
//  ViewController.swift
//  SixFace
//
//  Created by Watanabe Takehiro on 2019/05/17.
//  Copyright © 2019 Watanabe Takehiro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var circleLine: UIView!
    var circleView: CircleView!
    var presenter: ViewPresenter!
    
    var faceView1: UIView!
    var faceView2: UIView!
    var faceView3: UIView!
    var faceView4: UIView!
    var faceView5: UIView!
    var faceView6: UIView!
    
    let margin: CGFloat = 80
    let faceSize: Double = 50.0
    var faceCGSize: CGSize!
    var circleRadius: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = ViewPresenter(view: self)
        self.faceCGSize = CGSize(width: faceSize, height: faceSize)
        self.circleRadius = (self.view.frame.width - margin * 2) / 2
        
        self.circleView = CircleView()
        self.circleView.delegate = self
        self.circleView.frame = CGRect(
            x: self.view.frame.origin.x + self.margin,
            y: (self.view.frame.height / 2) - (self.circleRadius),
            width: self.circleRadius * 2,
            height: self.circleRadius * 2)
        
        self.faceView1 = UIView()
        faceView1.backgroundColor = .blue
        faceView1.frame = CGRect(origin: HexPosition.one.position(radius: Double(self.circleRadius), coefficient: faceSize / 2), size: faceCGSize)
        self.circleView.imageView.addSubview(faceView1)
        
        self.faceView2 = UIView()
        faceView2.backgroundColor = .red
        faceView2.frame = CGRect(origin: HexPosition.two.position(radius: Double(self.circleRadius), coefficient: faceSize / 2), size: faceCGSize)
        self.circleView.imageView.addSubview(faceView2)
        
        self.faceView3 = UIView()
        faceView3.backgroundColor = .green
        faceView3.frame = CGRect(origin: HexPosition.three.position(radius: Double(self.circleRadius), coefficient: faceSize / 2), size: faceCGSize)
        self.circleView.imageView.addSubview(faceView3)
        
        self.faceView4 = UIView()
        faceView4.backgroundColor = .yellow
        faceView4.frame = CGRect(origin: HexPosition.four.position(radius: Double(self.circleRadius), coefficient: faceSize / 2), size: faceCGSize)
        self.circleView.imageView.addSubview(faceView4)
        
        self.faceView5 = UIView()
        faceView5.backgroundColor = .orange
        faceView5.frame = CGRect(origin: HexPosition.five.position(radius: Double(self.circleRadius), coefficient: faceSize / 2), size: faceCGSize)
        self.circleView.imageView.addSubview(faceView5)
        
        self.faceView6 = UIView()
        faceView6.backgroundColor = .magenta
        faceView6.frame = CGRect(origin: HexPosition.six.position(radius: Double(self.circleRadius), coefficient: faceSize / 2), size: faceCGSize)
        self.circleView.imageView.addSubview(faceView6)
        
        self.circleLine = UIView()
        self.circleLine.frame = self.circleView.frame
        self.circleLine.isUserInteractionEnabled = false
        
        self.view.addSubview(self.circleLine)
        self.view.addSubview(self.circleView)
        
        let rotateAnim = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnim.fromValue = 0.0
        rotateAnim.toValue = CGFloat(.pi * 2.0)
        rotateAnim.duration = 24
        rotateAnim.repeatCount = .infinity
        self.circleView.layer.add(rotateAnim, forKey: nil)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.circleLine.layer.borderWidth = 1
        self.circleLine.layer.borderColor = UIColor.white.cgColor
        self.circleLine.layer.cornerRadius = self.circleView.frame.width / 2
//        self.faceView1.layer.cornerRadius = self.faceView1.frame.width / 2
//        self.faceView2.layer.cornerRadius = self.faceView2.frame.width / 2
//        self.faceView3.layer.cornerRadius = self.faceView3.frame.width / 2
//        self.faceView4.layer.cornerRadius = self.faceView4.frame.width / 2
//        self.faceView5.layer.cornerRadius = self.faceView5.frame.width / 2
//        self.faceView6.layer.cornerRadius = self.faceView6.frame.width / 2
        
        
    }
    @IBAction func tap(_ sender: Any) {
        let transform: CATransform3D = self.circleView.imageView.layer.presentation()!.transform
        let angle = self.radiansToDegress(transform: transform)
        print(angle)
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

extension ViewController: RotaryProtocol {
    func touchesBegan() {
        self.pauseLayer(layer: self.circleView.layer)
    }
    
    func touchesEnded() {
        self.resumeLayer(layer: self.circleView.layer)
    }
    
    func updatedRagianAngle(circleView: CircleView, angle: CGFloat) {
        
        let digree = angle * 180 / .pi
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.positiveFormat = "0.0" // "0.#" -> 0パディングしない
        formatter.roundingMode = .halfUp // 四捨五入 // .floor -> 切り捨て
        let _ = formatter.string(for: digree) ?? ""
        
    }
    
    func pauseLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        print(pausedTime)
    }
    
    func resumeLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
}
