import Foundation
import UIKit

final class ViewPresenter {
    
    weak var view: ViewController!
    var timer: Timer!
    var client: APIClientProtocol!
    
    init(view: ViewController, client: APIClientProtocol) {
        self.view = view
        self.client = client
        
        self.timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(self.sendCircleViewAngle),
            userInfo: nil,
            repeats: true)
    }
    
    @objc func sendCircleViewAngle(timer: Timer) {
        // 自動回転(時計回り)しているTransformを取得
        let circleViewTransform: CATransform3D = self.view.circleView.layer.presentation()!.transform
        // Transforemから角度を取得
        let circleViewDegress = self.radiansToDegress(transform: circleViewTransform)
        // 自動回転(時計回り)しているTransformを取得
        let imageViewTransform: CATransform3D = self.view.circleView.imageView.layer.presentation()!.transform
        // Transforemから角度を取得
        let imageViewDegress = self.radiansToDegress(transform: imageViewTransform)
        let circleViewAngle: CGFloat = CGFloat((-circleViewDegress * CGFloat.pi) / 180.0)
        let imageViewAngle: CGFloat = CGFloat((-imageViewDegress * CGFloat.pi) / 180.0)
        // 2つの角度を足したものを顔の角度としている
        let angle = circleViewAngle + imageViewAngle
        self.view.faceView1.transform = CGAffineTransform(rotationAngle: angle)
        self.view.faceView2.transform = CGAffineTransform(rotationAngle: angle)
        self.view.faceView3.transform = CGAffineTransform(rotationAngle: angle)
        self.view.faceView4.transform = CGAffineTransform(rotationAngle: angle)
        self.view.faceView5.transform = CGAffineTransform(rotationAngle: angle)
        self.view.faceView6.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    func setFaceImages() {
        let facesDatas = [
            (url: "https://contents.newspicks.us/users/100013/cover?circle=true", target: self.view.faceView1),
            (url: "https://contents.newspicks.us/users/100269/cover?circle=true", target: self.view.faceView2),
            (url: "https://contents.newspicks.us/users/100094/cover?circle=true", target: self.view.faceView3),
            (url: "https://contents.newspicks.us/users/100353/cover?circle=true", target: self.view.faceView4),
            (url: "https://contents.newspicks.us/users/100019/cover?circle=true", target: self.view.faceView5),
            (url: "https://contents.newspicks.us/users/100529/cover?circle=true", target: self.view.faceView6)
        ]
        
        for faceData in facesDatas {
            self.client.getImage(url: faceData.url, success: { data in
                faceData.target?.image = UIImage(data: data)
            }) { error in
                let alert = UIAlertController(title: "OK", message: "Failed to load image\(faceData.url)", preferredStyle: .alert)
                let action = UIAlertAction(title: "Yes", style: .default, handler: nil)
                alert.addAction(action)
                self.view.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func radiansToDegress(transform: CATransform3D) -> CGFloat {
        // ベクトル角度
        let radians: CGFloat = atan2(transform.m12, transform.m11)
        // 角度
        var angle = (radians * 180 / CGFloat(Double.pi))
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
