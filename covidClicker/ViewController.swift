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
    var lumps = Double(0)
    var lumpName = "lump"
    
    // Price=Base cost×1.15^(M−F) M = number type currently owned, F = number for free
    var items = ["Cursor", "Grandma", "Farm", "Mine", "Factory", "Bank", "Temple", "Wizard Tower", "Shipment", "Alchemy Lab", "Portal", "Time Machine", "Antimatter Condensor", "Prism", "Chancemaker", "Fractal Engine", "Javascript Console"]
    var itemCosts = [Double(15), Double(100), Double(1100), Double(12000), Double(130000), Double(1400000), Double(20000000), Double(330000000), Double(5100000000), Double(75000000000), Double(1000000000000), Double(14000000000000), Double(170000000000000), Double(2100000000000000), Double(26000000000000000), Double(310000000000000000), Double(71000000000000000000)]
    var itemProductions = [Double(0.1), Double(1), Double(8), Double(47), Double(260), Double(1400), Double(7800), Double(44000), Double(260000), Double(1600000), Double(10000000), Double(65000000), Double(430000000), Double(2900000000), Double(21000000000), Double(150000000000), Double(1100000000000)]
    var itemQuantities = [Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0)]
    var itemLevels = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
    
    // App Buttons
    var clicker = UIButton()
    var shopButton = UIButton()
    
    // App Views
    var shopView = UIScrollView()
    
    // App Labels
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
        lumpsDisplay.textAlignment = .center
        self.view.addSubview(lumpsDisplay)
        
        shopButton = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth/2, height: screenHeight/8))
        shopButton.center = CGPoint(x:  screenWidth/2, y:  screenHeight*15/16)
        shopButton.layer.backgroundColor = UIColor.gray.cgColor
        shopButton.layer.borderColor = UIColor.black.cgColor
        shopButton.layer.borderWidth = 1
        shopButton.setTitle("Shop", for: .normal)
        shopButton.addTarget(self, action: #selector(openShop), for: .touchUpInside)
        self.view.addSubview(shopButton)
        
        shopView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth/2, height: screenHeight/2))
        shopView.contentSize = CGSize(width: screenWidth/2, height: screenHeight/8*CGFloat(items.count))
        shopView.center = CGPoint(x: screenWidth/2, y: screenHeight/2)
        shopView.layer.backgroundColor = UIColor.green.cgColor
        self.view.addSubview(shopView)
        
        initializeShop()
    }
    func initializeShop()
    {
        for i in 0...items.count - 1
        {
            var button = UIButton(frame: CGRect(x: CGFloat(0), y: CGFloat(i)*shopView.contentSize.height/CGFloat(items.count), width: shopView.contentSize.width, height: shopView.contentSize.height/CGFloat(items.count)))
            button.setTitle(items[i], for: .normal)
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1.0

            button.addTarget(self, action: #selector(buyItem), for: .touchUpInside)
            shopView.addSubview(button)
        }
    }
    @objc func buyItem(sender: UIButton)
    {
        var itemName = String(sender.titleLabel!.text!)
        print(itemName)
        var num = -1
        var canPurchase = false
        for i in 0...items.count - 1
        {
            if(items[i] == itemName)
            {
                num = i
                break
            }
        }
        if(lumps >= itemCosts[num])
        {
            canPurchase = true
        }
        if(canPurchase)
        {
            lumps -= itemCosts[num]
            itemQuantities[num] += 1
            itemLevels[num][itemQuantities[num]] += 1
        }
    }
    @objc func click()
    {
        lumps += 1
        lumpsDisplay.text = lumpName + "s: " + String(lumps)
    }
    @objc func openShop()
    {
        // Disable other Buttons (clicker, openShop)
        clicker.isEnabled = false
        shopButton.isEnabled = false
        // Unhide Shop
        
        // Transform/slide shop
    }
    @objc func closeShop()
    {
        // Enable other Buttons (clicker, openShop)
        
        // Hide Shop
        
        // Transform/slide shop back
    }
}

