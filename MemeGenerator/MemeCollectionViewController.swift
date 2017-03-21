//
//  MemeCollectionViewController.swift
//  MemeGenerator
//
//  Created by Marc Boanas on 13/03/2017.
//  Copyright © 2017 Marc Boanas. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "MemeCollectionCell"

class MemeCollectionViewController: UICollectionViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var memes: [Meme]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getData()
        collectionView!.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCustomCollectionViewCell
        let meme = memes[indexPath.row]
        
        if let memedImageData = meme.memedImage {
            let memedImage = UIImage(data: memedImageData as Data)
            cell.memeImageView?.image = memedImage
            cell.memeImageView.contentMode = UIViewContentMode.scaleAspectFit
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        let meme = memes[indexPath.row]
        detailViewController.meme = meme
        
        // Hides tab bar when pushed to detail controller
        detailViewController.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // Fetch Core Data
    
    func getData() {
        
        // Create request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Meme")
        
        // Sort core data by 'createdDate' - Newest Memes first
        let sortDate = NSSortDescriptor(key: "createdDate", ascending: false)
        request.sortDescriptors = [sortDate]
        
        // Fetch core data
        do {
            memes = try context.fetch(request) as! [Meme]
        } catch {
            print("Error fetching core data: \(error)")
        }
    }
}
