
extension MutableCollectionType {
    /// Reorders the elements of the collection such that all the
    /// elements that match the predicate are ordered after all the
    /// elements that do not match the predicate.
    ///
    /// - Returns: The index of the first element in the reordered
    ///   collection that matches the predicate.
    /// - Complexity: O(n)
    public mutating func partition(
        @noescape where predicate: (Generator.Element) throws -> Bool
        ) rethrows -> Index {
        var pivot = startIndex
        while true {
            if pivot == endIndex {
                return pivot
            }
            if try predicate(self[pivot]) {
                break
            }
            pivot._successorInPlace()
        }

        for i in pivot.successor()..<endIndex {
            if try !predicate(self[i]) {
                swap(&self[i], &self[pivot])
                pivot._successorInPlace()
            }
        }
        return pivot
    }
}

extension MutableCollectionType where Index: BidirectionalIndexType {
    /// Reorders the elements of the collection such that all the
    /// elements that match the predicate are ordered after all the
    /// elements that do not match the predicate.
    ///
    /// - Returns: The index of the first element in the reordered
    ///   collection that matches the predicate.
    /// - Complexity: O(n)
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
                    if try predicate(self[lo]) { break FindLo }
                    lo._successorInPlace()
                }
                break Loop
            } while false

            FindHi: repeat {
                hi._predecessorInPlace()
                while hi != lo {
                    if try !predicate(self[hi]) { break FindHi }
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
    /// that matches the predicate.
    ///
    /// If no element matches the predicate, the collection's `endIndex`
    /// is returned. The collection must already be partitioned according
    /// to the predicate, as if `x.partition(where: predicate)` had
    /// already been called.
    ///
    /// - Complexity: O(log n)
    public func partitionPoint(
        @noescape where predicate: (Generator.Element) throws -> Bool
        ) rethrows -> Index {
        var len = count
        var lo = startIndex
        while len > 0 {
            let half = len / 2
            let middle = lo.advancedBy(half)

            if try predicate(self[middle]) {
                len = half
            } else {
                lo = middle.successor()
                len -= half + 1
            }
        }
        return lo
    }

    /// Returns `true` iff the collection is partitioned according to
    /// the given predicate.
    ///
    /// - Complexity: O(n)
    public func isPartitioned(
        @noescape where predicate: (Generator.Element) throws -> Bool
        ) rethrows -> Bool {
        var i = startIndex
        while try i != endIndex && !predicate(self[i]) {
            i._successorInPlace()
        }
        while try i != endIndex && predicate(self[i]) {
            i._successorInPlace()
        }

        return i == endIndex
    }
}

