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
    var lumps = Double(10000)
    var lps = Double(0) // lumps per second
    var lumpName = "lump"
    
    // Price=Base cost×1.15^(M−F) M = number type currently owned, F = number for free
    var items = ["Cursor", "Grandma", "Farm", "Mine", "Factory", "Bank", "Temple", "Wizard Tower", "Shipment", "Alchemy Lab", "Portal", "Time Machine", "Antimatter Condensor", "Prism", "Chancemaker", "Fractal Engine", "Javascript Console"]
    var itemCosts = [Double(15), Double(100), Double(1100), Double(12000), Double(130000), Double(1400000), Double(20000000), Double(330000000), Double(5100000000), Double(75000000000), Double(1000000000000), Double(14000000000000), Double(170000000000000), Double(2100000000000000), Double(26000000000000000), Double(310000000000000000), Double(71000000000000000000)]
    var itemProductions = [Double(0.1), Double(1), Double(8), Double(47), Double(260), Double(1400), Double(7800), Double(44000), Double(260000), Double(1600000), Double(10000000), Double(65000000), Double(430000000), Double(2900000000), Double(21000000000), Double(150000000000), Double(1100000000000)]
    var itemQuantities = [Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0), Double(0)]
    var itemLevels = [[Int]]()
    
    // App Buttons
    var clicker = UIButton()
    var openShopButton = UIButton()
    var closeShopButton = UIButton()
    
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
        lumpsDisplay.numberOfLines = 2
        updateLumpDisplay()
//        lumpsDisplay.text = lumpName + "s: " + String(Int(lumps)) + "\n" + lumpName + "s per second: " + String(Int(lps))
        
        lumpsDisplay.textAlignment = .center
        self.view.addSubview(lumpsDisplay)
        
        openShopButton = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth/2, height: screenHeight/8))
        openShopButton.center = CGPoint(x:  screenWidth/2, y:  screenHeight*15/16)
        openShopButton.layer.backgroundColor = UIColor.gray.cgColor
        openShopButton.layer.borderColor = UIColor.black.cgColor
        openShopButton.layer.borderWidth = 1
        openShopButton.setTitle("Shop", for: .normal)
        openShopButton.addTarget(self, action: #selector(openShop), for: .touchUpInside)
        self.view.addSubview(openShopButton)
        
        shopView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth/2, height: screenHeight/2))
        shopView.contentSize = CGSize(width: screenWidth/2, height: screenHeight/8*CGFloat(items.count))
        shopView.center = CGPoint(x: screenWidth/2, y: screenHeight/2)
        shopView.layer.backgroundColor = UIColor.green.cgColor
        self.view.addSubview(shopView)
        
        closeShopButton = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth/2, height: screenHeight/16))
        closeShopButton.center = CGPoint(x:  screenWidth/2, y: shopView.frame.minY - closeShopButton.frame.height/2)
        closeShopButton.layer.backgroundColor = UIColor.gray.cgColor
        closeShopButton.layer.borderColor = UIColor.black.cgColor
        closeShopButton.layer.borderWidth = 1
        closeShopButton.setTitle("Close", for: .normal)
        closeShopButton.addTarget(self, action: #selector(closeShop), for: .touchUpInside)
        self.view.addSubview(closeShopButton)
        
        initializeShop()
        
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(incrementLps), userInfo: nil, repeats: true)
        

    }
    @objc func incrementLps()
    {
        print("Fire")
        lumps += lps
        updateLumpDisplay()
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
        shopView.center.y += screenHeight
        shopView.isHidden = true
        closeShopButton.center.y += screenHeight
        closeShopButton.isHidden = true
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
//            itemLevels[num][Int(itemQuantities[num])] += 1
            lps += itemProductions[num]
            updateLumpDisplay()
        }
        else
        {
            print("Can't afford that")
        }
    }
    @objc func click()
    {
        lumps += 1
        updateLumpDisplay()
    }
    func roundfff(x: Double, y: Double)
    {
//        let z = Double(round(1000*x)/1000)
//        print(z)
    }
    func updateLumpDisplay()
    {
        let lumps2 = String(format: "%.1f", lumps)
        let lps2 = String(format: "%.1f", lps)

        lumpsDisplay.text = lumpName + "s: " + String(lumps2) + "\n" + lumpName + "s per second: " + String(lps2)
    }
    @objc func openShop()
    {
        // Disable other Buttons (clicker, openShop)
        clicker.isEnabled = false
        openShopButton.isEnabled = false
        // Unhide Shop + close button
        shopView.isHidden = false
        closeShopButton.isHidden = false
        // Transform/slide shop
        shopView.center.y -= screenHeight
        closeShopButton.center.y -= screenHeight
    }
    @objc func closeShop()
    {
        // Enable other Buttons (clicker, openShop)
        clicker.isEnabled = true
        openShopButton.isEnabled = true
        // Transform/slide shop back
        shopView.center.y += screenHeight
        closeShopButton.center.y += screenHeight
        // Hide Shop
        shopView.isHidden = true
        closeShopButton.isHidden = true
    }
}

