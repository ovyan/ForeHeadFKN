import UIKit

class Settings: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    
    var welcomeVC: Welcome?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeVC = Welcome.sbInstance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///Returns storyboard instance associated with this class
    static func sbInstance() -> Settings {
        let sb = UIStoryboard(name: String(describing: self), bundle: nil)
        return sb.instantiateInitialViewController() as! Settings
    }
    
    @IBAction func backButtonDidTap(_ sender: UIButton) {
        
        guard welcomeVC != nil else {return}
        
        present(welcomeVC!, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
