//
//  DynamicValue.swift
//  KadamaVnext
//
//  Created by mobile on 21/07/21.
//

import Foundation

class ObserverValue<T> {
    
    typealias CompletionHandler = ((T) -> Void)
    
    init(_ value:T) {
        self.value = value
    }
    
    var value : T {
        didSet{
            self.notify()
        }
    }
    
    private var observers = [String:CompletionHandler]()
    
    
    func addObserver(observer:NSObject,completionHandler : @escaping CompletionHandler) {
        observers[observer.description] = completionHandler
    }
    
    func addAndNotify(observer:NSObject,completionHandler:@escaping CompletionHandler) {
        self.addObserver(observer: observer, completionHandler: completionHandler)
    }
    
    // Notify all the observers of this value
    func notify() {
        observers.forEach({$0.value(value)})
    }
    
    // Remove observers
    deinit {
        observers.removeAll()
    }
    
}
