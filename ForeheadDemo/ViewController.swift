import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    //MARK: - Variables
    
    ///
    var selectedCategory = ""
    
    ///
    let motionManager = CMMotionManager()
    
    ///
    var start = false;
    
    ///
    var words = [String]()
    
    ///
    var counter = 0
    
    ///
    var timer = Timer()
    
    ///
    var bb = false
    
    ///
    var first = true
    
    ///
    var scoreint = 0
    
    ///
    #if DEBUG
        var timeLeft = 10
    #else
        var timeLeft = 60
    #endif
    ///
    var categoriesVC: Categories?
    
    
    //MARK: - Storyboard References
    
    ///
    @IBOutlet weak var lbl: UILabel!
    
    ///
    @IBOutlet weak var score: UILabel!
    
    ///
    @IBOutlet weak var btn: UIButton!
    
    ///
    @IBOutlet weak var backBtn: UIButton!
    
    ///
    @IBOutlet weak var gameRemainingTime: UILabel!
    
    
    //MARK: - Methods
    
    ///Returns storyboard instance associated with this class
    static func sbInstance() -> ViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        return sb.instantiateInitialViewController() as! ViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        let filemgr = FileManager.default
        
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        let docsDir = dirPaths[0].path
        
        if filemgr.changeCurrentDirectoryPath(docsDir) {
            
            print("\n\n\n\nSUCCESS\n\n\n\n")
            read2Array(selectedCategory + ".txt", array: &words)
            words.shuffle()
            if motionManager.isDeviceMotionAvailable {
                motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: { (deviceMotion, error) in
                    self.handleDeviceMotionUpdate(deviceMotion!)
                })
            }
                
            else {
                print("DeviceMotion err")
            }
            print("\n\n\n\nSUCCESS[2]\n\n\n\n")
            
        } else {
            print("\n\n\n\nFUCK\n\n\n\n")
        }
        
        
    }
    
    func setupView() {
        backBtn.layer.cornerRadius = 5
        //backBtn.layer.borderWidth = 1
        //backBtn.layer.borderColor = UIColor.gray.cgColor
        btn.layer.cornerRadius = 20
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = .rgb(135, green: 206, blue: 250)
    }
    
    func changeRemainingTime() {
        timeLeft -= 1
        gameRemainingTime.text = "\(timeLeft)"
        
        if (timeLeft == 0) {
            timer.invalidate()
            gameRemainingTime.isHidden = true
            score.isHidden = true;
            roundEnded()
        }
    }
    
    func handleDeviceMotionUpdate(_ deviceMotion: CMDeviceMotion) {
        if start {
            if first {
                bb = true;
                view.backgroundColor = .rgb(135, green: 206, blue: 250)
                self.lbl.text = words[words.count - 1]
                words.removeLast()
                first = false;
                self.score.text = "0"
                //TODO: Sound.playSound("start") !IMPORTANT!
                
                gameRemainingTime.isHidden = false
                gameRemainingTime.text = "\(timeLeft)"
                
                startCountDown()
                
            } else {
                let roll = degrees(deviceMotion.attitude.roll)
                
                if (roll > 135 && bb) {
                    //win
                    Sound.playSound("win")
                    view.backgroundColor = .green
                    bb = false
                    scoreint += 1
                    self.score.text = String(scoreint)
                    
                } else if (roll < 35 && bb) {
                    //loose
                    Sound.playSound("loose")
                    view.backgroundColor = .red
                    bb = false;
                    
                } else if (roll > 60 && roll < 100 && !bb) {
                    
                    if (words.count > 0) {
                        bb = true;
                        view.backgroundColor = .rgb(135, green: 206, blue: 250)
                        //if ran out of words??
                        self.lbl.text = words[words.count - 1]
                        words.removeLast()
                    }
                    else {
                        roundEnded()
                    }
                }
            }
        }
    }
    
    
    //MARK: - Timer-related functions
    
    func startCountDown() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeRemainingTime), userInfo: nil, repeats: true)
    }
    
    func timerAction() {
        counter += 1
        
        if (counter < 4) {
            self.lbl.text = "\(counter)"
        }
        else {
            start = true
            timer.invalidate()
        }
    }
    
    func roundEnded() {
        start = false
        self.lbl.textColor = .white
        self.lbl.text = "Your score is \(scoreint)"
        
    }
    
    
    //MARK: - Storyboard button callbacks
    
    @IBAction func backButtonDidTapped(_ sender: UIButton) {
        categoriesVC = Categories.sbInstance()
        
        present(categoriesVC!, animated: true, completion: nil)
    }
    
    @IBAction func btn(_ sender: Any) {
        btn.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    
    //MARK: - Functions-helpers
    
    ///
    func degrees(_ radians: Double) -> Double {
        return 180 / M_PI * radians
    }
}
