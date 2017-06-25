import UIKit

class Welcome: UIViewController {
    
    @IBOutlet weak var logoImgV: UIImageView!
    
    @IBOutlet weak var categoriesBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    
    var settingsVC: Settings?
    var categoriesVC: Categories?

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsVC = Settings.sbInstance()
        categoriesVC = Categories.sbInstance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///Returns storyboard instance associated with this class
    static func sbInstance() -> Welcome {
        let sb = UIStoryboard(name: String(describing: self), bundle: nil)
        return sb.instantiateInitialViewController() as! Welcome
    }
    
    @IBAction func categoriesButtonDidTap(_ sender: UIButton) {
        guard categoriesVC != nil else {return}        
        present(categoriesVC!, animated: true, completion: nil)
    }
    
    @IBAction func settingsButtonDidTap(_ sender: UIButton) {
        guard settingsVC != nil else {return}
        present(settingsVC!, animated: true, completion: nil)
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
