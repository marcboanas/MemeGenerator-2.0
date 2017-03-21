//
//  MemeDetailViewController.swift
//  MemeGenerator
//
//  Created by Marc Boanas on 21/03/2017.
//  Copyright © 2017 Marc Boanas. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!

    // MARK: IBOutlets
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImageView.image = UIImage(data: meme.memedImage! as Data)
        memeImageView.contentMode = .scaleAspectFit
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
