//
//  Preferences.swift
//  ForeheadDemo
//
//  Created by Евгений on 04.11.16.
//  Copyright © 2016 Mike Ovyan. All rights reserved.
//

import UIKit

open class Preferences: NSObject {
    
    static func setHighScoreFor(_ category: String, score: Int) -> Bool {
        UserDefaults.standard.set(score, forKey: category)
        
        return UserDefaults.standard.synchronize()
    }
    
    static func getHighScoreFor(_ category: String) -> Int {
        return UserDefaults.standard.value(forKey: category) as? Int ?? -1
    }
    
}
