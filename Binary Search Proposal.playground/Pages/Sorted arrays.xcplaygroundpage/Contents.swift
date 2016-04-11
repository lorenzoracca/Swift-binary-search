//: ## Binary search

let sortedNumbers = [1, 2, 3, 3, 4, 4, 4, 4, 4, 5, 5, 6, 8, 9, 10]

// Find the element '5' using `sortedIndex(of:)`
if let i = sortedNumbers.sortedIndex(of: 5) {
    sortedNumbers.suffixFrom(i)
}

// Find the range of all '4's using `sortedRange(of:)`
let r = sortedNumbers.sortedRange(of: 4)
r.count
sortedNumbers[r]

// Search for '7' using `sortedIndex(of:)`
if let i = sortedNumbers.sortedIndex(of: 7) {
    sortedNumbers[i]
} else {
    "Not found"
}

// Find the insertion index for '7' using `partitionedIndex(of:)`
let i = sortedNumbers.partitionedIndex(where: {$0 < 7 })
"Insertion point is \(i)"
sortedNumbers.prefixUpTo(i)
sortedNumbers.suffixFrom(i)


//: ## Partition

var chars = Array("a deserving porcupine".characters)

// Change 'pivotChar' to see the affect on partitioning
let pivotChar: Character = "j"

// Reorder 'chars' using `partition(where:)`
let j = chars.partition(where: { $0 < pivotChar})
chars.prefixUpTo(j)
chars.suffixFrom(j)


//: Jump to [next](@next)
