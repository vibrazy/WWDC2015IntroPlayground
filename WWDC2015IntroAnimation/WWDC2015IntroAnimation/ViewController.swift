//
//  ViewController.swift
//  WWDC2015IntroAnimation
//
//  Created by Daniel Tavares on 23/06/2015.
//  Copyright (c) 2015 Daniel Tavares. All rights reserved.
//

import UIKit
import QuartzCore


class ViewController: UIViewController {

  var apple : UIImageView = UIImageView(image: UIImage(named: "apple"))
    
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let containerView = ContainerView(frame: view.bounds)
    view.addSubview(containerView)
   
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}


