//
//  ViewController.swift
//  covidClicker
//
//  Created by Cameron Krischel on 7/28/20.
//  Copyright © 2020 Cameron Krischel. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore

class ViewController: UIViewController
{
    let defaults = UserDefaults.standard

    // Screen Stuff
    let screenSize = UIScreen.main.bounds
    var screenWidth = CGFloat(0)
    var screenHeight = CGFloat(0)
    
    // Timer stuff
    var timerRate = 10.0
    var orbitDuration = 10.0
    var timeSpent = 0.0
    var startTime = Double(Date().timeIntervalSince1970)
    
    // App Global Variables
    var lumps = Double(0)
    var lps = Double(0) // lumps per second
    var lumpName = "lump"
    
    // Items
    var items = ["Handshaker", "Boomer", "Gym", "Bar", "Park", "Theatre", "Concert", "Sports Stadium", "Amusement Park", "Airport", "Science Lab", "Propoganda", "Mask Defabricator", "Vaccine Nullifier", "Pandemic", "Alien Contact", "CRISPR"]
    var baseItemCosts = [Double(15), Double(100), Double(1100), Double(12000), Double(130000), Double(1400000), Double(20000000), Double(330000000), Double(5100000000), Double(75000000000), Double(1000000000000), Double(14000000000000), Double(170000000000000), Double(2100000000000000), Double(26000000000000000), Double(310000000000000000), Double(71000000000000000000)]
    var itemCosts = [Double(15.0), Double(100.0), Double(1100.0), Double(12000.0), Double(130000.0), Double(1400000.0), Double(20000000.0), Double(330000000.0), Double(5100000000.0), Double(75000000000.0), Double(1000000000000.0), Double(14000000000000.0), Double(170000000000000.0), Double(2100000000000000.0), Double(26000000000000000.0), Double(310000000000000000.0), Double(71000000000000000000.0)]
    var itemProductions = [Double(0.1), Double(1), Double(8), Double(47), Double(260), Double(1400), Double(7800), Double(44000), Double(260000), Double(1600000), Double(10000000), Double(65000000), Double(430000000), Double(2900000000), Double(21000000000), Double(150000000000), Double(1100000000000)]
    var itemLevels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var itemColors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.orange, UIColor.purple, UIColor.yellow, UIColor.red, UIColor.blue, UIColor.green, UIColor.orange, UIColor.purple, UIColor.yellow, UIColor.red, UIColor.blue, UIColor.green, UIColor.orange, UIColor.purple, UIColor.yellow, UIColor.red, UIColor.blue]
    
    // App Buttons
    var clicker = UIButton()
    var openShopButton = UIButton()
    var closeShopButton = UIButton()
    
    // App Views
    var shopView = UIScrollView()
    var shopButtons = [UIButton]()
    
    // App Labels
    var lumpsDisplay = UILabel()
    var lumpsDisplayBack = UILabel()
    
    // Orbiting labels
    var orbitCursors = [[UILabel]]()
    var circlePath = UIBezierPath()
    var animation = CAKeyframeAnimation()
    
    // Colors
    var myFill = UIColor.gray.cgColor
    var myBord = UIColor.white
    
    // Fonts
    var myFont = UIFont(name: "Courier", size: 50)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.black
        
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        // NSUserDefaults Stuff
        timeSpent = defaults.double(forKey: "timeSpent")
        lumps = defaults.double(forKey: "lumps")
        lps = defaults.double(forKey: "lps")
        itemLevels = defaults.array(forKey: "itemLevels") as? [Int] ?? [Int]()
        
        if(!UserDefaults.exists(key: "startTime"))
        {
            defaults.set(startTime, forKey:"startTime")
        }
        else
        {
            startTime = defaults.double(forKey: "startTime")
            var timeElapsed = Double(Date().timeIntervalSince1970) - startTime
            if(timeElapsed > timeSpent)
            {
                lumps += lps * (timeElapsed - timeSpent)
                timeSpent = timeElapsed
            }
        }
        
        if(itemLevels.count <= 0)
        {
            itemLevels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        }
        
        clicker = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth*3/4, height: screenWidth*3/4))
        clicker.center = CGPoint(x:  screenWidth/2, y:  screenHeight/2)
        clicker.layer.cornerRadius = clicker.frame.width/2
        clicker.layer.backgroundColor = myFill
        clicker.layer.borderColor = myBord.cgColor
        clicker.layer.borderWidth = 1
        clicker.layer.zPosition = -2
        clicker.addTarget(self, action: #selector(click), for: .touchUpInside)
        self.view.addSubview(clicker)
        
        lumpsDisplay = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth/2, height: screenHeight/8))
        lumpsDisplay.center = CGPoint(x: screenWidth/2, y: screenHeight/8)
        lumpsDisplay.layer.backgroundColor = myFill
        lumpsDisplay.numberOfLines = 3
        lumpsDisplay.textColor = myBord
        lumpsDisplay.textAlignment = .center
        lumpsDisplay.adjustsFontSizeToFitWidth = true
        lumpsDisplay.font = myFont
        self.view.addSubview(lumpsDisplay)
        
        lumpsDisplayBack = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth/2*1.5, height: screenHeight/8*1.5))
        lumpsDisplayBack.center = CGPoint(x: screenWidth/2, y: screenHeight/8)
        lumpsDisplayBack.layer.backgroundColor = myFill
        lumpsDisplayBack.layer.borderColor = myBord.cgColor
        lumpsDisplayBack.layer.borderWidth = 1
        lumpsDisplayBack.numberOfLines = 2
        lumpsDisplayBack.textColor = myBord
        lumpsDisplayBack.textAlignment = .center
        lumpsDisplayBack.adjustsFontSizeToFitWidth = true
        lumpsDisplayBack.layer.zPosition = -1
        self.view.addSubview(lumpsDisplayBack)
        
        openShopButton = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth/2, height: screenHeight/8))
        openShopButton.center = CGPoint(x:  screenWidth/2, y:  screenHeight*15/16)
        openShopButton.layer.backgroundColor = myFill
        openShopButton.layer.borderColor = myBord.cgColor
        openShopButton.layer.borderWidth = 1
        openShopButton.setTitle("Shop", for: .normal)
        openShopButton.addTarget(self, action: #selector(openShop), for: .touchUpInside)
        self.view.addSubview(openShopButton)
        
        shopView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth/2, height: screenHeight/2))
        shopView.contentSize = CGSize(width: screenWidth/2, height: screenHeight/8*CGFloat(items.count))
        shopView.center = CGPoint(x: screenWidth/2, y: screenHeight/2)
        shopView.layer.backgroundColor = myFill
        shopView.layer.borderColor = myBord.cgColor
        shopView.layer.borderWidth = 1.0
        shopView.layer.backgroundColor = myFill
        shopView.layer.zPosition = 1
        self.view.addSubview(shopView)
        
        closeShopButton = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth/2, height: screenHeight/16))
        closeShopButton.center = CGPoint(x:  screenWidth/2, y: shopView.frame.maxY + closeShopButton.frame.height/2)
        closeShopButton.layer.backgroundColor = myFill
        closeShopButton.layer.borderColor = myBord.cgColor
        closeShopButton.layer.borderWidth = 1
        closeShopButton.setTitle("Close", for: .normal)
        closeShopButton.addTarget(self, action: #selector(closeShop), for: .touchUpInside)
        self.view.addSubview(closeShopButton)
        
        initializeShop()
        updateLumpDisplay()
        
        let timer = Timer.scheduledTimer(timeInterval: 1.0/timerRate, target: self, selector: #selector(incrementLps), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        
        for i in 0...items.count - 1
        {
            orbitCursors.append([])
        }
        for i in 0...itemLevels.count - 1
        {
            if(itemLevels[i] > 0)
            {
                for j in 0...itemLevels[i] - 1
                {
                    addItem(item: items[i])
                }
            }
        }
        if(orbitCursors.count > 0)
        {
            for i in 0...orbitCursors.count - 1
            {
                if(orbitCursors[i].count > 0)
                {
                    for i in 0...orbitCursors[i].count - 1
                    {
                        doAnimations()
                        break
                    }
                }
            }
        }
        updateCosts()
    }
    func updateCosts()
    {
        for i in 0...baseItemCosts.count - 1
        {
            itemCosts[i] = baseItemCosts[i] * pow(1.15, Double(itemLevels[i]))
        }
    }
    @objc func incrementLps()
    {
        lumps += lps/timerRate
        updateLumpDisplay()
        timeSpent += 1.0/timerRate
        
        defaults.set(timeSpent, forKey: "timeSpent")
        defaults.set(lumps, forKey: "lumps")
        defaults.set(lps, forKey: "lps")
        defaults.set(itemLevels, forKey: "itemLevels")
        defaults.set(startTime, forKey: "startTime")
        
        if(!UserDefaults.exists(key: "startTime"))
        {
            defaults.set(startTime, forKey:"startTime")
        }
        else
        {
            startTime = defaults.double(forKey: "startTime")
            var timeElapsed = Double(Date().timeIntervalSince1970) - startTime
            if(timeElapsed > timeSpent)
            {
                lumps += lps * (timeElapsed - timeSpent)
                timeSpent = timeElapsed
            }
        }
    }
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    func initializeShop()
    {
        for i in 0...items.count - 1
        {
            var button = UIButton(frame: CGRect(x: CGFloat(0), y: CGFloat(i)*shopView.contentSize.height/CGFloat(items.count), width: shopView.contentSize.width, height: shopView.contentSize.height/CGFloat(items.count)))
            button.titleLabel?.numberOfLines = 5
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.adjustsFontForContentSizeCategory = true
            
            let roundCost = String(format: "%.1f", itemCosts[i])
            button.setTitle(items[i] + "\nCost: " + roundCost + "\nLevel: " + String(itemLevels[i]), for: .normal)
            button.layer.borderColor = myBord.cgColor
            button.layer.borderWidth = 1.0

            button.addTarget(self, action: #selector(buyItem), for: .touchUpInside)
            shopView.addSubview(button)
            shopButtons.append(button)
        }
        shopView.center.y += screenHeight
        shopView.isHidden = true
        closeShopButton.center.y += screenHeight
        closeShopButton.isHidden = true
    }
    @objc func buyItem(sender: UIButton)
    {
        var itemName = String(sender.titleLabel!.text!)
        let index = itemName.index(of: " Level")!
        itemName = String(itemName[...index])
        itemName = itemName.substring(to: itemName.index(before: itemName.endIndex))
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
            lumps -= round(itemCosts[num])
            itemLevels[num] += 1
            itemCosts[num] = baseItemCosts[num] * pow(1.15, Double(itemLevels[num]))
            lps += itemProductions[num]
            updateLumpDisplay()
            addItem(item: items[num])
        }
    }
    func addItem(item: String)
    {
        for i in 0...items.count - 1
        {
            if(item == items[i])
            {
                var cursor = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth/8, height: screenWidth/8))
                cursor.layer.cornerRadius = cursor.frame.width/2
                cursor.layer.borderWidth = 1
                cursor.layer.borderColor = itemColors[i].cgColor
                cursor.layer.backgroundColor = UIColor.white.cgColor
                cursor.layer.zPosition = -1
                self.view.addSubview(cursor)
                orbitCursors[i].append(cursor)
                print("Added a " + items[i])
            }
        }
        doAnimations()
    }
    func doAnimations()
    {
        print("In anim")
        if(orbitCursors.count > 0)
        {
            var smallRadius = CGFloat(0)
            smallRadius = (screenWidth - clicker.frame.width)/2
            if(orbitCursors[0].count > 10)
            {
                smallRadius *= 0.975
            }
            var radius = (clicker.frame.width/2 + smallRadius/2)
            var isClockwise = true
            for i in 0...orbitCursors.count - 1
            {
                if(orbitCursors[i].count > 0)
                {
                    for j in 0...orbitCursors[i].count - 1
                    {
                        orbitCursors[i][j].frame.size.width = smallRadius
                        orbitCursors[i][j].frame.size.height = smallRadius
                        orbitCursors[i][j].layer.cornerRadius = smallRadius/2
                        
                        var mycirclePath = UIBezierPath()
                        let myStart = .pi*2/CGFloat(orbitCursors[i].count)*CGFloat(j)
                        let myEnd = .pi*2 + .pi*2/CGFloat(orbitCursors[i].count)*CGFloat(j)
                        if(isClockwise)
                        {
                        mycirclePath = UIBezierPath(arcCenter: view.center, radius: radius, startAngle: myStart, endAngle: myEnd, clockwise: isClockwise)
                        }
                        else
                        {
                            mycirclePath = UIBezierPath(arcCenter: view.center, radius: radius, startAngle: myEnd, endAngle: myStart, clockwise: isClockwise)
                        }
                        var myanimation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
                        myanimation.duration = orbitDuration
                        myanimation.repeatCount = MAXFLOAT
                        myanimation.path = mycirclePath.cgPath
                        myanimation.isRemovedOnCompletion = false
                        orbitCursors[i][j].layer.add(myanimation, forKey: nil)
                    }
                    radius -= smallRadius
                    smallRadius *= 0.75
                    isClockwise = !isClockwise
                }
            }
        }
    }
    @objc func click()
    {
        lumps += 1
        updateLumpDisplay()
    }
    func updateLumpDisplay()
    {
        let lumps2 = String(format: "%.1f", lumps)
        let lps2 = String(format: "%.1f", lps)
        let time2 = String(format: "%.1f", timeSpent)
        lumpsDisplay.text = "time elapsed: " + time2 + "\n" + lumpName + "s: " + String(lumps2) + "\n" + lumpName + "s per second: " + String(lps2)
        for i in 0...shopButtons.count - 1
        {
            let miniLps = String(format: "%.1f", Double(itemProductions[i]))
            let miniLps2 = String(format: "%.1f", Double(itemLevels[i])*itemProductions[i])
            let roundCost = String(format: "%.1f", itemCosts[i])
            shopButtons[i].setTitle(items[i] + " Level: " + String(itemLevels[i]) + "\nCost: " + roundCost + "\nLps: " + miniLps + "\nTotal Lps: " + miniLps2, for: .normal)
        }
    }
    @objc func openShop()
    {
        // Disable other Buttons (clicker, openShop)
        clicker.isEnabled = false
        openShopButton.isEnabled = false
        
        // Unhide Shop + close button
        shopView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
        shopView.isHidden = false
        closeShopButton.isHidden = false
        
        // Transform/slide shop
        UIView.animate(withDuration: 0.6,
        animations:
        {
            self.shopView.transform = CGAffineTransform(translationX: 0, y: -1*self.screenHeight)
            self.closeShopButton.transform = CGAffineTransform(translationX: 0, y: -1*self.screenHeight)
        },
        completion: { _ in
            UIView.animate(withDuration: 0) {
            }
        })
    }
    @objc func closeShop()
    {
        // Transform/slide shop back
        UIView.animate(withDuration: 0.4,
        animations:
        {
            self.shopView.transform = CGAffineTransform(translationX: 0, y: self.screenHeight)
            self.closeShopButton.transform = CGAffineTransform(translationX: 0, y: self.screenHeight)
        },
        completion: { _ in
            UIView.animate(withDuration: 0)
            {
                // Hide Shop
                self.shopView.isHidden = true
                self.closeShopButton.isHidden = true
                // Enable other Buttons (clicker, openShop)
                self.clicker.isEnabled = true
                self.openShopButton.isEnabled = true
            }
        })
        
    }
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
}
extension UserDefaults
{
    static func exists(key: String) -> Bool
    {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
extension StringProtocol
{
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index?
    {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index?
    {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index]
    {
        var indices: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options)
            {
                indices.append(range.lowerBound)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
            }
        return indices
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options)
            {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
            }
        return result
    }
}
