//
//  ViewController.swift
//  Fetch Rewards
//
//  Created by Moazam Mir on 11/19/20.
//

import UIKit

class MainViewController: UITableViewController {
    
    var rawData = [HiringData]()
    var individualCategoryArray = [[HiringData]]()
    var listNames = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

        tableView.rowHeight = 100

    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            return
        }
        
        navBar.backgroundColor = .white
    }
    
    @IBAction func fetchDataButtonPressed(_ sender: UIButton) {
        
        //For Future: Do this on background thread
        fetchData()
        //For Future: Come back to main thread
        tableView.reloadData()
        loadIndividualCategoryArray()
    }
    
    //MARK:- Data Manipulation Methods
    
    //Method to fetch data from the URL
    func fetchData()
    {
        let urlString  = "https://fetch-hiring.s3.amazonaws.com/hiring.json"
        if let url = URL(string: urlString)
        {
            if let data = try? Data(contentsOf: url)
            {
                if let petitions = try? JSONDecoder().decode([HiringData].self, from : data)
                {
                    loadArray(petitions: petitions)
                    
                }
            }
            
        }
    }

    //helper function for fetch data, adds items to rawData array where name is not nil or empty string
    //also stores the names of the lists
    func loadArray(petitions : [HiringData])
    {
        for petition in petitions
        {
            if (petition.name != "" && petition.name != nil)
            {
                if !listNames.contains(petition.listId)
                {
                    listNames.append(petition.listId)
                }
               
                rawData.append(petition)
            }
        }
        
        //sort the list names
        listNames = listNames.sorted()
    }
    
    
    //Store data as seperate categories in array
    func  loadIndividualCategoryArray()
    {
        //sort raw data as per listId then by name
        let sortedData = rawData.sorted(by:  { if ($0.listId !=  $1.listId) {
            return $0.listId < $1.listId
        }
        else{
            return $0.name! < $1.name!
        }})

        //store each list as individual array
        for i in listNames.sorted() {
           
            let individualCategory = sortedData.filter { $0.listId == i}
            individualCategoryArray.append(individualCategory)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let listVC = segue.destination as! ListTableViewController
            listVC.itemArray = individualCategoryArray[indexPath.row]

        }
    }

    //MARK:- Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if listNames.count == 0 {
        tableView.setEmptyView(title: "Empty List", message: "Press the Fetch Data Button to Load Data")
        }
        else
        {
            tableView.restore()
        }

        return listNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if listNames.count != 0
        {
            cell.textLabel?.text = "List \(listNames[indexPath.row])\nNumber of Entries : 2"
        }

        cell.accessoryType = .disclosureIndicator
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "segueToItemVC", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    


}
extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
