//
//  ViewController.swift
//  Genome
//
//  Created by Logan Wright on 4/18/15.
//  Copyright (c) 2015 lowriDevs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let event = GHEvent.gm_mappedObjectWithJsonRepresentation(GITHUB_EVENT_EXAMPLE_JSON)
        println(event.gm_mappableDescription())
        println(event.actor?.gm_mappableDescription())
        println("\n\nYou can find more by runnint `GenomeTests` with CMD + U\n\n")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

