
import SwiftUI
public class SineView: UIView{
    public let shapeLayer1 = CAShapeLayer()
    public let shapeLayer2 = CAShapeLayer()
    let graphWidth: CGFloat = 0.8  // Graph is 80% of the width of the view
    public var amplitude1: CGFloat = -1   // Amplitude of sine wave is 30% of view height
    public var ampliitude2: CGFloat = -1
    public var phase: Double = 0.0
    var frequency: Double = 2.0
    public func assign(amp1: Double, amp2: Double, phases: Double){
        amplitude1 = CGFloat(amp1)
        ampliitude2 = CGFloat(amp2)
        phase = phases
    }
    public override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        let origin = CGPoint(x: width * (1 - graphWidth) / 2, y: height * 0.50)
        
        let path = UIBezierPath()
        path.move(to: origin)
        
        for angle in stride(from: 0, through: 360.0, by: 0.1) {
            let x = origin.x + CGFloat(angle/360.0) * width * graphWidth
            let y = origin.y - CGFloat(sin(frequency*angle/180.0 * Double.pi)) * height * max(amplitude1, ampliitude2)/2
            path.addLine(to: CGPoint(x: x, y: y))
        }
        shapeLayer1.path = path.cgPath
        shapeLayer1.fillColor = UIColor.white.withAlphaComponent(0).cgColor
        
        shapeLayer1.strokeColor = UIColor.red.cgColor
        if amplitude1 > ampliitude2 {
            shapeLayer1.strokeColor = UIColor.blue.cgColor
        }
        layer.addSublayer(shapeLayer1)
        
        let path2 = UIBezierPath()
        path2.move(to: origin)
        let stagger = (phase/1.4)*135
        path2.addLine(to: CGPoint(x:origin.x+CGFloat((stagger-0.1)/360.0) * width * graphWidth, y: origin.y))
        for angle in stride(from: stagger, to: 360.0, by: 0.1){
            let x = origin.x + CGFloat(angle/360.0) * width * graphWidth
            let y = origin.y - CGFloat(sin(frequency*(angle-stagger)/180.0 * Double.pi)) * height * min(amplitude1, ampliitude2)/2
            path2.addLine(to: CGPoint(x: x, y: y))
        }
        shapeLayer2.path = path2.cgPath
        shapeLayer2.fillColor = UIColor.white.withAlphaComponent(0).cgColor
        
        shapeLayer2.strokeColor = UIColor.blue.cgColor
        if amplitude1 > ampliitude2 {
            shapeLayer2.strokeColor = UIColor.red.cgColor
        }
        layer.addSublayer(shapeLayer2)
    }
    public func animateTo(to: SineView){
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.1
        animation.toValue = to.shapeLayer1.path
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        self.shapeLayer1.add(animation, forKey: "path")
        
        let animation1 = CABasicAnimation(keyPath: "path")
        animation1.duration = 0.1
        animation1.toValue = to.shapeLayer2.path
        animation1.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        self.shapeLayer2.add(animation1, forKey: "path")
        
    }
    
}
