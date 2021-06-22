import SwiftUI

public class Player: UIView{
    
    let graphShrink = 0.7
    let shapeLayer1 = CAShapeLayer()
    let shapeLayer2 = CAShapeLayer()
    let shapeLayer3 = CAShapeLayer()
    var forward = 100.0
    var ang = 0.0
    var move = false
    var turn = false
    var rad = 0.0
    var earrad = 0.0
    var xfactor = 0.0
    var yfactor = 0.0
    var win = false
    public func setForward(setVal: Double){
        forward = setVal
    }
    public override func draw(_ rect: CGRect) {
        let width = Double(rect.width)*graphShrink
        let height = Double(rect.height)*graphShrink
        drawEllipse(xc: Double(rect.width)/2.0, yc: Double(rect.height)/2.0, r: (Double)(min(width, height)/2), r2: (Double)(min(width, height)/2)*0.2, xfact: 0.7, yfact: 0.8)
        self.frame = CGRect(x: frame.minX+CGFloat(earrad*(1-xfactor)), y: frame.minY+CGFloat((1-yfactor)*rad), width: frame.width-CGFloat(2*earrad*(1-xfactor)), height: frame.height*CGFloat(yfactor))
    }
    
    func drawEllipse(xc: Double, yc: Double, r: Double, r2: Double, xfact: Double, yfact: Double){
        rad = r
        earrad = r2
        xfactor = xfact
        yfactor = yfact
        let path = UIBezierPath()
        var origin = CGPoint(x: xc, y: yc)
        path.move(to: CGPoint(x:xc+r,y:yc))
        for angle in stride(from: 0, to: 360.0, by: 0.1){
            let x = origin.x+CGFloat(cos(angle*Double.pi/180)*r)
            var y = origin.y+CGFloat(sin(angle*Double.pi/180)*r*yfact)
            path.addLine(to: CGPoint(x: x,y: y))
        }
        shapeLayer1.path = path.cgPath
        shapeLayer1.fillColor = UIColor.gray.cgColor
        shapeLayer1.strokeColor = UIColor.black.cgColor
        //              shapeLayer1.frame = layer.bounds
        
        layer.addSublayer(shapeLayer1)
        
        let path2 = UIBezierPath()
        origin = CGPoint(x: xc-r-r2*xfact, y: yc)
        path2.move(to: CGPoint(x:xc-r,y: yc))
        for angle in stride(from: 0, to: 360.0, by: 0.1){
            let x = origin.x+CGFloat(cos(angle*Double.pi/180)*r2*xfact)
            let y = origin.y+CGFloat(sin(angle*Double.pi/180)*r2)
            path2.addLine(to: CGPoint(x: x,y: y))
        } 
        shapeLayer2.path = path2.cgPath
        shapeLayer2.fillColor = UIColor.red.cgColor
        shapeLayer2.strokeColor = UIColor.black.cgColor
        //              shapeLayer2.frame = layer.bounds
        
        layer.addSublayer(shapeLayer2)
        
        let path3 = UIBezierPath()
        origin = CGPoint(x: xc+r+r2*xfact, y: yc)
        path3.move(to: CGPoint(x:xc+r+2*r2*xfact,y: yc))
        for angle in stride(from: 0, to: 360.0, by: 0.1){
            let x = origin.x+CGFloat(cos(angle*Double.pi/180)*r2*xfact)
            let y = origin.y+CGFloat(sin(angle*Double.pi/180)*r2)
            path3.addLine(to: CGPoint(x: x,y: y))
        }
        shapeLayer3.path = path3.cgPath
        shapeLayer3.fillColor = UIColor.blue.cgColor
        shapeLayer3.strokeColor = UIColor.black.cgColor
        //              shapeLayer3.frame = layer.bounds
        layer.addSublayer(shapeLayer3)
        
    }
    public func animateForward(opponent: Opponent, boundary: Frame, v: UIViewController){
        var steplength = forward
        for steps in stride(from: 0, to: forward, by: 0.1){
            let minx = Double(self.frame.minX)+steps*cos(ang+Double.pi/2)
            let miny = Double(self.frame.minY)+steps*sin(ang+Double.pi/2)
            let maxx = Double(self.frame.maxX)+steps*cos(ang+Double.pi/2)
            let maxy = Double(self.frame.maxY)+steps*sin(ang+Double.pi/2)
            if (opponent.intersects(a: CGPoint(x: minx,y: miny), b: CGPoint(x: minx,y: maxy)) || 
                    opponent.intersects(a: CGPoint(x: minx,y: maxy), b: CGPoint(x: maxx,y: maxy)) ||
                opponent.intersects(a: CGPoint(x: maxx,y: maxy), b: CGPoint(x: maxx,y: miny)) ||
                opponent.intersects(a: CGPoint(x: maxx,y: miny), b: CGPoint(x: minx,y: miny))){
                print("win")
                win = true
                steplength = steps
                break
            }
            
            if boundary.outOfBounds(minx: CGFloat(minx), miny: CGFloat(miny), maxx: CGFloat(maxx), maxy: CGFloat(maxy)) {
                steplength = steps-(sqrt(2)-1)*Double(max(frame.width,frame.height))/2
                break
            }
            if steplength < 0 {
                return
            }
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock({ [self] in 
            layer.transform = CATransform3DTranslate(layer.transform, 0, CGFloat(steplength), 0)
            if !win {
                opponent.animateForward(boundary: boundary, player: self)
            }else{
                let alert = UIAlertController(title: "You won", message: "You won the game!", preferredStyle: .alert)
                v.present(alert, animated: false)
            }
            
        })
        let animation = CABasicAnimation(keyPath: "position")
        animation.toValue = [0, steplength]
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        shapeLayer1.add(animation, forKey: "path")
        shapeLayer2.add(animation, forKey: "path")
        shapeLayer3.add(animation, forKey: "path")
        CATransaction.commit()
    }
    public func animateRotate(spinAngle: Double){
        ang += spinAngle
        layer.transform = CATransform3DRotate(layer.transform,CGFloat(spinAngle.truncatingRemainder(dividingBy: 360)), 0, 0, 1.0)
        
    }
    public func getAng() -> Double{
        return ang
    }
    public func leftEarCenter() -> CGPoint{
        let xcenter = Double(layer.frame.midX)
        let ycenter = Double(layer.frame.midY)
        return CGPoint(x: CGFloat(xcenter+(rad+earrad*xfactor)*cos(ang)), y: CGFloat(ycenter+rad*yfactor*sin(ang)))
    }
    public func rightEarCenter() -> CGPoint{
        let xcenter = Double(layer.frame.midX)
        let ycenter = Double(layer.frame.midY)
        return CGPoint(x: xcenter-(rad-earrad*xfactor)*cos(ang), y: (ycenter-rad*yfactor*sin(ang)))
    }
    public func gameOver() -> Bool{
        return win
    }
}
