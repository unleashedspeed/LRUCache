//
//  LRUCache.swift
//  LRUCache
//
//  Created by Saurabh Gupta on 04/09/20.
//  Copyright © 2020 Saurabh Gupta. All rights reserved.
//

import Foundation

class LRUCache<Key: Hashable, Object> {
    
    private struct Payload {
        let key: Key
        let object: Object
    }
    
    private let capacity: Int
    private let list = LinkedList<Payload>()
    private var dict = [Key: LinkedList<Payload>.Node<Payload>]()
    
    init(capacity: Int) {
        self.capacity = capacity
    }
    
    func setObject(_ object: Object, for key: Key) {
        let payload = Payload(key: key, object: object)
        // case: when key is already present.
        if let _ = dict[key] {
            return
        } else {
            let node = list.addToHead(payload)
            dict[key] = node
        }
        
        // case: when the cache reached its capacity.
        if list.count > capacity {
            let nodeRemoved = list.removeLast()
            if let key = nodeRemoved?.payload.key {
                dict[key] = nil
            }
        }
    }
    
    func getValue(for key: Key) -> Object? {
        guard let node = dict[key] else { return nil }
        // Keeps recently used item always to top ensuring the least recently used item will be last in the list.
        list.moveToHead(node)
        
        return node.payload.object
    }
    
}

class LinkedList<T> {
    class Node<T> {
        var payload: T
        var previous: Node<T>?
        var next: Node<T>?
        
        init(payload: T) {
            self.payload = payload
        }
    }
    
    private(set) var count: Int = 0
    private var head: Node<T>?
    private var tail: Node<T>?
    
    func addToHead(_ payload: T) -> Node<T> {
        let node = Node(payload: payload)
        
        defer {
            head = node
            count += 1
        }
        
        guard let head = head else {
            tail = node
            return node
        }
        
        head.previous = node
        node.previous = nil
        node.next = head
        
        return node
    }
    
    func moveToHead(_ node: Node<T>) {
        guard node !== head else { return }
        
        let previous = node.previous
        let next = node.next
        previous?.next = next
        next?.previous = previous
        node.next = head
        node.previous = nil
        if node === tail {
            tail = previous
        }
        self.head = node
    }
    
    func removeLast() -> Node<T>? {
        guard let tail = self.tail else { return nil }
        
        let previous = tail.previous
        previous?.next = nil
        self.tail = previous
        if count == 1 {
            head = nil
        }
        count -= 1
        
        return tail
    }
}
