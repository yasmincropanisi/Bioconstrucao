//
//  ImageServices.swift
//  BioConstrucao
//
//  Created by Yasmin Nogueira Spadaro Cropanisi on 08/08/2018.
//  Copyright © 2018 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation

import UIKit

protocol ImageServicesDelegate: NSObjectProtocol {
    func didReceiveImage(image: UIImage?, ticket: (String, Int))
}

class ImageServices {
    private weak var delegate: ImageServicesDelegate?
    private var dataBaseService: DataBaseService
    
    private var tickets: [(String, Int)] = []
    
    init(delegate: ImageServicesDelegate) {
        self.delegate = delegate
        self.dataBaseService = DataBaseService.instance
    }
    
    func getImageFromDatabase(path: String?, ticket: (String, Int)) {
        
        //Se ja foi feita essa solicitação, não faz nada
        if self.tickets.contains(where: { (ticketInside) -> Bool in
            return ticket == ticketInside
        }) {
            return
        }
        
        //Se ainda não foi feita a solicitação, acrescenta ela no vetor de solicitações e pega do banco
        self.tickets.append(ticket)
        
        if let path = path {
            let dataBaseService = DataBaseService.instance
            let imageRef = dataBaseService.getStorageReference(path: path)
            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("LOG from ImageServices.getImageFromDatabase: \(error.localizedDescription)")
                } else {
                    OperationQueue.main.addOperation({
                        self.delegate?.didReceiveImage(image: UIImage(data: data!), ticket: ticket)
                    })
                }
            }
        }
    }
}
