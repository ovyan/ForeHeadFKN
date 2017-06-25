import UIKit

open class WriteManager: NSObject {
    
    func addDefaultCategories() {
        let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Categories", ofType: "txt")!))
        
        let filemgr = FileManager.default
        
        let docsPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let categoriesPath = docsPaths?.appendingPathComponent("Categories");
        
        //try! data?.write(to: categoriesPath!);
        
        var categories = [String]()
        //read2Array((categoriesPath?.absoluteString)!, array: &categories)
        read2Array(categoriesPath!, array: &categories)
    }
    
    func addCategory(_ name: String) {
        
        let filemgr = FileManager.default
        let docsPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask).first
        let categoriesPath = docsPaths?.appendingPathComponent("Categories");
        filemgr.createFile(atPath: (docsPaths?.appendingPathComponent(name).relativePath)!, contents: nil, attributes: nil)
        
        var categories = [String]()
        read2Array(categoriesPath!, array: &categories)
        let newCategory = name
        categories.append(newCategory)
        categories.append("\n")
        
        let categoriesString = String(describing: categories);
        
        try! categoriesString.write(to: categoriesPath!, atomically: true, encoding: .utf8)
        
        
    }
    
    func removeCategory(_ name: String) {
        try? FileManager.default.removeItem(atPath: ourPath! + name)
    }
    
    func addWord2Category(_ category: String, _ word: String) {
        
        let filemgr = FileManager.default
        
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        let docsDir = dirPaths[0].path
        
        if filemgr.changeCurrentDirectoryPath(docsDir) {
            
            print("\n\n\n\nSUCCESS\n\n\n\n")
            var currentWords = try? String(contentsOfFile:category + ".txt")
            let newWord = word + "\n"
            currentWords? += newWord
            try! currentWords?.write(toFile:category + ".txt", atomically: true, encoding: .utf8)
            print("\n\n\n\nSUCCESS[2]\n\n\n\n")
            
        } else {
            print("\n\n\n\nFUCK\n\n\n\n")
        }
    }
    
    func removeWordFromCategory(_ category: String, _ word: String) {
    }

}
