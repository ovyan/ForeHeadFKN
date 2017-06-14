//
//  Categories.swift
//  ForeheadDemo
//
//  Created by Евгений on 03.11.16.
//  Copyright © 2016 Mike Ovyan. All rights reserved.
//

import UIKit
import AVFoundation

class Categories: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var mainVC: ViewController?
    var welcomeVC: Welcome?
    var wordsVC: Words?

    var selectedCategory: String?

    var categories = [String]()

    var audioPlayer: AVAudioPlayer?

    @IBOutlet weak var categoriesTV: UITableView!

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var addNewCategorie: UIButton!

    func setupView() {
        backBtn.layer.cornerRadius = 40
        //backBtn.layer.borderWidth = 1
    }

    static func sbInstance() -> Categories {
        let sb = UIStoryboard(name: String(describing: self), bundle: nil)
        return sb.instantiateInitialViewController() as! Categories
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        let filemgr = FileManager.default
        
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        let docsDir = dirPaths[0].path
        
        if filemgr.changeCurrentDirectoryPath(docsDir) {
            
            print("\n\n\n\nSUCCESS[5]\n\n\n\n")
            read2Array("Categories.txt", array: &categories)
            print("\n\n\n\nSUCCESS[6]\n\n\n\n")
        } else {
            print("\n\n\n\nFUCK\n\n\n\n")
        }

        

        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSessionCategoryAmbient, with: AVAudioSessionCategoryOptions.mixWithOthers)
        //try! audioSession.setCategory(AVAudioSessionCategoryAmbient, with: AVAudioSessionCategoryOptions.duckOthers)

        try! audioSession.setActive(true) // dont change


        let sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "win", ofType: "wav")!)

        audioPlayer = try! AVAudioPlayer(contentsOf: sound as URL, fileTypeHint: "wav")
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catCell", for: indexPath)
        let label = cell.contentView.subviews[0] as? UILabel
        label?.text = categories[indexPath.row]
        label?.layer.borderWidth = 0.5
        label?.layer.borderColor = UIColor.black.cgColor

        let editButton = cell.contentView.subviews[1] as? UIButton
        if (indexPath.row > 1) { //TODO: depends on standard categories
            editButton?.isHidden = false
        }
        editButton?.tag = indexPath.row
        editButton?.addTarget(self, action: #selector(editButtonTap), for: .touchUpInside)

        //present(Words.storyboardInstance(), animated: true, completion: nil)

        return cell
    }

    func editButtonTap(_ sender: UIButton) {
        let wordsVC = Words.storyboardInstance()
        wordsVC.selectedCategory = categories[sender.tag]
        present(wordsVC, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainVC = ViewController.sbInstance()
        mainVC?.selectedCategory = categories[indexPath.row]

        present(mainVC!, animated: true, completion: nil)
    }

    @IBAction func didTapBackBtn(_ sender: UIButton) {
        present(Welcome.sbInstance(), animated: true, completion: nil)
    }
    
    func reloadTV() {
        
        let filemgr = FileManager.default
        
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        let docsDir = dirPaths[0].path
        
        if filemgr.changeCurrentDirectoryPath(docsDir) {
            
            print("\n\n\n\nSUCCESS\n\n\n\n")
            read2Array("Categories.txt", array: &categories)
            self.categoriesTV.reloadData()
            print("\n\n\n\nSUCCESS[2]\n\n\n\n")
            
        } else {
            print("\n\n\n\nFUCK\n\n\n\n")
        }
        
        
    }

    @IBAction func didTapAddNewCategorieBtn(_ sender: UIButton) {

        //check purchase here

        if (true) { //had purchased

            let alert = UIAlertController(title: "Category", message: "add new", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.addAction(UIAlertAction(title: "ADD", style: .default, handler: { (action) in
                if let textField = alert.textFields?[0].text as String! {
                    WriteManager().addCategory(textField)
                    
                    let filemgr = FileManager.default
                    
                    let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
                    
                    let docsDir = dirPaths[0].path
                    
                    if filemgr.changeCurrentDirectoryPath(docsDir) {
                        
                        print("\n\n\n\nSUCCESS\n\n\n\n")
                        var cats = try! String(contentsOfFile:"Categories.txt").components(separatedBy: "\n")
                        cats.removeLast()
                        self.categories = cats
                        self.categoriesTV.reloadData()
                        
                        self.reloadTV()
                        
                        self.resignFirstResponder()
                        print("\n\n\n\nSUCCESS[2]\n\n\n\n")
                        
                    } else {
                        print("\n\n\n\nFUCK\n\n\n\n")
                    }
                }

            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

            self.present(alert, animated: true, completion: nil)

            //check for existing category

        }
            else {
            let alert = UIAlertController(title: "Want more fun?", message: "Buy for onyl 0.99$", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "TAKE MY MONEY!", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func createCategoryFile(_ newCategory: String) {
        let newCategoryS = newCategory + "\n"

        let path = Bundle.main.path(forResource: "Categories", ofType: "txt")!

        var currentCategories = try! String(contentsOfFile: path)

        if (!currentCategories.contains(newCategoryS)) {
            currentCategories += newCategoryS
            try! currentCategories.write(to: URL(fileURLWithPath: path), atomically: false, encoding: .utf8)

            let fManager = FileManager.default
            print(fManager.createFile(atPath: (Bundle.main.bundlePath) + "/" + newCategory + ".txt", contents: nil, attributes: nil))

            read2Array(path, array: &categories)
            self.categoriesTV.reloadData()
        }
            else {
            print("already added")
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
