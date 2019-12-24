//
//  Observable.swift
//  Pets24h
//
//  Created by Vinh Huynh on 12/24/19.
//

import Foundation

final class Observable<Value> {
    struct Observer<Value> {
        weak var observer: AnyObject?
        let block: (Value) -> Void
    }
    
    private var observers: [Observer<Value>] = []
    
    var value: Value {
        didSet { notifyObservers() }
    }
    
    init(_ value: Value) {
        self.value = value
    }
    
    func observer(on observer: AnyObject, observerBlock: @escaping (Value) -> Void) {
        observers.append(Observer(observer: observer, block: observerBlock))
    }
    
    func remove(observer: AnyObject) {
        observers = observers.filter({ $0.observer !== observer })
    }
    
    func notifyObservers() {
        for observer in observers {
            DispatchQueue.main.async {
                observer.block(self.value)
            }
        }
    }
}
