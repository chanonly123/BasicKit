# BasicKit for iOS project


## PagedCollectionView

<img style="width:50%;" src="https://github.com/chanonly123/BasicKit/blob/main/Demo/PagedCollectionView.gif" />

```
    PagedCollectionView(items: items, selected: $val, { val in
            Text("\(val.title)")
                .font(.system(size: 30))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(.blue)
        })
        .itemSize(width: 200, height: 200)
        .insets(50)
        .scroll(.vertical)
        .frame(width: 300, height: 300)
```

## SomeDefaults

```
// CustomType must conform to Codable
extension SomeDefaultsKey {
    static var user: SomeDefaultsKey<User> { SomeDefaultsKey<User>("user", defaultVal: nil) }
    static var array: SomeDefaultsKey<[Int]> { SomeDefaultsKey<[Int]>("array", defaultVal: nil) }
    static var value: SomeDefaultsKey<Int> { SomeDefaultsKey<Int>("value", defaultVal: nil) }
}
defaults[.user] = user
defaults[.value] = 10
defaults[.array] = [1,2,3,4,5]
```

## SomeURLRequest

```

```