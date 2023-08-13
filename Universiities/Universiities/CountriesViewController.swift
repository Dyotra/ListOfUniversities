//
//  ViewController.swift
//  Universiities
//
//  Created by Bekpayev Dias on 12.08.2023.
//

import UIKit
import Alamofire
import SnapKit


class CountriesVC: UIViewController {
    var countries: [Country] = []
    
    let tableView1: UITableView = {
        let table = UITableView()
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView1)
        
        tableView1.translatesAutoresizingMaskIntoConstraints = false
        
        tableView1.delegate = self
        tableView1.dataSource = self
        
        tableView1.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView1.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview().inset(25)
            $0.top.equalToSuperview().inset(50)
        }
        
        showCountries()
    }
    
    func showCountries() {
        AF.request("https://api.first.org/data/v1/countries").responseData { response in
            switch response.result {
            case .success(let jsonData):
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(CountryData.self, from: jsonData)
                        self.countries = Array(response.data.values)
                        self.countries.sort { $0.name < $1.name }
                        self.tableView1.reloadData()
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

extension CountriesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let country = countries[indexPath.row]
        cell.textLabel?.text = country.name
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 31)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountry = countries[indexPath.row]
        let universitiesVC = UniversitiesVC(country: selectedCountry)
        navigationController?.pushViewController(universitiesVC, animated: true)
    }
}
