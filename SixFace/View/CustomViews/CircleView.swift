import UIKit

public protocol RotaryProtocol: class {
    func touchesBegan()
    func touchesEnded()
}

@IBDesignable
public class CircleView: UIView {
    
    let imageView = UIImageView(frame: CGRect())
    
    @IBInspectable var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    @IBInspectable var contentModeNumber: Int = 0 {
        didSet {
            guard let mode = UIView.ContentMode(rawValue: contentModeNumber) else { return }
            imageView.contentMode = mode
        }
    }
    
    // タップ開始時のTransform
    var startTransform: CGAffineTransform?
    // タップ座標と中心点の角度
    var deltaAngle: CGFloat = 0.0
    
    weak public var delegate: RotaryProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {

        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 0).isActive = true
        imageView.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 0).isActive = true
        imageView.trailingAnchor.constraint(equalToSystemSpacingAfter: self.trailingAnchor, multiplier: 0).isActive = true
        imageView.bottomAnchor.constraint(equalToSystemSpacingBelow: self.bottomAnchor, multiplier: 0).isActive = true
    }

    private func makeDeltaAngle(touches: Set<UITouch>) -> CGFloat? {
        guard let touch = touches.first else { return nil }
        // 座標を計算するCoordinateManagerを作成
        let manager = CoordinateManager()
        // タップ座標を作成
        let touchPoint = touch.location(in: self)
        // 中心点を作成
        let center = CGPoint(x: imageView.bounds.width/2, y: imageView.bounds.height/2)
        // タップ座標と中心距離を作成
        let dist = manager.calculateDistance(center: center, point: touchPoint)
        
        // タッチ範囲外
        // 中心に近すぎると回転が飛び跳ねるような動きをするのである程度近いなら無視する
        if manager.isIgnoreRange(distance: dist, size: imageView.bounds.size) {
            return nil
        }
        // タップ座標と中心点の角度を返却
        return manager.makeDeltaAngle(targetPoint: touchPoint, center: imageView.center)
    }
    
    func getAngle() -> CGFloat {
        // 回転をtransformから算出
        var angle = atan2(imageView.transform.b, imageView.transform.a)
        // ラジアン範囲を -.pi < Θ < pi から 0 < Θ < 2 piに変更
        if angle < 0 {
            angle += 2 * .pi
        }
        return angle
    }
    
    // タップ開始処理
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.touchesBegan()
        // 現状のimageViewのstransformを更新
        startTransform = imageView.transform
        
        guard let targetAngle = makeDeltaAngle(touches: touches) else { return }
        self.deltaAngle = targetAngle
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タップされた座標をもとめる
        guard let targetAngle = makeDeltaAngle(touches: touches) else { return }
        // タップが開始された
        let angleDifference = deltaAngle - targetAngle
        imageView.transform = startTransform?.rotated(by: -angleDifference) ?? CGAffineTransform.identity
    }
    
    // タップ終了処理
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.touchesEnded()
    }

}
