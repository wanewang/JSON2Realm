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

1. Genome will throw error if marked non-optional whose json is nil

## [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper)

[ObjectMapperObject](https://github.com/jhihguan/JSON2Realm/blob/master/JSON2RealmTests/ObjectMapperRealm.swift)

1. ObjectMapper will set to default value if marked non-optional whose json is nil

## [Argo](https://github.com/thoughtbot/Argo)

[ArgoObject](https://github.com/jhihguan/JSON2Realm/blob/master/JSON2RealmTests/ArgoRealm.swift)

1. Cannot use `curry(self.init)` will error with `Expression was too complext...`
2. Argo will return nil object if marked non-optional whose json is nil
