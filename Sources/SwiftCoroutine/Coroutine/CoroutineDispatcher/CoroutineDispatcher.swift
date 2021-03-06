//
//  CoroutineDispatcher.swift
//  SwiftCoroutine
//
//  Created by Alex Belozierov on 10.03.2020.
//  Copyright © 2020 Alex Belozierov. All rights reserved.
//

@usableFromInline protocol _CoroutineTaskExecutor: class {
    
    func execute(on scheduler: CoroutineScheduler, task: @escaping () -> Void)
    
}

@usableFromInline internal struct CoroutineDispatcher {
    
    @usableFromInline
    internal static let `default` = newShared(coroutinePoolSize: .processorsNumber * 2)
    
    internal static func newShared(coroutinePoolSize poolSize: Int, stackSize: Coroutine.StackSize = .recommended) -> CoroutineDispatcher {
        let executor = SharedCoroutineDispatcher(contextsCount: poolSize, stackSize: stackSize.size)
        return CoroutineDispatcher(executor: executor)
    }
    
    @usableFromInline let executor: _CoroutineTaskExecutor
    
    @inlinable internal func execute(on scheduler: CoroutineScheduler, task: @escaping () -> Void) {
        executor.execute(on: scheduler, task: task)
    }
    
}
