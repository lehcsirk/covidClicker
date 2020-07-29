//
//  ViewController.swift
//  covidClicker
//
//  Created by Cameron Krischel on 7/28/20.
//  Copyright © 2020 Cameron Krischel. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    // Screen Stuff
    let screenSize = UIScreen.main.bounds
    var screenWidth = CGFloat(0)
    var screenHeight = CGFloat(0)
    
    // App Global Variables
    var lumps = 0
    var lumpName = "lump"
    
    // App Globally Accessible Entities
    var clicker = UIButton()
    var lumpsDisplay = UILabel()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        clicker = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth*3/4, height: screenWidth*3/4))
        clicker.center = CGPoint(x:  screenWidth/2, y:  screenHeight/2)
        clicker.layer.cornerRadius = clicker.frame.width/2
        clicker.layer.backgroundColor = UIColor.gray.cgColor
        clicker.layer.borderColor = UIColor.black.cgColor
        clicker.layer.borderWidth = 1
        clicker.addTarget(self, action: #selector(click), for: .touchUpInside)
        self.view.addSubview(clicker)
        
        lumpsDisplay = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth/2, height: screenHeight/8))
        lumpsDisplay.center = CGPoint(x: screenWidth/2, y: screenHeight/8)
        lumpsDisplay.layer.backgroundColor = UIColor.gray.cgColor
        lumpsDisplay.layer.borderColor = UIColor.black.cgColor
        lumpsDisplay.layer.borderWidth = 1
        lumpsDisplay.text = lumpName + "s: 0"
        self.view.addSubview(lumpsDisplay)
    }
    @objc func click()
    {
        lumps += 1
        lumpsDisplay.text = lumpName + "s: " + String(lumps)
    }
}

