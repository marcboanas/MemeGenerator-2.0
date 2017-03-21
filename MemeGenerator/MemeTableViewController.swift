//
//  MemeTableViewController.swift
//  MemeGenerator
//
//  Created by Marc Boanas on 17/03/2017.
//  Copyright © 2017 Marc Boanas. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var memes: [Meme] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getData()
        tableView.reloadData()
    }
    
    // MARK: UITableViewData Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell") as! MemeCustomTableViewCell
        let meme = memes[indexPath.row]
        
        if let topText = meme.topText, let bottomText = meme.bottomText, let date = meme.createdDate {
            cell.topTextLabel.text = "\(topText)"
            cell.bottomTextLabel.text = "\(bottomText)"
            
            // Format Date
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd 'at' h:mm"
            cell.dateLabel.text = "\(dateFormat.string(from: date as Date))"
        }
        
        if let memedImageData = meme.memedImage {
            let memedImage = UIImage(data: memedImageData as Data)
            cell.memeImageView?.image = memedImage
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        let meme = memes[indexPath.row]
        detailViewController.meme = meme
        
        // Hides tab bar when pushed to detail controller
        detailViewController.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // Editing Table Cells
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let meme = memes[indexPath.row]
            
            // Delete Meme from core data
            context.delete(meme)
            
            // Remove from memes array
            memes.remove(at: indexPath.row)
            
            // Remove cell from table
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
