//
//  ViewController.swift
//  Test
//
//  Created by Fxxx on 2018/11/30.
//  Copyright © 2018 Aaron Feng. All rights reserved.
//

import UIKit

let SCREENWIDTH = UIScreen.main.bounds.width
let SCREENHEIGHT = UIScreen.main.bounds.height

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let frame = CGRect.init(x: 10, y: (SCREENHEIGHT - SCREENWIDTH) / 2.0, width: SCREENWIDTH - 20, height: SCREENWIDTH)
        let sphereView = AASphereView.init(frame: frame)
        self.view.addSubview(sphereView)
        
        var tags = [UIView]()
        for i in 0..<50 {
            
            let button = UIButton.init()
            button.setTitle("aa\(i)", for: .normal)
            button.setTitleColor(UIColor.brown, for: .normal)
            button.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside)
            button.sizeToFit()
            button.tag = i
            tags.append(button)
            
        }
        sphereView.setTagViews(array: tags)
        
    }
    
    @objc func buttonAction(btn: UIButton) {
        print("tap with tag: \(btn.tag)")
    }

}

