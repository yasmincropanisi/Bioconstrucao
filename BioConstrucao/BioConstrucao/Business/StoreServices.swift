//
//  StoreServices.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 13/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

@objc protocol StoreServicesDelegate {
    func receiveStores(stores: [Store])
}

@objc protocol UploadStoreDelegate {
    func uploadStoreDidFinish(_ error: Error?)
}

class StoreServices {
    weak var delegate: StoreServicesDelegate?
    private var dataBaseService: DataBaseService
    private weak var uploadStoreDelegate: UploadStoreDelegate?
    
    private var requestsCounter: Int = 0
    
    init(delegate: StoreServicesDelegate) {
        self.delegate = delegate
        self.dataBaseService = DataBaseService.instance
    }
    
    init() {
        self.dataBaseService = DataBaseService.instance
    }
    
    init(uploadStoreDelegate: UploadStoreDelegate) {
        self.uploadStoreDelegate = uploadStoreDelegate
        self.dataBaseService = DataBaseService.instance
    }
    
    private func instantiateStoresList(stores: [String]?) -> [Store] {
        var storeList: [Store] = []
        
        if let stores = stores {
            for store in stores {
                storeList.append(Store(id: store))
            }
        }
        
        return storeList
    }
    
    private func createStoreList(data: [String: AnyObject]?) -> [Store] {
        var result: [Store] = []
        
        if let stores = data {
            for store in stores {
                result.append(self.parseJsonToStore(data: store))
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
    
    func retrieveStores(state: String, numberOfStores: Int) {
        var storeList: [Store] = []
        var returnedStoreList: [Store] = []
        
        self.dataBaseService.storeReference.queryOrdered(byChild: "state").queryEqual(toValue: state).queryLimited(toFirst: UInt(numberOfStores)).observeSingleEvent(of: .value) { (snapshot) in
            let data = snapshot.value as? [String: AnyObject]
            storeList = self.createStoreList(data: data)
            
            //            for store in storeList where guide.state == state {
            //                returnedGuidesList.append(guide)
            //            }
            
            self.delegate?.receiveStores(stores: storeList)
        }
    }
   
   
    func retrieveStores(numberOfStores: Int) {
        var storesList: [Store] = []
        self.dataBaseService.storeReference.queryLimited(toFirst: UInt(numberOfStores)).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let data = snapshot.value as? [String: AnyObject]
            storesList = self.createStoreList(data: data)
            self.delegate?.receiveStores(stores: storesList)
        })
    }
    
 
}
extension StoreServices {
    private func setJsonStore(store: Store, json: NSMutableDictionary) {
        if let id = store.id {
            json.setValue(id, forKey: "id")
        }
        if let name = store.name {
            json.setValue(name, forKey: "name")
        }
        if let city = store.city {
            json.setValue(city, forKey: "city")
        }
        if let state = store.state {
            json.setValue(state, forKey: "state")
        }
        if let details = store.details {
            json.setValue(details, forKey: "details")
        }
        if let pathImage = store.pathImage {
            json.setValue(pathImage, forKey: "pathImage")
        }
        
    }
    func createStoreJson(store: Store) -> NSMutableDictionary {
        let json: NSMutableDictionary = NSMutableDictionary()
        
        setJsonStore(store: store, json: json)
        if let name = store.name {
            json.setValue(name, forKey: "name")
        }
        return json
    }
    
    
    private func setStoreData(store: Store, data: (key: String, value: AnyObject)?) {
        if let id = data?.value["id"] {
            store.id = id as? String
        }
        if let name = data?.value["name"] {
            store.name = name as? String
        }
        if let city = data?.value["city"] {
            store.city = city as? String
        }

        if let state = data?.value["state"] {
            store.state = state as? String
        }
        if let details = data?.value["details"] {
            store.details = details as? String
        }
        
        if let pathImage = data?.value["pathImage"] {
            store.pathImage = pathImage as? String
        }
        
    }
    
    func parseJsonToStore(data: (key: String, value: AnyObject)?) -> Store {
        let store: Store = Store()
        
        setStoreData(store: store, data: data)
        
        if let name = data?.value["name"] {
            store.name = name as? String
        }
        if let state = data?.value["state"] {
            store.state = state as? String
        }
        
        return store
    }
}
