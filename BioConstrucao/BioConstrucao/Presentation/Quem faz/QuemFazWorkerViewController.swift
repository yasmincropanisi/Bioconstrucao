//
//  QuemFazWorkerViewController.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 15/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class QuemFazWorkerViewController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Construtores")
    }
    
   
    
    @IBOutlet weak var quemFazTableView: UITableView!
    var workers = [Worker]()
    var workerServices: WorkerServices = WorkerServices()
    var imageServices: ImageServices?
    var worker: Worker?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workerServices.delegate = self
        quemFazTableView.delegate = self
        quemFazTableView.dataSource = self
        imageServices = ImageServices(delegate: self)
        quemFazTableView.tableFooterView = UIView()
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

extension QuemFazWorkerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return self.workers.count
 
    }
    
  
    
    private func workerCell(indexPath: IndexPath) -> UITableViewCell {
        var cell: WorkerTableViewCell!
        
        if let cellWorker = quemFazTableView.dequeueReusableCell(withIdentifier: "WorkerTableViewCell", for: indexPath) as? WorkerTableViewCell {
            cell = cellWorker
        }
        
        cell.workerNameLabel.text = workers[indexPath.row].name
        cell.worketLocationLabel.text = workers[indexPath.row].state
        
        if let workerImage = workers[indexPath.row].image {
            cell.workerImageView.image = workerImage
            cell.workerImageView.isHidden = false
            cell.workerImageView.layer.borderWidth = 1
            cell.workerImageView.layer.masksToBounds = false
            cell.workerImageView.layer.borderColor =  UIColor.brown.cgColor//UIColor.white.cgColor
            cell.workerImageView.layer.cornerRadius =  cell.workerImageView.frame.height/2
            cell.workerImageView.clipsToBounds = true
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
       
            return workerCell(indexPath: indexPath)
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.worker = self.workers[indexPath.row]
            workerServices.retrieveWorkerById(id: (self.worker?.id!)!)
       
    }
    
    
}
extension QuemFazWorkerViewController: WorkerServicesDelegate {
    func didReceiveWorkerById(worker: Worker) {
        
    }
    
    func receiveWorkers(workers: [Worker]) {
        self.workers = workers
        self.quemFazTableView.reloadData()
    }
    
    
}


extension QuemFazWorkerViewController: ImageServicesDelegate {
    func didReceiveImage(image: UIImage?, ticket: (String, Int)) {
        if ticket.0 == workerTicket {
            //self.workers[ticket.1].images![0].image = image
            self.workers[ticket.1].image = image
        }
        
        self.quemFazTableView.reloadData()
    }
}
