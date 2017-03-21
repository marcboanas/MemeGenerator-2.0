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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        memeImageView.contentMode = .scaleAspectFit
        memeImageView.image = UIImage(data: meme.memedImage! as Data)
    }

}
