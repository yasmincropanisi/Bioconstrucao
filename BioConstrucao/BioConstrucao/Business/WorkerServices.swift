//
//  WorkerServices.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 13/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

@objc protocol WorkerServicesDelegate {
    func receiveWorkers(workers: [Worker])
    func didReceiveWorkerById(worker: Worker)
}

@objc protocol UploadWorkerDelegate {
    func uploadWorkerDidFinish(_ error: Error?)
}

class WorkerServices {
    weak var delegate: WorkerServicesDelegate?
    private var dataBaseService: DataBaseService
    private weak var uploadWorkerDelegate: UploadWorkerDelegate?
    
    private var requestsCounter: Int = 0
    
    init(delegate: WorkerServicesDelegate) {
        self.delegate = delegate
        self.dataBaseService = DataBaseService.instance
    }
    
    init() {
        self.dataBaseService = DataBaseService.instance
    }
    
    init(uploadWorkerDelegate: UploadWorkerDelegate) {
        self.uploadWorkerDelegate = uploadWorkerDelegate
        self.dataBaseService = DataBaseService.instance
    }
    
    private func instantiateWorkersList(workers: [String]?) -> [Worker] {
        var workerList: [Worker] = []
        
        if let workers = workers {
            for worker in workers {
                workerList.append(Worker(id: worker))
            }
        }
        
        return workerList
    }
    
    private func createWorkerList(data: [String: AnyObject]?) -> [Worker] {
        var result: [Worker] = []
        
        if let workers = data {
            for worker in workers {
                result.append(self.parseJsonToWorker(data: worker))
            }
        }
        
        return result
    }
    
    private func getList(_ list: [String]?) -> [String] {
        if let list = list {
            return list
        }
        return []
    }
    
    func retrieveWorkers(state: String, numberOfWorkers: Int) {
        var workerList: [Worker] = []
        var returnedWorkerList: [Worker] = []
        
        self.dataBaseService.workersReference.queryOrdered(byChild: "state").queryEqual(toValue: state).queryLimited(toFirst: UInt(numberOfWorkers)).observeSingleEvent(of: .value) { (snapshot) in
            let data = snapshot.value as? [String: AnyObject]
            workerList = self.createWorkerList(data: data)
            
            self.delegate?.receiveWorkers(workers: workerList)
        }
    }
    
    private func createProjectList(projects: [NSDictionary]) -> [Project] {
        var projectsList: [Project] = []
        
        for project in projects {
            
            if let pathImage = project["pathImage"] as? String {
                if let name = project["name"] as? String {
                    if let id = project["id"] as? String {
                        if let state = project["state"] as? String {
                            projectsList.append(Project(id: id, name: name, pathImage: pathImage, state: state))
                        }
                    }
                }
            }
        }
        
        return projectsList
    }
   
    func retrieveAllWorkers(city: String, state: String) {
        var workersList: [Worker] = []
        self.dataBaseService.workersReference.queryOrdered(byChild: "state").queryEqual(toValue: state).observeSingleEvent(of: .value) { (snapshot) in
            let data = snapshot.value as? [String: AnyObject]
            workersList = self.createWorkerList(data: data)
            self.delegate?.receiveWorkers(workers: workersList)
        }
    }
   
}
extension WorkerServices {
    private func setJsonWorker(worker: Worker, json: NSMutableDictionary) {
        if let name = worker.name {
            json.setValue(name, forKey: "name")
        }
        if let city = worker.city {
            json.setValue(city, forKey: "city")
        }
        if let state = worker.state {
            json.setValue(state, forKey: "state")
        }
        
        if let pathImage = worker.pathImage {
            json.setValue(pathImage, forKey: "pathImage")
        }
        
    }
    func createWorkerJson(worker: Worker) -> NSMutableDictionary {
        let json: NSMutableDictionary = NSMutableDictionary()
        
        setJsonWorker(worker: worker, json: json)
        if let name = worker.name {
            json.setValue(name, forKey: "name")
        }
        return json
    }
    
    
    private func setWorkerData(worker: Worker, data: (key: String, value: AnyObject)?) {
        if let id = data?.value["id"] {
            worker.id = id as? String
        }
        if let name = data?.value["name"] {
            worker.name = name as? String
        }
        if let city = data?.value["city"] {
            worker.city = city as? String
        }
        if let email = data?.value["city"] {
            worker.email = email as? String
        }
        if let state = data?.value["state"] {
            worker.state = state as? String
        }
        
        if let pathImage = data?.value["pathImage"] {
            worker.pathImage = pathImage as? String
        }
        
        if let projects = data?.value["projects"] as? [NSDictionary] {
            worker.projects = self.createProjectList(projects: projects)
        }
        
    }
    
    func parseJsonToWorker(data: (key: String, value: AnyObject)?) -> Worker {
        let worker: Worker = Worker()
        
        setWorkerData(worker: worker, data: data)
        
        if let name = data?.value["name"] {
            worker.name = name as? String
        }
        if let state = data?.value["state"] {
            worker.state = state as? String
        }
        
        return worker
    }
    
    func retrieveAllWorkers(numberOfWorkers: Int) {
        var workersList: [Worker] = []
        self.dataBaseService.workersReference.queryLimited(toFirst: UInt(numberOfWorkers)).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let data = snapshot.value as? [String: AnyObject]
            workersList = self.createWorkerList(data: data)
            self.delegate?.receiveWorkers(workers: workersList)
        })
    }
    
    func retrieveWorkerById(id: String) {
        self.dataBaseService.workersReference.queryOrdered(byChild: "id").queryEqual(toValue: id).observeSingleEvent(of: .value) { (snapshot) in
            var data = snapshot.value as? [String: AnyObject]
            var workerFound: Worker?
            if let worker = data?.popFirst() {
                workerFound = self.parseJsonToWorker(data: worker)
            }
            self.delegate?.didReceiveWorkerById(worker: workerFound!)
        }
    }
    
   
}
