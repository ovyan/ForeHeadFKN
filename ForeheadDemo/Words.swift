//
//  Words.swift
//  ForeheadDemo
//
//  Created by Евгений on 11.11.16.
//  Copyright © 2016 Mike Ovyan. All rights reserved.
//

import UIKit

class Words: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var selectedCategory: String?

    var words = [String]()

    var pathForCategory: String?

    @IBOutlet weak var newWordTF: UITextField!

    @IBOutlet weak var wordsTV: UITableView!


    static func storyboardInstance() -> Words {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as! Words
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if selectedCategory != nil {

            let filemgr = FileManager.default

            let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)

            let docsDir = dirPaths[0].path

            if filemgr.changeCurrentDirectoryPath(docsDir) {

                print("\n\n\n\nSUCCESS\n\n\n\n")
                pathForCategory = selectedCategory! + ".txt"
                read2Array(pathForCategory!, array: &words)
                self.wordsTV.reloadData()
                print("\n\n\n\nSUCCESS[2]\n\n\n\n")

            } else {
                print("\n\n\n\nFUCK\n\n\n\n")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addNewWordTap(_ sender: UIButton) {
        WriteManager().addWord2Category(selectedCategory!, newWordTF.text!)
        read2Array(pathForCategory!, array: &words)
        self.wordsTV.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catCell", for: indexPath)
        let label = cell.contentView.subviews[0] as? UILabel
        label?.text = words[indexPath.row]
        label?.layer.borderWidth = 0.5
        label?.layer.borderColor = UIColor.black.cgColor

        //present(Words.storyboardInstance(), animated: true, completion: nil)

        return cell
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
