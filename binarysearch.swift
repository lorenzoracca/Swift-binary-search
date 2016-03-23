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
    
    ///Returns the index of the first element in the collection which compares greater than `value`.
    @warn_unused_result
    func upperBound(value: Self.Generator.Element) -> Index {
        var len = self.startIndex.distanceTo(self.endIndex)
        var firstIndex = self.startIndex
        while len > 0 {
            let half = len/2
            let middle = firstIndex.advancedBy(half)
            
            if value < self[middle] {
                len = half
            } else {
                firstIndex = middle.advancedBy(1)
                len -= half.successor()
            }
        }
        return firstIndex
    }

    /// Returns `true` if the collection contains `value` and
    /// `false` otherwise.
    ///
    /// - Complexity: O(lg(n))
    ///
    /// - Returns: `true` if the collection contains `value`
    ///            and `false` otherwise.
    @warn_unused_result
    func binarySearch(value: Self.Generater.Element) -> Index {
        let lowerBound = lowerBound(value)
        return (lowerBound != self.endIndex) && !(value < lowerBound)
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
    func lowerBound(value: Self.Generator.Element,
        @noescape isOrderedBefore: (Self.Generator.Element,
                                    Self.Generator.Element -> Bool) -> Index {
        var len = self.startIndex.distanceTo(self.endIndex)
        var firstIndex = self.startIndex
        while len > 0 {
            let half = len/2
            let middle = firstIndex.advanceBy(half)
            if isOrderedBelow(self[middle], value) {
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
    /// - Parameter isOrderedBelow: The partitioning predicate. Returns `true`
    ///                             for elements that are ordered below with
    ///                             respect to the partitioning element and
    ///                             `false` otherwise.
    ///
    /// - Complexity: O(lg(n))
    ///
    /// - Returns: An index such that each element above the index evaluates
    ///            `true` with respect to `isOrderedBefore(_:)`
    @warn_unused_result
    func upperBound(value: Self.Generator.Element,
        @noescape isOrderedBefore: (Self.Generator.Element, 
                                    Self.Generator.Element) -> Bool) -> Index {
        var len = self.startIndex.distanceTo(self.endIndex)
        var firstIndex = self.startIndex
        while len > 0 {
            let half = len/2
            let middle = firstIndex.advanceBy(half)
            if isOrderedBefore(value, self[middle]) {
                len = half
            } else {
                firstIndex = middle.advanceBy(1)
                len -= half + 1
            }
        }
        return firstIndex
    }

    /// Returns `true` if element is in the collection and `false` otherwise.
    ///
    /// - Parameter isOrderedBefore: The partitioning predicate. INCOMPLETE
    ///
    /// - Complexity: O(lg(n))
    @warn_unused_result
    func binarySearch(value: Self.Generator.Element,
        @noescape isOrderedBefore: (Self.Generator.Element, 
                                    Self.Generator.Element) -> Bool) -> Bool {
        let lowerBound = lowerBound(isOrderedBefore)
        return (lowerBound != self.endIndex) && 
               !isOrderedBefore(value, self[lowerBound])
    }
}
