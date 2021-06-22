
import SwiftUI
public class Opponent: UIView{
    let speed = 50.0
    let shapeLayer1 = CAShapeLayer()
    var forward = 50.0
    let yfactor = 0.8
    var transformation = false
    public func setForward(setVal: Double){
        forward = setVal
    }
    public override func draw(_ rect: CGRect) {
        let width = Double(rect.width)
        let height = Double(rect.height)
        drawEllipse(xc: Double(rect.width)/2.0, yc: Double(rect.height)/2.0, r: (Double)(min(width, height)/2), r2: (Double)(min(width, height)/2)*0.2, yfact: yfactor)
        frame = CGRect(x: frame.minX, y: frame.minY+CGFloat((1-yfactor)/2)*frame.height, width: frame.width, height: frame.height*CGFloat(yfactor))
    }
    
    func drawEllipse(xc: Double, yc: Double, r: Double, r2: Double, yfact: Double){
        
        let path = UIBezierPath()
        var origin = CGPoint(x: xc, y: yc)
        path.move(to: CGPoint(x:xc+r,y:yc))
        for angle in stride(from: 0, to: 360.0, by: 0.1){
            let x = origin.x+CGFloat(cos(angle*Double.pi/180)*r)
            var y = origin.y+CGFloat(sin(angle*Double.pi/180)*r*yfact)
            path.addLine(to: CGPoint(x: x,y: y))
        }
        shapeLayer1.path = path.cgPath
        shapeLayer1.fillColor = UIColor.orange.cgColor
        shapeLayer1.strokeColor = UIColor.black.cgColor
        layer.addSublayer(shapeLayer1)
    }
    func dist(a:CGPoint, b:CGPoint) -> Double{
        return sqrt(Double(pow(b.x-a.x,2)+pow(b.y-a.y,2)))
    }
    public func Polo(p: Player) -> CGPoint{
        let curpoint = CGPoint(x: layer.frame.midX, y: layer.frame.midY)
        let time1 = Double(dist(a: p.leftEarCenter(), b: curpoint)/speed)
        let time2 = Double(dist(a: p.rightEarCenter(), b: curpoint)/speed)
        return CGPoint(x:CGFloat(time1),y: CGFloat(time2))
    }
    public func animateForward(boundary: Frame, player: Player) {
        let ang = Double.random(in:0...360.0)
        var randx = forward*cos(ang)*0.75
        var randy = forward*sin(ang)*0.75
        
        if abs(player.frame.midX-frame.midX-CGFloat(randx)) < abs(player.frame.midX-frame.midX){
            randx *= -1
        }
        if abs(player.frame.midY-frame.midY-CGFloat(randy)) < abs(player.frame.midY-frame.midY){
            randy *= -1
        }
        
        for steps in stride(from: 0, to: 1, by: 0.01){
            let minx = Double(self.frame.minX)+steps*randx
            let miny = Double(self.frame.minY)+steps*randy
            let maxx = Double(self.frame.maxX)+steps*randx
            let maxy = Double(self.frame.maxY)+steps*randy
            if boundary.outOfBounds(minx: CGFloat(minx), miny: CGFloat(miny), maxx: CGFloat(maxx), maxy: CGFloat(maxy)) {
                randx *= steps
                randy *= steps
                break
            }
            
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock({ [self] in 
            layer.transform = CATransform3DTranslate(layer.transform, CGFloat(randx), CGFloat(randy), 0)
            
        })
        let animation = CABasicAnimation(keyPath: "position")
        animation.toValue = [randx, randy]
        animation.duration = 0.2
        //              animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        shapeLayer1.add(animation, forKey: "path")
        CATransaction.commit()
    }
    public func intersects(a: CGPoint, b: CGPoint) -> Bool{
        if max(a.x,b.x) < frame.minX{
            return false
        }
        if max(a.y,b.y) < frame.minY{
            return false
        }
        if min(a.x,b.x) > frame.maxX{
            return false
        }
        if min(a.y,b.y) > frame.maxY{
            return false
        }
        
        if b.x == a.x {
            return true
        }
        
        let slope = (b.y-a.y)/(b.x-a.x)
        let yint = a.y-a.x*slope
        let y1 = slope*frame.minX+yint
        let y2 = slope*frame.maxX+yint
        if (y1 >= CGFloat(frame.minY) && y1 <= CGFloat(frame.maxY)){
            return true
        }
        if  (y2 >= CGFloat(frame.minY) && y2 <= CGFloat(frame.maxY)){
            return true
        }
        
        return false
        
    }
}

