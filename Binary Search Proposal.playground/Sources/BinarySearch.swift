
extension MutableCollectionType {
    /// Reorders the elements of the collection such that all the
    /// elements that match the predicate are ordered before all the
    /// elements that do not match the predicate.
    ///
    /// - Returns: The index of the first element in the reordered
    ///   collection that does not match the predicate.
    public mutating func partition(
        @noescape where predicate: (Generator.Element) throws-> Bool
        ) rethrows -> Index {
        var pivot = startIndex
        while true {
            if pivot == endIndex {
                return pivot
            }
            if try !predicate(self[pivot]) {
                break
            }
            pivot._successorInPlace()
        }
        
        for i in pivot.successor()..<endIndex {
            if try predicate(self[i]) {
                swap(&self[i], &self[pivot])
                pivot._successorInPlace()
            }
        }
        return pivot
    }
}

extension MutableCollectionType where Index: BidirectionalIndexType {
    /// Reorders the elements of the collection such that all the
    /// elements that match the predicate are ordered before all the
    /// elements that do not match the predicate.
    ///
    /// - Returns: The index of the first element in the reordered
    ///   collection that does not match the predicate.
    public mutating func partition(
        @noescape where predicate: (Generator.Element) throws -> Bool
        ) rethrows -> Index {
        var lo = startIndex
        var hi = endIndex
        
        // Loop invariants:
        // * lo < hi
        // * predicate(elements[i]) == true, for i in startIndex ..< lo
        // * predicate(elements[i]) == false, for i in hi ..< endIndex
        
        Loop: while true {
            FindLo: repeat {
                while lo != hi {
                    if try !predicate(self[lo]) { break FindLo }
                    lo._successorInPlace()
                }
                break Loop
            } while false
            
            FindHi: repeat {
                hi._predecessorInPlace()
                while hi != lo {
                    if try predicate(self[hi]) { break FindHi }
                    hi._predecessorInPlace()
                }
                break Loop
            } while false
            
            swap(&self[lo], &self[hi])
            lo._successorInPlace()
        }
        
        return lo
    }
}

extension CollectionType {
    /// Returns the index of the first element in the collection
    /// that doesn't match the predicate.
    ///
    /// The collection must already be partitioned according to the
    /// predicate, as if `x.partition(where: predicate)` had already
    /// been called.
    public func partitionedIndex(
        @noescape where predicate: (Generator.Element) throws -> Bool
        ) rethrows -> Index {
        var len = count
        var firstIndex = startIndex
        while len > 0 {
            let half = len/2
            let middle = firstIndex.advancedBy(half)
            
            if try predicate(self[middle]) {
                firstIndex = middle.advancedBy(1)
                len -= half.successor()
            } else {
                len = half
            }
        }
        return firstIndex
    }
    
    /// Returns the index of `element`, using `isOrderedBefore` as the
    /// comparison predicate while performing a binary search.
    ///
    /// The elements of the collection must already be sorted according
    /// to `isOrderedBefore`, or at least partitioned by `element`.
    ///
    /// - Returns: The index of `element`, or `nil` if `element` isn't
    ///   found.
    public func sortedIndex(of element: Generator.Element,
                               @noescape isOrderedBefore: (Generator.Element, Generator.Element)
        throws -> Bool
        ) rethrows -> Index? {
        
        let i = try partitionedIndex(where: { try isOrderedBefore($0, element) })
        if i != endIndex {
            if try !isOrderedBefore(element, self[i]) {
                return i
            }
        }
        return nil
    }
}

extension CollectionType where Generator.Element: Comparable {
    /// Returns the index of `element`, performing a binary search.
    ///
    /// The elements of the collection must already be sorted, or at
    /// least partitioned by `element`.
    ///
    /// - Returns: The index of `element`, or `nil` if `element` isn't
    ///   found.
    public func sortedIndex(of element: Generator.Element) -> Index? {
        let i = partitionedIndex(where: { $0 < element })
        if i != endIndex && element == self[i] {
            return i
        }
        return nil
    }
}

extension CollectionType where
    SubSequence: CollectionType,
    SubSequence.Index == Index,
    SubSequence.Generator.Element == Generator.Element
{
    /// Returns the range of elements equivalent to `element`, using
    /// `isOrderedBefore` as the comparison predicate while performing
    /// a binary search.
    ///
    /// The elements of the collection must already be sorted according
    /// to `isOrderedBefore`, or at least partitioned by `element`.
    ///
    /// - Returns: The range of indices corresponding with elements
    ///   equivalent to `element`, or an empty range with its
    ///   `startIndex` equal to the insertion point for `element`.
    public func sortedRange(of element: Generator.Element,
                               @noescape isOrderedBefore: (Generator.Element, Generator.Element)
        throws -> Bool
        ) rethrows -> Range<Index>
    {
        var len = count
        var (firstIndex, lastIndex) = (startIndex, endIndex)
        
        while len > 0 {
            let half = len / 2
            let middle = firstIndex.advancedBy(half)
            if try isOrderedBefore(self[middle], element) {
                firstIndex = middle.successor()
                len -= half + 1
            } else if try isOrderedBefore(element, self[middle]) {
                lastIndex = middle
                len = half
            } else {
                firstIndex = try self[firstIndex..<middle]
                    .partitionedIndex(where: { try isOrderedBefore($0, element) })
                lastIndex = try self[firstIndex..<middle]
                    .partitionedIndex(where: { try !isOrderedBefore(element, $0) })
                return firstIndex..<lastIndex
            }
        }
        
        return firstIndex..<firstIndex
    }
}

extension CollectionType where
    Generator.Element: Comparable,
    SubSequence: CollectionType,
    SubSequence.Index == Index,
    SubSequence.Generator.Element == Generator.Element
{
    /// Returns the range of elements equal to `element`, performing
    /// a binary search.
    ///
    /// The elements of the collection must already be sorted, or at
    /// least partitioned by `element`.
    ///
    /// - Returns: The range of indices corresponding with elements
    ///   equal to `element`, or an empty range with its `startIndex`
    ///   equal to the insertion point for `element`.
    public func sortedRange(of element: Generator.Element) -> Range<Index> {
        var len = count
        var (firstIndex, lastIndex) = (startIndex, endIndex)
        
        while len > 0 {
            let half = len / 2
            let middle = firstIndex.advancedBy(half)
            if self[middle] < element {
                firstIndex = middle.successor()
                len -= half + 1
            } else if element < self[middle] {
                lastIndex = middle
                len = half
            } else {
                firstIndex = self[firstIndex..<middle]
                    .partitionedIndex(where: { $0 < element })
                lastIndex = self[middle..<lastIndex]
                    .partitionedIndex(where: { $0 <= element })
                return firstIndex..<lastIndex
            }
        }
        
        return firstIndex..<firstIndex
    }
}


