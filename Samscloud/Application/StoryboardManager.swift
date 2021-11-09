//
//  StoryBoardManager.swift
//  Samscloud
//
//  Created by An Phan on 1/17/19.
//  Copyright © 2019 Next Idea Tech. All rights reserved.
//

import UIKit

class StoryboardManager: NSObject {
    
    // Type methods
    class func storyBoard(_ name: String) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: nil)
    }
    
    class func getVC(_ storyBoardName: String, name: String) -> UIViewController {
        let storyboard = storyBoard(storyBoardName)
        return storyboard.instantiateViewController(withIdentifier: name)
    }
    
    class func mainStoryBoard() -> UIStoryboard {
        return storyBoard("Main")
    }
    
    class func contactStoryBoard() -> UIStoryboard {
        return storyBoard("Contact")
    }
    
    class func reportsStoryBoard() -> UIStoryboard {
        return storyBoard("Reports")
    }
    
    class func homeStoryBoard() -> UIStoryboard {
        return storyBoard("Home")
    }
    
    class func menuStoryBoard() -> UIStoryboard {
        return storyBoard("Menu")
    }
    
    
    class func dispatchStoryBoard() -> UIStoryboard {
        return storyBoard("Dispatch")
    }
    
    
}
