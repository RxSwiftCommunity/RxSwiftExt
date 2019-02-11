readme = """
[![CircleCI](https://img.shields.io/circleci/project/github/RxSwiftCommunity/RxSwiftExt/master.svg)](https://circleci.com/gh/RxSwiftCommunity/RxSwiftExt/tree/master)
![pod](https://img.shields.io/cocoapods/v/RxSwiftExt.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

RxSwiftExt
===========

If you're using [RxSwift](https://github.com/ReactiveX/RxSwift), you may have encountered situations where the built-in operators do not bring the exact functionality you want. The RxSwift core is being intentionally kept as compact as possible to avoid bloat. This repository's purpose is to provide additional convenience operators and Reactive Extensions.

Installation
===========

This branch of RxSwiftExt targets Swift 4.x and RxSwift 4.0.0 or later.

* If you're looking for the Swift 3 version of RxSwiftExt, please use version `2.5.1` of the framework.
* If your project is running on Swift 2.x, please use version `1.2` of the framework.

#### CocoaPods

Using Swift 4:

```ruby
pod 'RxSwiftExt'
```

This will install both the `RxSwift` and `RxCocoa` extensions.
If you're interested in only installing the `RxSwift` extensions, without the `RxCocoa` extensions, simply use:

```ruby
pod 'RxSwiftExt/Core'
```

Using Swift 3:

```ruby
pod 'RxSwiftExt', '2.5.1'
```

If you use Swift 2.x:

```ruby
pod 'RxSwiftExt', '1.2'
```

#### Carthage

Add this to your `Cartfile`

```
github \"RxSwiftCommunity/RxSwiftExt\"
```

Operators
===========

RxSwiftExt is all about adding operators and Reactive Extensions to [RxSwift](https://github.com/ReactiveX/RxSwift)!

## Operators

"""

pages = Dir.glob('../Playground/RxSwiftExtPlayground.playground/Pages/*.xcplaygroundpage')
           .sort_by { |p| p.downcase }
           .select { |p| !p.end_with? 'Index.xcplaygroundpage' }
           .sort()

output = pages.map { |page| 
    pageName = page.split('/').last
    operatorName = pageName.chomp('.xcplaygroundpage')

    code = File.read("#{page}/Contents.swift")

    docs = code.scan(/\/\*:\n\s+##\s#{operatorName}\n\n(.*?)\*\//m)
    if docs.count != 1 || docs.first.count == 0 then
        puts "Missing documentation match for #{operatorName}"
        next
    end

    examples = code.scan(/example.*\s\{\n(.*)\}/m)

    if examples.count != 1 || examples.first.count == 0 then
        puts "Missing code sample for #{operatorName}"
        next
    end

    examples = examples
                .first
                .map { |item| 
                    item
                        .split("\n")
                        .map { |piece| 
                            piece.sub(/^(\s{4}|\t)/, '')
                        }
                        .join("\n")
                        .gsub(/\n\nplaygroundShouldContinueIndefinitely\(\)/, '')
                }

    info = docs.first.first.sub(/\n/, '<br />')
    example = examples.first
"""
<li>
<details>
<summary><strong>#{operatorName}</strong></summary>
#{info}

```swift
#{example}
```
</details>
</li>
"""
}.drop_while { |i| i == nil }

puts "#{readme}<ul>#{output.join()}</ul>"
