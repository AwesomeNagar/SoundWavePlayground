//: We're going to take a deep dive into sounds. For reference, sound travels outwards from a source in a wave pattern. Each component of the wave directly affects how the sound sounds. Go to View->Hide Results for optimal performance! Hit "Run My Code" and let's take a look at these components when you're ready to go
//#-end-editable-code
//#-hidden-code
import UIKit
import PlaygroundSupport
import AudioToolbox
//#-end-hidden-code
class MyViewController : UIViewController {
//: Let's a look at some of our default values. We know that sound can be loud or quiet, and this is directly related to the AMPLITUDE of the wave. We define it as sinestrength in the code and it represents what percentage of your computer's volume it will use to play the wave (capped at 100%). Try messing around with the values using the leftmost slider and see how it affects the noise you hear and the wave you see!
    var sinestrength = 50.0
//: Sound notes often have a pitch. If you've ever played a piano, you know that there are different notes from A0 (lowest note) to C8 (highest note). The only difference between these notes is their frequecy, which is the amount of times that the sine wave repeats itself in a single second. Currently, integers are being used to represent each note with the default value representing A5 at 440Hz. Try messing around with the values using the rightmost slider and see how it affects the noise you hear and the wave you see!
    var freqval = 440
//#-hidden-code
    var sine: SineView!
    var ampslider: UISlider!
    var freqslider: UISlider!
    var labelAmp: UILabel!
    var labelFreq: UILabel!
    override func viewDidLoad() {
        sinestrength /= 100
        freqval = 69
        super.viewDidLoad()
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
        createAmpSlider()
        createFreqSlider()
        setUpWave()
    }
    func createAmpSlider(){
        ampslider = UISlider()
        ampslider.frame = CGRect(x: 50, y: 100, width: 250, height: 20)
        ampslider.minimumValue = 0
        ampslider.maximumValue = 1000
        ampslider.isContinuous = true
        ampslider.tag = 1
        ampslider.value = Float(sinestrength*1000)
        ampslider.tintColor = UIColor.green
        ampslider.minimumTrackTintColor = UIColor.black
        ampslider.maximumTrackTintColor = UIColor.red
        
        labelAmp = UILabel(frame: CGRect(x: ampslider.frame.minX, y: ampslider.frame.minY-ampslider.frame.height*1.6, width: ampslider.frame.width, height: ampslider.frame.height))
        labelAmp.text = "Amplitude: \(sinestrength*100)%"
        labelAmp.textAlignment = .center
        
        
        ampslider.addTarget(self, action: #selector(sliderValueDidChange(sender:)), for: .valueChanged)
        ampslider.addTarget(self, action: #selector(sliderStop(sender:)), for: .touchUpInside)
        
        self.view.addSubview(ampslider)
        self.view.addSubview(labelAmp)
    }
    func createFreqSlider(){
        freqslider = UISlider()
        freqslider.frame = CGRect(x: 350, y: 100, width: 250, height: 20)
        freqslider.minimumValue = 21
        freqslider.maximumValue = 80
        freqslider.isContinuous = true
        freqslider.tag = 2
        freqslider.value = 69
        freqslider.tintColor = UIColor.green
        freqslider.minimumTrackTintColor = UIColor.black
        freqslider.maximumTrackTintColor = UIColor.red
        
        labelFreq = UILabel(frame: CGRect(x: freqslider.frame.minX, y: freqslider.frame.minY-freqslider.frame.height*1.6, width: freqslider.frame.width, height: freqslider.frame.height))
        labelFreq.text = "Frequency: \(round(440.0*pow(2, ((Double)(freqval)-69.0)/12.0))) Hz"
        labelFreq.textAlignment = .center
        
        
        freqslider.addTarget(self, action: #selector(sliderValueDidChange(sender:)), for: .valueChanged)
        freqslider.addTarget(self, action: #selector(sliderStop(sender:)), for: .touchUpInside)
        self.view.addSubview(freqslider)
        self.view.addSubview(labelFreq)
    }
    
    func setUpWave() {
        let sineChange = SineView(frame: CGRect(x:0,y:200,width:900,height:500))
        let sinefreq = 440.0/27.5*pow(2, ((Double)(freqval)-69.0)/12.0)
        
        sineChange.assign(amp: sinestrength, freq: sinefreq)
        sineChange.backgroundColor = .white
        sinestrength = 1.0*Double(ampslider.value)/1000.0
        sine = sineChange
        view.addSubview(sine)
        
    }
    
    @objc func sliderValueDidChange(sender:UISlider) {
        if sender.tag == 1 {
            sinestrength = 1.0*Double(sender.value)/1000.0
            labelAmp.text = "Amplitude: \(round(sinestrength*1000)/10.0)%"
        }else{
            freqval = Int((sender.value))
            sender.value = Float(freqval)
            labelFreq.text = "Frequency: \(round(4400.0*pow(2, ((Double)(freqval)-69.0)/12.0))/10.0) Hz"
        }
        setUpWave()
    }
    @objc func sliderStop(sender:UISlider) {
        let music: myPlayer = myPlayer()
        music.addNote(whichNote: freqval, ampli: (Int(sinestrength*100)))
        music.play()
    }

//#-end-hidden-code
}
//: Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
PlaygroundPage.current.needsIndefiniteExecution = true
