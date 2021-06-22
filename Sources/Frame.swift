

import SwiftUI
public class Frame: UIView{
    let shapeLayer = CAShapeLayer()
    
    public override func draw(_ rect: CGRect) {
        let width = Double(rect.width)
        let height = Double(rect.height)
        let path = UIBezierPath(rect: rect)
        shapeLayer.path = path.cgPath
        //shapeLayer.fillColor = UIColor.black.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        layer.addSublayer(shapeLayer)
    }
    public func randX() -> Double{
        return Double.random(in: Double(frame.minX+frame.width*0.2)...Double(frame.maxX-frame.width*0.2))
    }
    public func randY() -> Double{
        return Double.random(in: Double(frame.minY+frame.height*0.2)...Double(frame.maxY-frame.height*0.2))
    }
    
    public func blindfolded(val: Bool){
        if !val {
            shapeLayer.fillColor = UIColor.white.withAlphaComponent(0).cgColor
        }else{ 
            shapeLayer.fillColor = UIColor.black.cgColor
        }
    }
    public func outOfBounds(minx: CGFloat, miny: CGFloat, maxx: CGFloat, maxy: CGFloat) -> Bool{
        if minx < frame.minX {
            return true
        }
        if maxx > frame.maxX {
            return true
        }
        if miny < frame.minY {
            return true
        }
        if maxy > frame.maxY {
            return true
        }
        return false
        
        
        
        
    }
    
}

