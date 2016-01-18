Since Genome upgraded to 2.0.0

Here's a backup for 1.0.8 initialization

```Swift
class GenomeClass: BasicClass, StandardMappable {

    // checkout document:
    // https://realm.io/docs/swift/latest/#adding-custom-initializers-to-object-subclasses
    convenience required init(map: Map) throws {
        self.init()
        try self.name = <~map["name"]
        try self.birthday = <~map["birthday"]
        try self.age = <~map["age"]
    }

    func sequence(map: Map) throws {
        try self.name ~> map["name"]
        try self.birthday ~> map["birthday"]
        try self.age ~> map["age"]
    }

}

class OptionalGenomeClass: BasicOptionalClass, StandardMappable {

    convenience required init(map: Map) throws {
        self.init()
        try self.note = <~?map["note"]
        try self.distance.value = <~?map["distance"]
        try self.value = <~map["value"]
    }

    func sequence(map: Map) throws {
        try self.note ~> map["note"]
            .transformToJson {
                $0 ?? NSNull()
            }
        try self.distance.value ~> map["distance"]

    }
}
```
