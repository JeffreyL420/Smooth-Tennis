//
//  DictionaryAppending.swift
//  SmoothTennis
//
//  Created by Jeffrey Liang on 2022/10/6.
//

import Foundation

extension Dictionary where Value: RangeReplaceableCollection {
    public mutating func append(element: Value.Iterator.Element, toValueOfKey key: Key) -> Value? {
        var value: Value = self[key] ?? Value()
        value.append(element)
        self[key] = value
        return value
    }
}
