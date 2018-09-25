//
//  loginCountrySelectorTVC.swift
//  Neura Swift Sample App
//
//  Created by Neura on 03/04/2018.
//  Copyright © 2018 beauNeura. All rights reserved.
//

import Foundation
import UIKit

protocol CountryCodeDelegate {
    func codeWasChoosen(code: String)
}

class LoginCountrySelectorTVC: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    var countryListCodes = Array<CountryCode>()
    var fillterResults = Array<CountryCode>()
    var searchController = UISearchController(searchResultsController: nil)
     var countryCodeDelegate:CountryCodeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:#selector(close(sender:)))
        countryListCodes = CountryCodeHelepr.fetchCountryList()
        fillterResults = CountryCodeHelepr.fetchCountryList()
        self.tableView.reloadData()
        
    }
    
    @objc func close(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "countryCell")
        let code = self.fillterResults[indexPath.row]
        cell!.textLabel?.text = code.name
        cell!.detailTextLabel?.text = code.dialCode
        return cell!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fillterResults.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = fillterResults[indexPath.row]
        self.countryCodeDelegate?.codeWasChoosen(code: item.dialCode)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        if searchText != nil && searchText!.count > 0 {
            fillterResults = countryListCodes.filter({( code : CountryCode) -> Bool in
                return code.name.lowercased().contains(searchText!.lowercased())
            })
        } else {
            fillterResults = countryListCodes
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fillterResults = countryListCodes
        tableView.reloadData()
    }
}
