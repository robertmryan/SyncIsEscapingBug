//
//  ViewController.swift
//  SyncIsEscapingBug
//
//  Created by Robert Ryan on 7/1/20.
//  Copyright © 2020 Robert Ryan. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let bug = Bug()
        
        bug.ok()    // this is fine
        bug.crash() // this generates Swift runtime error; see Bug.swift
    }
    
}
