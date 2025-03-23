//
//  ViewController.swift
//  WhitehousePetitions
//
//  Created by Prathamesh Pawar on 3/22/25.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var urlString: String
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(creditMethod))
        
        let filter = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(alertFilterPetitions))
        let reset = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetFilter))
        reset.tintColor = UIColor.red
        // Hide reset button if user didn't filtered anything
        reset.isEnabled = false
        navigationItem.leftBarButtonItems = [filter, reset]
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    @objc private func creditMethod() {
        let ac = UIAlertController(title: "Credits", message:"The data comes from the WETHEPEOPLE API of the White House..!" , preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc private func alertFilterPetitions() {
        let ac = UIAlertController(title: "Filter Petitions", message: "Type the subject you want to search", preferredStyle: .alert)
        ac.addTextField()
        
        let filterAction = UIAlertAction(title: "Submit", style: .default) {  [weak ac, self] _ in
            guard let keyword = ac?.textFields?[0].text else { return }
            self.filter(keyword: keyword)
        }
        
        ac.addAction(filterAction)
        present(ac, animated: true)
    }
    
    private func filter(keyword: String) {
        
        for index in 0...petitions.count-1 {
            if petitions[index].title.lowercased().contains(keyword.lowercased()){
                filteredPetitions.append(petitions[index])
            }
        }
        
        if filteredPetitions.isEmpty {
            let ac = UIAlertController(title: "Error", message: "No match found!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        } else {
            // make reset buton visible
            self.navigationItem.leftBarButtonItems?.last?.isEnabled = true
        }
        
        
        tableView.reloadData()
    }
    
    @objc func resetFilter(){
        filteredPetitions.removeAll()
        tableView.reloadData()
        self.navigationItem.leftBarButtonItems?.last?.isEnabled = false
    }
    
    func showError() {
        let ac = UIAlertController(title: "Error Loading the Petition", message: "Please check your connection and try again..!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
        
    }
    
   
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.isEmpty ? petitions.count :  filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition: Petition
        
        if filteredPetitions.isEmpty {
            petition = petitions[indexPath.row]
        } else {
            petition = filteredPetitions[indexPath.row]
        }
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

