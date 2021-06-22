
import SwiftUI
public class SineView: UIView{
    let graphWidth: CGFloat = 0.8  // Graph is 80% of the width of the view
    var amplitude: CGFloat = 0.3   // Amplitude of sine wave is 30% of view height
    var frequency: Double = 1.0
    public func assign(amp: Double, freq: Double){
        amplitude = CGFloat(amp)
        frequency = freq
    }
    public override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        let origin = CGPoint(x: width * (1 - graphWidth) / 2, y: height * 0.50)
        
        let path = UIBezierPath()
        path.move(to: origin)
        
        for angle in stride(from: 0, through: 360.0, by: 0.1) {
            let x = origin.x + CGFloat(angle/360.0) * width * graphWidth
            let y = origin.y - CGFloat(sin(frequency*angle/180.0 * Double.pi)) * height * amplitude/2
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        UIColor.black.setStroke()
        path.stroke()
    }
}
