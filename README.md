# JSON2Realm
Integrate with JSON Parser to Realm Object

[![Language: Swift](https://img.shields.io/badge/lang-Swift-yellow.svg?style=flat)](https://developer.apple.com/swift/)
[![Language: Swift](https://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://opensource.org/licenses/MIT)
[![Build Status](https://travis-ci.org/jhihguan/JSON2Realm.svg)](https://travis-ci.org/jhihguan/JSON2Realm)

## Basic Class

```
class BasicClass: Object {
  dynamic var name: String = ""
  dynamic var birthday: String = ""
  dynamic var age: Int = 0
}

class BasicOptionalClass: Object {
  var distance = RealmOptional<Int>()
  dynamic var note: String? = nil
  dynamic var value: Int = 0
}

```

## [Genome](https://github.com/LoganWright/Genome)

[GenomeObject](https://github.com/jhihguan/JSON2Realm/blob/master/JSON2RealmTests/GenomeRealm.swift)

1. Genome will throw error while encounter parsing issue
2. Have method for transform object to `JSON`
3. Customizable JSON value representation (ex. return NSNull value)

## [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)

[ObjectMapperObject](https://github.com/jhihguan/JSON2Realm/blob/master/JSON2RealmTests/ObjectMapperRealm.swift)

link: [ObjectMapper+Realm](https://github.com/Hearst-DD/ObjectMapper#objectmapper--realm)

1. ObjectMapper will set to default value while encounter parsing issue
2. Have method for transform object to `JSON` but need to execute inside `Realm` write transaction
3. Customizable JSON value representation (ex. return NSNull value)

## [Argo](https://github.com/thoughtbot/Argo)

[ArgoObject](https://github.com/jhihguan/JSON2Realm/blob/master/JSON2RealmTests/ArgoRealm.swift)

1. Cannot use `curry(self.init)` will error with `Expression was too complext...`
2. Argo will return nil object while encounter parsing issue
3. Can not transform object to JSON

## [Gloss](https://github.com/hkellaway/Gloss)

[GlossObject](https://github.com/jhihguan/JSON2Realm/blob/master/JSON2RealmTests/GlossRealm.swift)

1. Need to use `final` on class since it use `Self` on protocol extension
2. Gloss have the ability to customize action while encounter parsing issue(return nil for this example)
3. Have method for transform object to `JSON`

## [Unbox](https://github.com/JohnSundell/Unbox)

[UnboxObject](https://github.com/jhihguan/JSON2Realm/blob/master/JSON2RealmTests/UnboxRealm.swift)

1. Unbox can either return nil or throw error while encounter parsing issue
2. Can not transform object to JSON
