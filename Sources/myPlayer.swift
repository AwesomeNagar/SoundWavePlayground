
import SwiftUI
import UIKit
import PlaygroundSupport
import AudioToolbox

public class myPlayer{
    var musicTrack: OSStatus!
    var track: MusicTrack?
    var sequence : MusicSequence?
    public init(){
        sequence = nil
        var musicSequence = NewMusicSequence(&sequence)
        
        track = nil
        musicTrack = MusicSequenceNewTrack(sequence!, &track)
    } 
    public func addNote(whichNote: Int, ampli: Int){
        var time = MusicTimeStamp(1.0)
        var note = MIDINoteMessage(channel: 0,
                                   note: (UInt8)(whichNote),
                                   velocity: UInt8(ampli),
                                   releaseVelocity: 0,
                                   duration: 1.0 )
        musicTrack = MusicTrackNewMIDINoteEvent(track!, time, &note)
    }
    public func play(){
        var musicPlayer : MusicPlayer? = nil
        var player = NewMusicPlayer(&musicPlayer)
        
        player = MusicPlayerSetSequence(musicPlayer!, sequence)
        player = MusicPlayerStart(musicPlayer!)
    }
}
