import UIKit

class ViewController: UIViewController {
    
    var circleLine: UIView!
    var circleView: CircleView!
    var presenter: ViewPresenter!
    
    var faceView1: UIImageView!
    var faceView2: UIImageView!
    var faceView3: UIImageView!
    var faceView4: UIImageView!
    var faceView5: UIImageView!
    var faceView6: UIImageView!
    
    let margin: CGFloat = 80
    let faceSize: Double = 50.0
    var faceCGSize: CGSize!
    var circleRadius: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = ViewPresenter(view: self, client: APIClient())
        self.faceCGSize = CGSize(width: faceSize, height: faceSize)
        self.circleRadius = (self.view.frame.width - margin * 2) / 2
        
        // 回転Viewを作成
        self.setCircleView()
        
        // 顔Viewを作成
        self.setFacesView()
        // 顔Viewの画像を取得して設定
        self.presenter.setFaceImages()
        
        self.setCircleLineView()
        
        self.view.addSubview(self.circleLine)
        self.view.addSubview(self.circleView)
        
        self.rotateAnimation()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.circleLine.layer.borderWidth = 1
        self.circleLine.layer.borderColor = UIColor.white.cgColor
        self.circleLine.layer.cornerRadius = self.circleView.frame.width / 2
        self.faceView1.layer.cornerRadius = self.faceView1.frame.width / 2
        self.faceView2.layer.cornerRadius = self.faceView2.frame.width / 2
        self.faceView3.layer.cornerRadius = self.faceView3.frame.width / 2
        self.faceView4.layer.cornerRadius = self.faceView4.frame.width / 2
        self.faceView5.layer.cornerRadius = self.faceView5.frame.width / 2
        self.faceView6.layer.cornerRadius = self.faceView6.frame.width / 2
    }
    
    // 回転Viewを作成
    private func setCircleView() {
        self.circleView = CircleView()
        self.circleView.delegate = self
        self.circleView.frame = CGRect(
            x: self.view.frame.origin.x + self.margin,
            y: (self.view.frame.height / 2) - (self.circleRadius),
            width: self.circleRadius * 2,
            height: self.circleRadius * 2)
    }
    
    // 顔Viewを作成
    private func setFacesView() {
        self.faceView1 = UIImageView()
        faceView1.frame = CGRect(origin: HexPosition.one.position(radius: Double(self.circleRadius), coefficient: faceSize / 2), size: faceCGSize)
        self.circleView.imageView.addSubview(faceView1)
        
        self.faceView2 = UIImageView()
        faceView2.frame = CGRect(origin: HexPosition.two.position(radius: Double(self.circleRadius), coefficient: faceSize / 2), size: faceCGSize)
        self.circleView.imageView.addSubview(faceView2)
        
        self.faceView3 = UIImageView()
        faceView3.frame = CGRect(origin: HexPosition.three.position(radius: Double(self.circleRadius), coefficient: faceSize / 2), size: faceCGSize)
        self.circleView.imageView.addSubview(faceView3)
        
        self.faceView4 = UIImageView()
        faceView4.frame = CGRect(origin: HexPosition.four.position(radius: Double(self.circleRadius), coefficient: faceSize / 2), size: faceCGSize)
        self.circleView.imageView.addSubview(faceView4)
        
        self.faceView5 = UIImageView()
        faceView5.frame = CGRect(origin: HexPosition.five.position(radius: Double(self.circleRadius), coefficient: faceSize / 2), size: faceCGSize)
        self.circleView.imageView.addSubview(faceView5)
        
        self.faceView6 = UIImageView()
        faceView6.frame = CGRect(origin: HexPosition.six.position(radius: Double(self.circleRadius), coefficient: faceSize / 2), size: faceCGSize)
        self.circleView.imageView.addSubview(faceView6)
    }
    
    // 円Viewを作成
    private func setCircleLineView() {
        self.circleLine = UIView()
        self.circleLine.frame = self.circleView.frame
        self.circleLine.isUserInteractionEnabled = false
    }
    
    // 時計回りアニメーション設定
    private func rotateAnimation() {
        let rotateAnim = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnim.fromValue = 0.0
        rotateAnim.toValue = CGFloat(.pi * 2.0)
        rotateAnim.duration = 24
        rotateAnim.repeatCount = .infinity
        self.circleView.layer.add(rotateAnim, forKey: nil)
    }
    
}

extension ViewController: RotaryProtocol {
    func touchesBegan() {
        self.pauseLayer(layer: self.circleView.layer)
    }
    
    func touchesEnded() {
        self.resumeLayer(layer: self.circleView.layer)
    }
    
    func pauseLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
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
