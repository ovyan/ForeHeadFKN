import UIKit

let appKey = "iNDexCore"

extension UIColor {
    static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}

extension NSObject {
    func read2Array(_ path: String, array: inout [String]) {
        var items = try? String(contentsOfFile: path).components(separatedBy: "\n")
        items?.removeLast()
        array = items ?? []
    }
    
    func read2Array(_ path: URL, array: inout [String]) {
        var items = try? String(contentsOf: path).components(separatedBy: "\n")
        items?.removeLast()
        array = items ?? []
    }
}


extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (unshuffledCount, firstUnshuffled) in zip(stride(from: c, to: 1, by: -1), indices) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}
