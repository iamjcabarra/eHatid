//
//  DeliveryViewModel.swift
//  eHatid
//
//  Created by Julius Abarra on 2/14/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import CoreData
import Foundation
import Moya
import PromiseKit

public final class DeliveryViewModel {
    
    // MARK: - Alias
    public typealias GetDeliveriesResult = (Swift.Result<Bool, Error>) -> Void
    public typealias DoneBlock = (_ doneBlock: Bool) -> Void
    
    // MARK: - API Service
    private var deliveryAPIService: APIService<DeliveryRequest>
    
    // MARK: - Core Data Stack
    public let database: CoreDataStack
    
    // MARK: - Initializer
    public init(
        deliveryAPIService: APIService<DeliveryRequest> = APIService(
            provider: MoyaProvider<DeliveryRequest>()),
        database: CoreDataStack = CoreDataStack(name: "DataModel")
    ) {
        self.deliveryAPIService = deliveryAPIService
        self.database = database
    }
    
}

// MARK: - API Request Handlers
extension DeliveryViewModel {
    
    /// Retrieves deliveries from host server.
    ///
    /// - Parameters:
    ///     - offset: An `Int` identifying the starting index
    ///     - limit: An `Int` identifying the number of items for request
    ///     - completion: A `GetDeliveriesResult` wrapping result
    /// - Returns: A promise of `Bool` or `Error`
    public func getDeliveries(offset: Int, limit: Int, completion: @escaping GetDeliveriesResult) {
        let request: Promise<[Delivery]> = self.deliveryAPIService.request(
            DeliveryRequest.getDeliveries(offset: offset, limit: limit),
            responseType: [Delivery].self
        )
        request.done { (deliveries: [Delivery]) in
            self.save(deliveries: deliveries) { isSuccess in
                completion(.success(isSuccess))
            }
        }.catch { (error: Error) -> Void in
            completion(.failure(error))
        }
    }
    
}

// MARK: - Local Data Bindings
extension DeliveryViewModel {
    
    /// Saves delivery details to local database.
    ///
    /// - Parameters:
    ///     - deliveries: An array of `Delivery` from API response
    ///     - completion: A `DoneBlock` wrapping result
    /// - Returns: None
    private func save(deliveries: [Delivery], completion: @escaping DoneBlock) {
        guard let context = self.database.workerContext else {
            logger.error("Can't retrieve the worker context")
            completion(false)
            return
        }
        
        context.performAndWait {
            var order: Int64 = self.getStartOrder()
            
            for delivery in deliveries {
                let localDelivery: LocalDelivery = self.database.retrieveEntity(
                    name: Constants.Entity.delivery,
                    fromContext: context,
                    filteredBy: self.database.createPredicate(
                        forKeyPath: "id",
                        exactValue: "\(delivery.id)"
                    )
                ) as! LocalDelivery
                
                localDelivery.id = delivery.id
                localDelivery.remarks = delivery.remarks
                localDelivery.pickupTime = delivery.pickupTime
                localDelivery.goodsPicture = delivery.goodsPicture
                localDelivery.deliveryFee = delivery.deliveryFee
                localDelivery.surcharge = delivery.surcharge
                localDelivery.totalFee = delivery.totalFee
                
                // Relate sender
                self.relate(sender: delivery.sender, delivery: localDelivery, context: context)
                
                // Relate route
                self.relate(route: delivery.route, delivery: localDelivery, context: context)
                
                // Update sequence order
                localDelivery.order = order
                order += 1
            }
            
            completion(self.database.saveManagedObjectContext(context))
        }
    }
    
    /// Relates delivery route from API response to delivery entity.
    ///
    /// - Parameters:
    ///     - route: An instance of `DeliveryRoute`
    ///     - delivery: An instance of `LocalDelivery`
    ///     - context: An instance of `NSManagedObjectContext`
    /// - Returns: None
    private func relate(route: DeliveryRoute, delivery: LocalDelivery, context: NSManagedObjectContext) {
        guard let id = delivery.id else {
            logger.error("Can't relate route because id is nil.")
            return
        }
        
        let localDeliveryRoute = self.database.retrieveEntity(
            name: Constants.Entity.deliveryRoute,
            fromContext: context,
            filteredBy: self.database.createPredicate(
                forKeyPath: "delivery.id",
                exactValue: "\(id)"
            )
        ) as! LocalDeliveryRoute
        
        localDeliveryRoute.start = route.start
        localDeliveryRoute.end = route.end
        delivery.route = localDeliveryRoute
    }
    
    /// Relates delivery sender from API response to delivery entity.
    ///
    /// - Parameters:
    ///     - sender: An instance of `DeliverySender`
    ///     - delivery: An instance of `LocalDelivery`
    ///     - context: An instance of `NSManagedObjectContext`
    /// - Returns: None
    private func relate(sender: DeliverySender, delivery: LocalDelivery, context: NSManagedObjectContext) {
        guard let id = delivery.id else {
            logger.error("Can't relate sender because id is nil.")
            return
        }
        
        let localDeliverySender = self.database.retrieveEntity(
            name: Constants.Entity.deliverySender,
            fromContext: context,
            filteredBy: self.database.createPredicate(
                forKeyPath: "delivery.id",
                exactValue: "\(id)"
            )
        ) as! LocalDeliverySender
        
        localDeliverySender.phone = sender.phone
        localDeliverySender.name = sender.name
        localDeliverySender.email = sender.email
        delivery.sender = localDeliverySender
    }
    
    /// Identifies the starting order necessary for ordering the deliveries in the list.
    ///
    /// - Parameters: None
    /// - Returns: An `Int64` identifying the starting sequence order
    private func getStartOrder() -> Int64 {
        var highest: Int64 = 1
        
        guard let items = self.database.retrieveItemsOfEntity(
            name: Constants.Entity.delivery,
            filteredBy: nil
            ) as? [LocalDelivery]
        else {
            logger.error("Can't retrieve items from \"\(Constants.Entity.delivery)\".")
            return highest
        }
        
        for item in items where item.order > highest {
            highest = item.order
        }
        
        return items.count > 0 ? highest + 1 : highest
    }
    
}
