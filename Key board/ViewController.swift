//
//  ViewController.swift
//  Key board
//
//  Created by Shashi Kiran Kuppili on 7/30/19.
//  Copyright © 2019 Shashi Kiran Kuppili. All rights reserved.
//

import UIKit
import AVFoundation


struct Size {
    
   static var buttonWidth = { () -> CGFloat in
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 128
        }
        return 64
    }

   static var buttonFontSize = { () -> CGFloat in
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 30
        }
        return 15
    }

    
}


//let buttonWidth: CGFloat = 64

class ViewController: UIViewController {
    
    let gap: CGFloat = 0.2//UIScreen.main.bounds.width / 12
    var indicator:UIImageView?
    var backview: UIView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        
        let playView = PlayBoard(frame: CGRect(x: view.frame.origin.x , y: view.frame.height / 4 , width: view.frame.width, height: view.frame.height - (view.frame.height / 4 )))
//        playView.scrollViewHeight = playView.frame.height - 10.0
        view.addSubview(playView)
    }
    
    
    
    func addPanGesture(forView view: UIView) {
        
        backview.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        backview.addGestureRecognizer(pan)
        
    }
    
    
    @objc func handleGesture(sender: UIPanGestureRecognizer) {
        
        //let indicator = sender.view
        //        let translator = sender.translation(in: backview)
        
        let currentLocation = sender.location(in: backview)
        let xScalefactor = view.frame.width - (2 * gap) //(indicator?.center.x)
        
        if currentLocation.x < 0 || currentLocation.x > xScalefactor {}
        else {
            switch sender.state {
            case .began, .changed:
                indicator?.center = CGPoint(x: currentLocation.x , y: backview.center.y)
                print(currentLocation.x)
            //            sender.setTranslation(.zero, in: view) // for view to bring back to origin if it is left somewhere
            default:
                break
            }
        }
    }
    
    
    
    func setup() {
        
        backview = UIView(frame: CGRect(x: gap , y: 10, width: view.frame.width - (2 * gap), height: view.frame.height / 5))
        backview.backgroundColor = UIColor.brown
        view.addSubview(backview)
        
        let scaleView = UIView(frame: CGRect(x: .zero, y: backview.frame.height - 10, width: backview.frame.width, height: 1.0))
        
        scaleView.backgroundColor = UIColor.black
        backview.addSubview(scaleView)
        
        indicator = UIImageView(frame: CGRect(x: 0 , y: backview.center.y, width: 20, height: 20))
        if let indicator = self.indicator {
            indicator.image = UIImage(named: "indicator")
            indicator.isUserInteractionEnabled = true
            backview.addSubview(indicator)
            
            addPanGesture(forView: indicator)
        }
        
        let lineGap =  backview.frame.width / 64
        let lineHeight = CGFloat(7)
        
        for i in 0..<64 {
            
            if i % 8 == 0 {
                
                let line = UIView(frame: CGRect(x: CGFloat(i) * lineGap  , y: 0, width: 1.0, height: lineHeight * CGFloat(-3)))
                line.backgroundColor = UIColor.black
                scaleView.addSubview(line)
                
                let scaleLabel = UILabel(frame: CGRect(x:  CGFloat(Double(i) + 0.5) * lineGap, y: -20, width: 15, height: 10.0))
                scaleLabel.text = "\(i / 8)"
                scaleLabel.font = UIFont.boldSystemFont(ofSize: 14)
                scaleView.addSubview(scaleLabel)
                
            } else if i % 2 == 0 {
                
                let line = UIView(frame: CGRect(x: CGFloat(i) * lineGap , y: 0, width: 1.0, height: lineHeight * CGFloat(-1.5)))
                line.backgroundColor = UIColor.black
                scaleView.addSubview(line)
                
            } else {
                let line = UIView(frame: CGRect(x: CGFloat(i) * lineGap  , y: 0, width: 1.0, height: -lineHeight))
                line.backgroundColor = UIColor.black
                scaleView.addSubview(line)
            }
        }
        //        let subLine2 = UIView(frame: CGRect(x: 55, y: 0, width: 1.0, height: -10.0))
        //        subLine2.backgroundColor = UIColor.black
        //        scaleView.addSubview(subLine2)
        
    }

}

class PlayBoard: UIView, AVAudioPlayerDelegate {
    
    var scrollViewHeight: CGFloat = 0.0
    var player: AVAudioPlayer?
    var currentAudioFileName: String?
    
    
    lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .black
        v.frame = CGRect(x: 0.0, y: 0, width: self.frame.width, height: self.frame.height - 10.0)
        return v
    }()
    
    func keyButton(setTitle title: String,xPosition x: CGFloat) -> UIView {
        
        let b = UIView()
        b.frame = CGRect(x: x, y: 0, width: Size.buttonWidth() , height: self.frame.height - 10.0)
        b.backgroundColor = .white
        b.layer.borderColor = UIColor.black.cgColor
        b.layer.borderWidth = 0.3
        b.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: self.frame.height - 50.0, width: b.frame.width, height: 20))
        b.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.tag = 20
        let fontsize = Size.buttonFontSize()
        titleLabel.font = UIFont.boldSystemFont(ofSize: fontsize)
        titleLabel.textColor = .darkGray
        
        let button = UIButton(type: .roundedRect)
        button.addTarget(self, action: #selector(handlerForSound), for: .touchUpInside)
        button.addTarget(self, action: #selector(handlerForSound1), for: .touchDown)
//        button.addTarget(self, action: #selector(handlerForSound2), for: .touchCancel)
//        button.addTarget(self, action: #selector(handlerForSound3), for: .touchDragExit)
//        button.addTarget(self, action: #selector(handlerForSound4), for: .touchUpOutside)
//        button.addTarget(self, action: #selector(handlerForSound5), for: .touchDownRepeat)
        button.addTarget(self, action: #selector(handlerForSound5), for: .allEvents)
        button.frame = b.bounds
        b.addSubview(button)
        return b
    }
    
    
    
    func blackKeyButton(setTitle sharpKeyTitle: String, flatKeyTitle:String, xPoition: CGFloat) -> UIView {
        let blackButtonlWidth: CGFloat = Size.buttonWidth() * 0.6
        let blackButtonlHeight: CGFloat = self.frame.height * 0.6

        let b = UIView()
        b.frame = CGRect(x: xPoition, y: 0.0, width: blackButtonlWidth, height: blackButtonlHeight)
        b.backgroundColor = .white
        b.layer.borderColor = UIColor.black.cgColor
        b.layer.borderWidth = 0.3
        b.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        
        let sharptitleLabel = UILabel(frame: CGRect(x: 0, y: b.frame.height - 50.0, width: b.frame.width, height: 20))
        b.addSubview(sharptitleLabel)
        sharptitleLabel.textAlignment = .center
        sharptitleLabel.text = sharpKeyTitle
//        sharptitleLabel.tag = 20
        let fontsize = Size.buttonFontSize()
        sharptitleLabel.font = UIFont.boldSystemFont(ofSize: fontsize)
        sharptitleLabel.textColor = .white
        
        let flattitleLabel = UILabel(frame: CGRect(x: 0, y: b.frame.height - 25.0, width: b.frame.width, height: 20))
        b.addSubview(flattitleLabel)
        flattitleLabel.textAlignment = .center
        flattitleLabel.text = flatKeyTitle
//        flattitleLabel.tag = 20
//        let fontsize = Size.buttonFontSize()
        flattitleLabel.font = UIFont.boldSystemFont(ofSize: fontsize)
        flattitleLabel.textColor = .white

        let button = UIButton(type: .roundedRect)
        button.addTarget(self, action: #selector(handlerForSound), for: .touchUpInside)
        button.addTarget(self, action: #selector(handlerForSound1), for: .touchDown)
        //        button.addTarget(self, action: #selector(handlerForSound2), for: .touchCancel)
        //        button.addTarget(self, action: #selector(handlerForSound3), for: .touchDragExit)
        //        button.addTarget(self, action: #selector(handlerForSound4), for: .touchUpOutside)
        //        button.addTarget(self, action: #selector(handlerForSound5), for: .touchDownRepeat)
        button.addTarget(self, action: #selector(handlerForSound5), for: .allEvents)
        button.frame = b.bounds
        b.addSubview(button)
        return b
    }
    
    
    func playSound(fileName: String) {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            player.delegate = self
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("sound file finished")
        
        if let currentAudioFileName = self.currentAudioFileName {
            playSound(fileName: currentAudioFileName)
        }
    }

    
//    func keyButton(setTitle title: String,xPosition x: CGFloat) -> UIButton {
//        let b = UIButton(type: .roundedRect)
//            b.setTitle(title, for: .normal)
//            b.addTarget(self, action: #selector(handlerForSound), for: .touchUpInside)
//            b.frame = CGRect(x: x, y: 0, width: buttonWidth , height: self.frame.height - 10.0)
//            b.backgroundColor = .white
//            b.layer.borderColor = UIColor.black.cgColor
//            b.layer.borderWidth = 0.3
//            //b.layer.cornerRadius = 10.0
//        b.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
//            return b
//    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        keyboardView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  

    
    
    
    @objc func handlerForSound(sender: UIButton) {
        
        guard let parent = sender.superview else {return}
        
        if let shadeView = parent.viewWithTag(10) {
            if let titleLabel = parent.viewWithTag(20) {
                (titleLabel as! UILabel).textColor = .darkGray
            }
            
            var fileName = ""
            if sender.superview!.tag > 106 {
                fileName = "h\(sender.superview!.tag - 106)"
            }else {
                fileName = "\(sender.superview!.tag - 99)"
            }
            currentAudioFileName = nil

        shadeView.removeFromSuperview()
        } 

        
    }
    @objc func handlerForSound1(sender: UIButton) {
        
        guard let parent = sender.superview else { return }
        let shadeView = UIView(frame: parent.bounds)
        parent.addSubview(shadeView)
        
        
        shadeView.alpha = 0.1
//        shadeView.backgroundColor = .black
        let colours = [UIColor.white.cgColor, UIColor.black.cgColor]
        let layer = CAGradientLayer()
        layer.colors = colours
        layer.frame = shadeView.bounds
        
        shadeView.layer.insertSublayer(layer, at: 0)
        shadeView.tag = 10
        
        
        if let titleLabel = parent.viewWithTag(20) {
            (titleLabel as! UILabel).textColor = .gray
        }

        
        var fileName = ""
        if sender.superview!.tag > 106 {
            fileName = "h\(sender.superview!.tag - 106)"
        }else {
            fileName = "\(sender.superview!.tag - 99)"
        }
        
        currentAudioFileName = fileName
        playSound(fileName: fileName)

        
    }
    @objc func handlerForSound2(sender: UIButton) {

        let parent = sender.superview

    }
    @objc func handlerForSound3(sender: UIButton) {

        let parent = sender.superview

    }
    @objc func handlerForSound4(sender: UIButton) {

        let parent = sender.superview

    }
    @objc func handlerForSound5(sender: UIButton) {

        let parent = sender.superview
print(sender.state)
    }

    
    func keyboardView() {
        
        addSubview(scrollView)

//        addSubview(keyButton())
        let notesArr = ["A", "B", "C", "D", "E", "F", "G"]
        let xPosition: CGFloat = Size.buttonWidth()
        let blackButtonlWidth: CGFloat = Size.buttonWidth() * 0.6
        
        for i in 0..<49 {
            let index = i % 7
            let keyView = keyButton(setTitle: notesArr[index], xPosition: CGFloat(i) * xPosition)
            keyView.tag = i + 100
            scrollView.addSubview(keyView)
        }
        
        for i in 0..<49 {
            
            let index = i % 7
            print(index)
            
            if notesArr[index] == "E" || notesArr[index] == "B" {
                
            }else {
                let flatIndex = (index + 1 < notesArr.count) ? index + 1 : 0
                
                let blackButtonView = blackKeyButton(setTitle: "\(notesArr[index])#", flatKeyTitle: "\(notesArr[flatIndex])b", xPoition: (CGFloat(i + 1) * xPosition) - (blackButtonlWidth / 2))
                blackButtonView.backgroundColor = .black
                blackButtonView.tag = i + 200
                scrollView.addSubview(blackButtonView)
            }
        }

        scrollView.contentSize = CGSize(width: 49 * xPosition, height: scrollView.frame.height)
        scrollView.bounces = false
        scrollView.contentInsetAdjustmentBehavior = .never
        
    }
    
    
}


extension UIView {
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}


