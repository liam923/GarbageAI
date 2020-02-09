//
//  HomeViewController.swift
//  GarbageAI
//
//  Created by Liam Stevenson on 2/8/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UITableViewController {
    
    let rewardFrequency = 10
    
    let countSection = 1
    let historySection = 2
    
    var listener: ListenerRegistration?
    var trash = [Trash]()
    var counts = [(TrashType, Int)]()
    
    var totalCount: Int { self.counts.reduce(0, {$0 + ($1.0 == .trash ? 0 : $1.1)}) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        listener = Database.shared.getCounts { counts in
            self.counts = counts.map({($0.key, $0.value)}).sorted(by: {$0.0.rawValue < $1.0.rawValue})
            self.tableView.reloadData()
            
            if self.totalCount % self.rewardFrequency == 0 {
                let alert = UIAlertController(title: "You got a reward!", message: "You got an award for recycling.", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Decline", style: .cancel, handler: nil))

                self.present(alert, animated: true)
            }
        }
        
        Database.shared.getHistory { (trash) in
            self.trash = trash
            self.tableView.reloadData()
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "signOut", sender: self)
        } catch {
            // error occured signing out
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case countSection:
            return counts.count
        case historySection:
            return trash.count
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == historySection || indexPath.section == countSection {
            return super.tableView(tableView, heightForRowAt: indexPath)
        } else {
            return 300.0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == historySection {
            let cell = tableView.dequeueReusableCell(withIdentifier: "trash", for: indexPath)

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.doesRelativeDateFormatting = true
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            let time = trash[indexPath.row].time
            let timeStr = "\(dateFormatter.string(from: time)), \(timeFormatter.string(from: time))"

            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy HH:mm"

            (cell.viewWithTag(1) as! UILabel).text = trash[indexPath.row].type.pretty()
            (cell.viewWithTag(2) as! UILabel).text = timeStr
            
            return cell
        } else if indexPath.section == countSection {
            let cell = tableView.dequeueReusableCell(withIdentifier: "count", for: indexPath)
            
            let (type, count) = counts[indexPath.row]
            (cell.viewWithTag(1) as! UILabel).text = "\(type.pretty()): \(count)"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profile", for: indexPath)
            
            let remaning = rewardFrequency - (self.totalCount % rewardFrequency)
            (cell.viewWithTag(1) as! UILabel).text = Auth.auth().currentUser?.displayName ?? ""
            (cell.viewWithTag(2) as! UILabel).text = "You need \(remaning) more point\(remaning == 1 ? "" : "s") for a reward."
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == historySection {
            performSegue(withIdentifier: "profileToMap", sender: trash[indexPath.row])
        } else if indexPath.section == countSection {
            tableView.deselectRow(at: indexPath, animated: false)
        } else {
            performSegue(withIdentifier: "explore", sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case countSection:
            return "Score"
        case historySection:
            return "History"
        default:
            return nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? TrashViewController, let sender = (sender ?? 0) as? Trash, segue.identifier == "profileToMap" {
            target.trash = sender
        }
    }
    
    deinit {
        listener?.remove()
    }
    
}

