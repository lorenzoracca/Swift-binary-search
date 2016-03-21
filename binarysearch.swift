extension CollectionType where Generator.Element : Comparable {
    
    ///Returns the index of the first element in the collection which does not compare less than `value`.
    @warn_unused_result
    func lowerBound(value: Self.Generator.Element) -> Index {
        var len = self.startIndex.distanceTo(self.endIndex)
        var firstIndex = self.startIndex
        while len > 0 {
            let half = len/2
            let middle = firstIndex.advancedBy(half)
            
            if value > self[middle] {
                firstIndex = middle.advancedBy(1)
                len -= half.successor()
            } else {
                len = half
            }
        }
        return firstIndex
    }
}




extension CollectionType {
    
    /// Returns an index such that each element at or above the index is
    /// partitioned from below by the partitioning predicate `isOrderedBelow`.
    ///
    /// - Parameter isOrderedBelow: The partitioning predicate. Returns `true`
    ///                             for elements that are ordered below with
    ///                             respect to the partitioning element and
    ///                             `false` otherwise.
    ///
    /// - Complexity: O(lg(n))
    ///
    /// - Returns: An index such that each element at or above the returned
    ///            index evaluates `false` with respect to `isOrderedBelow(_:)`
    @warn_unused_result
    func lowerBound(@noescape isOrderedBefore: Self.Generator.Element -> Bool) 
    -> Index {
        var len = self.startIndex.distanceTo(self.endIndex)
        var firstIndex = self.startIndex
        while len > 0 {
            let half = len/2
            let middle = firstIndex.advanceBy(half)
            if isOrderedBelow(self[middle]) {
                firstIndex = middle.advanceBy(1)
                len -= half + 1
            } else {
                len = half
            }
        }
        return firstIndex
    }

    /// Returns an index such that each element above the index is strictly
    /// greater than the partitioning element.
    ///
    /// - Parameter isOrderedAfter: The partitioning predicate. Returns `true`
    ///                             for elements that are strictly greater
    ///                             than the partitioning value and `false`
    ///                             otherwise.
    ///
    /// - Complexity: O(lg(n))
    ///
    /// - Returns: An index such that each element above the index evaluates
    ///            `true` with respect to `isOrderedAfter(_:)`
    @warn_unused_result
    func upperBound(@noescape isOrderedAfter: Self.Generator.Element -> Bool)
    -> Index {
        var len = self.startIndex.distanceTo(self.endIndex)
        var firstIndex = self.startIndex
        while len > 0 {
            let half = len/2
            let middle = firstIndex.advanceBy(half)
            if isOrderedAfter(self[middle]) {
                len = half
            } else {
                firstIndex = middle.advanceBy(1)
                len -= half + 1
            }
        }
        return firstIndex
    }

    // TODO: This does not currently work as expected.
    /// Returns `true` if element is in the collection and `false` otherwise.
    ///
    /// - Parameter isOrderedBefore: The partitioning predicate. INCOMPLETE
    ///
    /// - Complexity: O(lg(n))
    @warn_unused_result
    func binarySearch(@noescape isOrderedBefore: Self.Generator.Element -> Bool)
    -> Bool {
        let lowerBound = lowerBound(isOrderedBefore)
        return (lowerBound != self.endIndex) && 
                !isOrderedBefore(self[lowerBound])
    }
}
