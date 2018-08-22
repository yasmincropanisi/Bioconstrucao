//
//  QuemFazViewController.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 13/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

class QuemFazViewController: UIViewController {

    @IBOutlet weak var quemFazSegmentedControl: UISegmentedControl!
    @IBOutlet weak var quemFazTableView: UITableView!
    var workers = [Worker]()
    var stores =  [Store]()
    var workerServices: WorkerServices = WorkerServices()
    var storeServices: StoreServices = StoreServices()
    var imageServices: ImageServices?
    var worker: Worker?
    var store: Store?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workerServices.delegate = self
        storeServices.delegate = self
        quemFazTableView.delegate = self
        quemFazTableView.dataSource = self
        imageServices = ImageServices(delegate: self)
        quemFazTableView.tableFooterView = UIView()
        storeServices.retrieveStores(numberOfStores: 1000)
        workerServices.retrieveAllWorkers(numberOfWorkers: 1000)

        // Do any additional setup after loading the view.
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

extension QuemFazViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.quemFazSegmentedControl.selectedSegmentIndex == 0 {
            return self.workers.count
        }
        
        return self.stores.count
    }
    
    private func storeCell(indexPath: IndexPath) -> UITableViewCell {
        var cell: StoreTableViewCell!
        
        if let cellStore = quemFazTableView.dequeueReusableCell(withIdentifier: "StoreTableViewCell", for: indexPath) as? StoreTableViewCell {
            cell = cellStore
        }
        cell.storeNameLabel.text = stores[indexPath.row].name
        cell.storeDescriptionLabel.text = stores[indexPath.row].name
        cell.storeLocationLabel.text = "\(self.stores[indexPath.row].city!), \(self.stores[indexPath.row].state!)"
        
        return cell
    }
    
    
    private func workerCell(indexPath: IndexPath) -> UITableViewCell {
        var cell: WorkerTableViewCell!
        
        if let cellWorker = quemFazTableView.dequeueReusableCell(withIdentifier: "WorkerTableViewCell", for: indexPath) as? WorkerTableViewCell {
            cell = cellWorker
        }
        
        cell.workerNameLabel.text = workers[indexPath.row].name
        
        if let workerImage = workers[indexPath.row].image {
            cell.workerImageView.layer.borderWidth = 1
            cell.workerImageView.layer.masksToBounds = false
            cell.workerImageView.layer.borderColor =  UIColor.brown.cgColor//UIColor.white.cgColor
            cell.workerImageView.layer.cornerRadius =  cell.workerImageView.frame.height/2
            cell.workerImageView.clipsToBounds = true
            cell.workerImageView.image = workerImage
            

            cell.workerImageView.isHidden = false
        } else {
            if let pathImage = workers[indexPath.row].pathImage {
                self.imageServices?.getImageFromDatabase(path: pathImage, ticket: (workerTicket, indexPath.row))
                cell.workerImageView.isHidden = true
                //cell.activityIndicator.startAnimating()
            } else {
                //cell.photoGuide.image = #imageLiteral(resourceName: "guidePlaceholder")
            }
        }
        cell.worketLocationLabel .text = "\(self.workers[indexPath.row].city!), \(self.workers[indexPath.row].state!)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.quemFazSegmentedControl.selectedSegmentIndex == 0 {
            return workerCell(indexPath: indexPath)
        }
        
        return storeCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.quemFazSegmentedControl.selectedSegmentIndex == 0 {
            self.worker = self.workers[indexPath.row]
            workerServices.retrieveWorkerById(id: (self.worker?.id!)!)
        } else {
            self.store = self.stores[indexPath.row]
            performSegue(withIdentifier: "SegueTourDetails", sender: self)
        }
    }
    
    
}
extension QuemFazViewController: WorkerServicesDelegate {
    func didReceiveWorkerById(worker: Worker) {
        
    }
    
    func receiveWorkers(workers: [Worker]) {
        self.workers = workers
        self.quemFazTableView.reloadData()
    }
    
    
}

extension QuemFazViewController: StoreServicesDelegate {
    func receiveStores(stores: [Store]) {
        self.stores = stores
        self.quemFazTableView.reloadData()
    }
    
    
}
extension QuemFazViewController: ImageServicesDelegate {
    func didReceiveImage(image: UIImage?, ticket: (String, Int)) {
        if ticket.0 == workerTicket {
            //self.workers[ticket.1].images![0].image = image
            self.workers[ticket.1].image = image
        }
        
        self.quemFazTableView.reloadData()
    }
}
