
/*: 
It's time to put together what you learned before, but before that, tutorial time! This is going to be a variation on Marco Polo, the classic game where a person with a blindfold tries to scout out where people are 
 
 Layout:
 - You are the gray oval with a blue left ear and a red right ear
 - The orange oval is the other person, who is constantly calling Polo so you know where they are
 - The sine waves at the bottomm, represents what your ears are hearing (color coded to match the respective ears)
 
 Controls:
 - Click on yourself and drag outwards in the direction that you want to face. The player will immediately face that direction
 - When the game starts, you will have the ability to move forward and remove your blindfold or put it on (Toggle Blind)
 
 Try rotating yourself around. Notice how the sine waves shift as the positions of your ears relative to the other person changes. Do you notice any patterns with how they shift?
 
 Remember, your opponent will only move AFTER you move forward when the game starts!
 */
//#-end-editable-code
//#-hidden-code
import UIKit
import PlaygroundSupport
import AudioToolbox
//#-end-hidden-code
class MyViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
/*: 
Uncomment the line below when you are ready to start the game. Good luck :)
*/
//#-editable-code
        self.startGame()
//#-end-editable-code
//#-hidden-code
        let view = UIView()
        print(UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view
        setUpGame()
//#-end-hidden-code
    }
//#-hidden-code
    var player: Player!
    var opponent: Opponent!
    var forwardButton: UIButton!
    var button2: UIButton!
    var sinusoid: SineView!
    var gameFrame: Frame!
    var blind = true
    var ingame = false
    
    @objc func buttonForward() {
        if !ingame {
            return
        }
        
        player.animateForward(opponent: opponent, boundary: gameFrame, v: self)
        callMarco()
    }
    @objc func buttonClicked2(){
        if !ingame {
            return
        }
        blind = !blind
        gameFrame.blindfolded(val: blind)
        if !blind {
            view.addSubview(opponent)
        }else{
            opponent.removeFromSuperview()
        }
    }
    
    
    func setUpGame() {
        gameFrame = Frame(frame: CGRect(x: widthMargin, y: heightMargin, width: screenWidth-widthMargin, height: 0.8*screenHeight-heightMargin))
        gameFrame.blindfolded(val: ingame)
        gameFrame.isUserInteractionEnabled = true
        
        sinusoid = SineView(frame: CGRect(x: widthMargin,y: gameFrame.frame.maxY+heightMargin, width:0.7*screenWidth,height: screenHeight+2*heightMargin-gameFrame.frame.maxY))
        sinusoid.assign(amp1: 0, amp2: 0, phases: 0)
        sinusoid.backgroundColor = .white
        
        player = Player(frame: CGRect(x:gameFrame.randX()/4,y:gameFrame.randY(),width: Double(min(screenWidth,screenHeight)/14),height:Double(min(screenWidth,screenHeight)/14)))
        player.backgroundColor = UIColor.white.withAlphaComponent(0)
        player.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panAng(gestureRecognizer:)))
        player.addGestureRecognizer(pan)
        
        opponent = Opponent(frame: CGRect(x:Double(gameFrame.randX()/4.0+3*Double(gameFrame.frame.width)/4.0),y:gameFrame.randY(),width: Double(min(screenWidth,screenHeight)/20),height:Double(min(screenWidth,screenHeight)/20)))
        opponent.backgroundColor = UIColor.white.withAlphaComponent(0)
        
        
        callMarco()
        
        forwardButton = UIButton(frame: CGRect(x: sinusoid.frame.maxX+widthMargin/2,y: sinusoid.frame.minY, width: screenWidth-sinusoid.frame.width-2*widthMargin,height: sinusoid.frame.height/2-heightMargin/2))
        forwardButton.backgroundColor = .black
        forwardButton.setTitle("Forward", for: .normal)
        forwardButton.addTarget(self, action:#selector(self.buttonForward), for: .touchUpInside)
        
        button2 = UIButton(frame: CGRect(x: sinusoid.frame.maxX+widthMargin/2,y: sinusoid.frame.minY+sinusoid.frame.height/2+heightMargin/2, width: screenWidth-sinusoid.frame.width-2*widthMargin,height: sinusoid.frame.height/2-heightMargin/2))
        button2.backgroundColor = .black
        button2.setTitle("Blind Toggle", for: .normal)
        button2.addTarget(self, action:#selector(self.buttonClicked2), for: .touchUpInside)
        
        self.view.addSubview(gameFrame)
        self.view.addSubview(player)
        //self.view.addSubview(opponent)
        if !ingame {
            self.view.addSubview(opponent)
        }
        
        self.view.addSubview(sinusoid)
        if ingame {
            self.view.addSubview(forwardButton) 
            self.view.addSubview(button2)
        }
    }
    func callMarco(){
        let info = opponent.Polo(p: player)
        let sinusoids = SineView(frame: sinusoid.frame)
        sinusoids.assign(amp1: Double(min(info.x,info.y)/info.x), amp2: Double(min(info.x,info.y)/info.y), phases: Double(abs(info.x-info.y)))
        sinusoids.backgroundColor = .white
        sinusoid = sinusoids
        view.addSubview(sinusoid)
    }
    
    
    
    var initialCenter = CGPoint()  // The initial center point of the view.
    @objc func panAng(gestureRecognizer : UIPanGestureRecognizer) { 
        guard gestureRecognizer.view != nil else {return}
        let piece = gestureRecognizer.view!
        let translation = gestureRecognizer.translation(in: piece.superview)
        if gestureRecognizer.state == .began {
        }
        if gestureRecognizer.state == .changed{
            let v1 = CGPoint(x: translation.x, y: translation.y)
            let v2 = CGPoint(x: cos(player.getAng()+Double.pi/2), y: sin(player.getAng()+Double.pi/2))
            var turnang = angDifference(from: v1, to: v2)
            let newang = turnang+player.getAng()
            
            player.animateRotate(spinAngle: turnang)
            callMarco()
        }
        
    }
    
    
    
    //Math functions
    func dotProd(a: CGPoint, b: CGPoint) -> Double{
        return Double(a.x*b.x+a.y*b.y)
    }
    func magnitude(a: CGPoint) -> Double{
        return sqrt(dotProd(a: a, b: a))
    }
    func angBetweenVectors(a: CGPoint, b: CGPoint) -> Double{
        return acos(dotProd(a: a, b: b)/(magnitude(a: a)*magnitude(a: b)))
    }
    func angDifference(from: CGPoint, to: CGPoint) -> Double{
        let ang1 = Double(atan(from.y/from.x))
        let ang2 = Double(atan(to.y/to.x))
        var ret = ang1-ang2
        let check = angBetweenVectors(a: from, b: to)
        if (abs(abs(ret)-check)/check) > 0.1{
            if ret < 0 {
                ret += Double.pi
            }else{
                ret -= Double.pi
            }
            
        }
        return ret
    }
    //layout dimensions
    // Screen width.
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width/2.0
}
    
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    //screen margin
    public var widthMargin: CGFloat {
        return screenWidth*0.05
    }
    public var heightMargin: CGFloat {
        return screenHeight*0.05
    }
    func startGame(){
        ingame = true
    }
//#-end-hidden-code
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
PlaygroundPage.current.needsIndefiniteExecution = true
