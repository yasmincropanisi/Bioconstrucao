//
//  WorkshopServices.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 08/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

@objc protocol WorkshopServicesDelegate {
    func receiveWorkshops(workshops: [Workshop])

}

@objc protocol UploadWorkshopDelegate {
    func uploadWorkshopDidFinish(_ error: Error?)
}

class WorkshopServices {
    weak var delegate: WorkshopServicesDelegate?
    private var dataBaseService: DataBaseService
    private weak var uploadWorkshopDelegate: UploadWorkshopDelegate?
    
    private var requestsCounter: Int = 0
    
    init(delegate: WorkshopServicesDelegate) {
        self.delegate = delegate
        self.dataBaseService = DataBaseService.instance
    }
    
    init() {
        self.dataBaseService = DataBaseService.instance
    }
    
    init(uploadWorkshopDelegate: UploadWorkshopDelegate) {
        self.uploadWorkshopDelegate = uploadWorkshopDelegate
        self.dataBaseService = DataBaseService.instance
    }
    
    private func instantiateWorkshopsList(workshops: [String]?) -> [Workshop] {
        var workshopsList: [Workshop] = []
        
        if let workshops = workshops {
            for workshop in workshops {
                workshopsList.append(Workshop(id: workshop))
            }
        }
        
        return workshopsList
    }
    
    private func createWorkshopList(data: [String: AnyObject]?) -> [Workshop] {
        var result: [Workshop] = []
        
        if let workshops = data {
            for workshop in workshops {
                result.append(self.parseJsonToWorkshop(data: workshop))
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
    
    func retrieveWorkshops(state: String, numberOfWorkshops: Int) {
        var workshopsList: [Workshop] = []
        var returnedWorkshopList: [Workshop] = []
        
        self.dataBaseService.workshopsReference.queryOrdered(byChild: "state").queryEqual(toValue: state).queryLimited(toFirst: UInt(numberOfWorkshops)).observeSingleEvent(of: .value) { (snapshot) in
            let data = snapshot.value as? [String: AnyObject]
            workshopsList = self.createWorkshopList(data: data)
            self.delegate?.receiveWorkshops(workshops: workshopsList)
        }
    }
    
    func retrieveAllWorkshops(city: String, state: String) {
        var workshopsList: [Workshop] = []
        self.dataBaseService.workshopsReference.queryOrdered(byChild: "state").queryEqual(toValue: state).observeSingleEvent(of: .value) { (snapshot) in
            let data = snapshot.value as? [String: AnyObject]
            workshopsList = self.createWorkshopList(data: data)
            self.delegate?.receiveWorkshops(workshops: workshopsList)
        }
    }
    
    func retrieveAllWorkshops(numberOfWorkshops: Int) {
        var workshopsList: [Workshop] = []
        self.dataBaseService.workshopsReference.queryLimited(toFirst: UInt(numberOfWorkshops)).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let data = snapshot.value as? [String: AnyObject]
            workshopsList = self.createWorkshopList(data: data)
            self.delegate?.receiveWorkshops(workshops: workshopsList)
        })
    }
    

}
extension WorkshopServices {
    private func setJsonWorkshop(workshop: Workshop, json: NSMutableDictionary) {
        if let name = workshop.name {
            json.setValue(name, forKey: "name")
        }
        if let state = workshop.state {
            json.setValue(state, forKey: "state")
        }
        
    }
    func createWorkshopJson(workshop: Workshop) -> NSMutableDictionary {
        let json: NSMutableDictionary = NSMutableDictionary()
        
        setJsonWorkshop(workshop: workshop, json: json)
        if let name = workshop.name {
            json.setValue(name, forKey: "name")
        }
        
        return json
    }
   
    private func setWorkshopData(workshop: Workshop, data: (key: String, value: AnyObject)?) {
        if let id = data?.value["id"] {
            workshop.id = id as? String
        }
        if let name = data?.value["name"] {
            workshop.name = name as? String
        }
        if let state = data?.value["state"] {
            workshop.state = state as? String
        }
    }
    
    func parseJsonToWorkshop(data: (key: String, value: AnyObject)?) -> Workshop {
        let workshop: Workshop = Workshop()
        
        setWorkshopData(workshop: workshop, data: data)
        
        if let name = data?.value["name"] {
            workshop.name = name as? String
        }
        if let city = data?.value["city"] {
            workshop.city = city as? String
        }
        if let state = data?.value["state"] {
            workshop.state = state as? String
        }
        
        if let pathImage = data?.value["pathImage"] {
            workshop.pathImage = pathImage as? String
        }
        
        return workshop
    }
    
    
}

