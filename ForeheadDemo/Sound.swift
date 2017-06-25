import UIKit
import AVFoundation

open class Sound: NSObject, AVAudioPlayerDelegate {
    
    static var audioPlayer: AVAudioPlayer?
    
    static func playSound(_ soundName: String) {
        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "wav")!)
        
        audioPlayer = try! AVAudioPlayer(contentsOf: sound as URL, fileTypeHint: "wav")
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (audioPlayer?.duration)!) {
            self.audioPlayer = nil
        }
    }
    
    private static func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
}
