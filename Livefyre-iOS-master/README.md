StreamHub-iOS-SDK
=================

Use this open-source library to integrate Livefyre services into your native iOS app.  This SDK provides a thin layer for common API mechanisms and endpoints on top of the excellent AFNetworking stack.

For more information, please see the CommentStream sample app [[1]] or Livefyre HTTP API documentation [[2]].

## Integrating the SDK into your project

### As a Cocoa Pod (recommended)

The most convenient way to add StreamHub-iOS SDK to your project is to use CocoaPods. 
If you don't have CocoaPods, run `gem install cocoapods` and `pod setup`. 
Here is an example Podfile:

```ruby
platform :ios, :deployment_target => '6.0'

pod 'StreamHub-iOS-SDK', '~> 0.3.0'
```
You will also need to add a Specs repository to your CocoaPod installation (this will clone it to `~/.cocoapods/repos` directory):

    pod repo add livefyre https://github.com/Livefyre/cocoapods.git

Once your Podfile is created in your app project root and the repository above added, run:

    pod install

This will download all the dependencies and create a file `MyApp.xcworkspace`, which you should use from now on to open your app project in Xcode.

### As an Xcode subproject

Alternatively, clone the repository:

    git clone https://github.com/Livefyre/StreamHub-iOS-SDK.git

Next, add the Xcode project (LFSClient.xcodeproj) to your app as a subproject (easily done by simply dragging the LFSClient.xcodeproj file into Project Navigator pane in Xcode).

You will also need to do the same with any of the dependencies (AFNetworking [[3]], JSONKit [[4]]).

## Download everything at once (not recommended)

    cd ~/dev
    git clone https://github.com/Livefyre/StreamHub-iOS-SDK.git
    cd StreamHub-iOS-SDK
    git submodule init
    git submodule update
    pod repo add livefyre https://github.com/Livefyre/cocoapods.git
    pod install
    cd examples/CommentStream
    pod install
    open CommentStream.xcworkspace

## Xcode Documentation

You can browse the documentation online [[5]] or you can build the "Documentation" target in your Xcode (requires `appledoc` to be installed) on your system.

## Requirements

StreamHub iOS SDK versions since v0.2.0 require iOS 6.0 or higher.

## Appendix (JSON support)

For those looking at StreamHub-iOS SDK internals, please note that we use a modified version of JSONKit [[4]] as the default JSON parser (instead of Apple-provided NSJSONSerialization). We had to do this because the Apple-provided parser does not support decoding JSON files that contain integers or floating point numbers that are larger than those that can be represented by the system. Our modified version of JSONKit truncates very large numbers to corresponding system maximum, instead of throwing an exception.

## License

This software is licensed under the MIT License.

The MIT License (MIT)

Copyright (c) 2013 Livefyre

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


[1]: https://github.com/Livefyre/StreamHub-iOS-Example-App
[2]: http://answers.livefyre.com/developers/reference/http-reference/
[3]: https://github.com/mattt/AFNetworking
[4]: https://github.com/escherba/JSONKit
[5]: http://livefyre.github.com/StreamHub-iOS-SDK/
