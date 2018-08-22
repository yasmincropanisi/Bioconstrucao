//
//  QuemFazStoreViewController.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 15/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class QuemFazStoreViewController: UIViewController, IndicatorInfoProvider {

    @IBOutlet weak var quemFazTableView: UITableView!
    var stores =  [Store]()
    var storeServices: StoreServices = StoreServices()
    var imageServices: ImageServices?
    var store: Store?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storeServices.delegate = self
        quemFazTableView.delegate = self
        quemFazTableView.dataSource = self
        imageServices = ImageServices(delegate: self)
        quemFazTableView.tableFooterView = UIView()
        storeServices.retrieveStores(numberOfStores: 1000)
        
        // Do any additional setup after loading the view.
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Lojas")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension QuemFazStoreViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        
        return self.stores.count
    }
    
    private func storeCell(indexPath: IndexPath) -> UITableViewCell {
        var cell: StoreTableViewCell!
        
        if let cellStore = quemFazTableView.dequeueReusableCell(withIdentifier: "StoreTableViewCell", for: indexPath) as? StoreTableViewCell {
            cell = cellStore
        }
        cell.storeNameLabel.text = stores[indexPath.row].name
        cell.storeDescriptionLabel.text = stores[indexPath.row].details
        cell.storeLocationLabel.text = "\(self.stores[indexPath.row].city!), \(self.stores[indexPath.row].state!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        return storeCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            self.store = self.stores[indexPath.row]
            performSegue(withIdentifier: "SegueStoreDetails", sender: self)
        
    }
    
    
}


extension QuemFazStoreViewController: StoreServicesDelegate {
    func receiveStores(stores: [Store]) {
        self.stores = stores
        self.quemFazTableView.reloadData()
    }
    
    
}
extension QuemFazStoreViewController: ImageServicesDelegate {
    func didReceiveImage(image: UIImage?, ticket: (String, Int)) {
       
        
        self.quemFazTableView.reloadData()
    }
}

