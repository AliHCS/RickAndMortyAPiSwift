//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Gustavo Ali Gómez Trejo on 01/12/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var currentPage: Int = 1
    
    var queryPaginate: [String: String] = ["page": "1"]
    
    let restClient = RESTClient<PaginatedResponse<Character>>(client: Client( "https://rickandmortyapi.com"))
    
    var characters: [Character]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        restClient.show("/api/character/", queryParams: queryPaginate ) { response in
            self.characters = response.results
            
        }
       
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = characters?[indexPath.row].name
        cell.detailTextLabel?.text = characters?[indexPath.row].species
        
        return cell
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let characters = characters else { return }
        let needsFetch = indexPaths.contains { $0.row >= characters.count - 1 }
        
        if needsFetch {
            restClient.show("/api/character/", queryParams: queryPaginate) { response in
                self.characters?.append(contentsOf: response.results)
            }
            currentPage += 1
            queryPaginate["page"] = "\(currentPage)"
            print(queryPaginate)
            print(currentPage)
        }
    }
}
