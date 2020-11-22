//
//  ListTableViewController.swift
//  Fetch Rewards
//
//  Created by Moazam Mir on 11/20/20.
//

import UIKit

class ListTableViewController: UITableViewController {

    var itemArray = [HiringData]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
    }

    // MARK: - Table view data source
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        if itemArray.count != 0
        {
            cell.textLabel?.text = itemArray[indexPath.row].name

        }
        
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
