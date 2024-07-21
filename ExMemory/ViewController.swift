//
//  ViewController.swift
//  ExMemory
//
//  Created by 김종권 on 2024/07/21.
//

import UIKit

class SomeClass {
    var value: Int
    init(value: Int) {
        self.value = value
    }
}

struct SomeStruct {
    var classInstance: SomeClass
    var otherValue: Int
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let someClassInstance = SomeClass(value: 10)
        let someStructInstance = SomeStruct(classInstance: someClassInstance, otherValue: 20)
        
        printStackAddress()
        printHeapAddress()

        withUnsafePointer(to: someStructInstance) { pointer in
            let startAddress = Int(bitPattern: pointer)
            let size = MemoryLayout.size(ofValue: someStructInstance)
            let endAddress = startAddress + size
            
            print("Struct instance memory start address: \(pointer)")
            print("Struct instance memory end address: \(UnsafeRawPointer(bitPattern: endAddress)!)")
            print("Struct memory size: \(size) bytes")
            print("Struct instance's class instance memory strat:", Unmanaged.passUnretained(someStructInstance.classInstance).toOpaque())
        }
        
        let startAddress = Int(bitPattern: Unmanaged.passUnretained(someClassInstance).toOpaque())
        let size = MemoryLayout<SomeClass>.size
        let endAddress = startAddress + size
        
        print("Class instance memory start address: \(Unmanaged.passUnretained(someClassInstance).toOpaque())")
        print("Class instance memory end address: \(UnsafeRawPointer(bitPattern: endAddress)!)")
        print("Class memory size: \(size) bytes")
    }
    
    
    // 스택 메모리의 주소 확인
    func printStackAddress() {
        var stackVariable = 0
        withUnsafePointer(to: &stackVariable) { pointer in
            print("Stack memory address: \(pointer)")
        }
    }
    
    // 힙 메모리의 주소 확인
    func printHeapAddress() {
        let heapVariable = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        heapVariable.pointee = 0
        print("Heap memory address: \(heapVariable)")
        heapVariable.deallocate()
    }
}
