//: ## SortedDictionary

/// A dictionary that keeps its contents ordered by its keys.
struct SortedDictionary<Key: Comparable, Value>:
    CollectionType, DictionaryLiteralConvertible
{
    var _storage: [(key: Key, value: Value)]
    
    // CollectionType
    var startIndex: Int { return _storage.startIndex }
    var endIndex: Int   { return _storage.endIndex }
    subscript(index: Int) -> (key: Key, value: Value) {
        return _storage[index]
    }
    
    // DictionaryLiteralConvertible
    init(dictionaryLiteral elements: (Key, Value)...) {
        self._storage = elements
            .sort { $0.0 < $1.0 }
            .map { (key: $0, value: $1) }
    }
    
    // key/value access
    subscript(key: Key) -> Value? {
        get {
            let i = _storage.partitionedIndex(where: { $0.key < key })
            if i != endIndex && _storage[i].key == key {
                return _storage[i].value
            }
            return nil
        }
        set {
            // find insertion point
            let i = _storage.partitionedIndex(where: { $0.key < key })
            
            if i != endIndex && _storage[i].key == key {
                // update or delete
                if let newValue = newValue {
                    _storage[i].value = newValue
                } else {
                    _storage.removeAtIndex(i)
                }
            } else if let newValue = newValue {
                // insert
                _storage.insert((key, newValue), atIndex: i)
            }
        }
    }
}


//: ## Example
// Create SortedDictionary
var dict: SortedDictionary = [
    "wallop": "to hit (someone or something) very hard",
    "mollify": "to make (someone) less angry : to calm (someone) down"
]
// Add two new definitions
dict["fillip"] = "an added part or feature that makes something more interesting or exciting"
dict["defenestration"] = "a throwing of a person or thing out of a window"

// Different ways of accessing data
dict.first?.key
dict["mollify"]
dict["perturb"]

// Iterate over sorted word/definition pairs
for (word, def) in dict {
    print("\(word): \(def)")
}


//: Jump to [previous](@previous)
