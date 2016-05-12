
extension MutableCollection {
    /// Reorders the elements of the collection such that all the
    /// elements that match the predicate are ordered after all the
    /// elements that do not match the predicate.
    ///
    /// - Returns: The index of the first element in the reordered
    ///   collection that matches the predicate.
    /// - Complexity: O(n)
    public mutating func partition(
        where predicate: @noescape (Iterator.Element) throws -> Bool
        ) rethrows -> Index {
        var pivot = startIndex
        while true {
            if pivot == endIndex {
                return pivot
            }
            if try predicate(self[pivot]) {
                break
            }
            formIndex(after: &pivot)
        }

        var i = index(after: pivot)
        while i < endIndex {
            if try !predicate(self[i]) {
                swap(&self[i], &self[pivot])
                formIndex(after: &pivot)
            }
            formIndex(after: &i)
        }
        return pivot
    }
}

extension MutableCollection where Self: BidirectionalCollection {
    /// Reorders the elements of the collection such that all the
    /// elements that match the predicate are ordered after all the
    /// elements that do not match the predicate.
    ///
    /// - Returns: The index of the first element in the reordered
    ///   collection that matches the predicate.
    /// - Complexity: O(n)
    public mutating func partition(
        where predicate: @noescape (Iterator.Element) throws -> Bool
        ) rethrows -> Index {
        var lo = startIndex
        var hi = endIndex

        // 'Loop' invariants (at start of loop, all are true):
        // * lo < hi
        // * predicate(self[i]) == false, for i in startIndex ..< lo
        // * predicate(self[i]) == true, for i in hi ..< endIndex

        Loop: while true {
            FindLo: repeat {
                while lo < hi {
                    if try predicate(self[lo]) { break FindLo }
                    formIndex(after: &lo)
                }
                break Loop
            } while false

            FindHi: repeat {
                formIndex(before: &hi)
                while lo < hi {
                    if try !predicate(self[hi]) { break FindHi }
                    formIndex(before: &hi)
                }
                break Loop
            } while false

            swap(&self[lo], &self[hi])
            formIndex(after: &lo)
        }

        return lo
    }
}

extension Collection {
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
        where predicate: @noescape (Iterator.Element) throws -> Bool
        ) rethrows -> Index {
        var len = count
        var lo = startIndex
        while len > 0 {
            let half = len / 2
            let middle = index(lo, offsetBy: half)

            if try predicate(self[middle]) {
                len = half
            } else {
                lo = index(after: middle)
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
        where predicate: @noescape (Iterator.Element) throws -> Bool
        ) rethrows -> Bool {
        var i = startIndex
        while try i != endIndex && !predicate(self[i]) {
            formIndex(after: &i)
        }
        while try i != endIndex && predicate(self[i]) {
            formIndex(after: &i)
        }

        return i == endIndex
    }
}

