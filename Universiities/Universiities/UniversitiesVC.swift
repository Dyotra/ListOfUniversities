//
//  UniversitiesVC.swift
//  Universiities
//
//  Created by Bekpayev Dias on 12.08.2023.
//

import UIKit
import Alamofire
import SnapKit

class UniversitiesVC: UIViewController {
    let country: Country
    var universities: [UniversityData] = []
    
    let tableView2: UITableView = {
        let table = UITableView()
        return table
    }()
    
    init(country: Country) {
        self.country = country
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView2)
        tableView2.translatesAutoresizingMaskIntoConstraints = false
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView2.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView2.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview().inset(25)
            $0.top.equalToSuperview().inset(50)
        }
        
        showUniversities()
    }

    func showUniversities() {
        AF.request("http://universities.hipolabs.com/search?country=United+States").responseData { response in
            switch response.result {
            case .success(let jsonData):
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode([UniversityData].self, from: jsonData)
                    self.universities = response
                    self.universities.sort { $0.name < $1.name }
                    DispatchQueue.main.async {
                        self.tableView2.reloadData()
                    }
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension UniversitiesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let university = universities[indexPath.row]
        cell.textLabel?.text = university.name
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 31)
        return cell
    }
}

