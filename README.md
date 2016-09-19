# Noted

A minimalistic and effective replacement for `NSNotificationCenter`, that promotes the observer pattern and keeps weak references to it's observers.

**Features:**  

* Simple Setup
* Use `enum` As Notification
* Weak References
* No Unregister Necessary
* OSS, Free, Maintained, No Dependencies


## 📝 Requirements

* iOS 8.0+
* Swift 3.0+

## 📦 Installation

### Carthage
~~~
# Swift 3
github "nodes-ios/Noted" ~> 2.0

# Swift 2
github "nodes-ios/Noted" ~> 1.0
~~~

## 💻 Usage

Noted itself is a singleton that you can access from anywhere in your app, and might be especially useful for easily sending messages to your router and/or any other class.

Start with:

```swift
import Noted
```

### Protocols

There are two protocols you need to implement in order for *Noted* to work. One for the notification (object/structure/enum) a.k.a `Note` and second for each observer you want to add.

**Note Type**

Just make your object conform to it and that's it!

We recommend using `enum`s as you get most out of Swift and you can associate values without wrapping them in some ugly dictionary with string keys.

```swift
enum Note: NoteType {
	case ShowLoginFlow
	case SignupForPush(userId: Int)
}
```

**Note Observer**

The observer protocol requires you to implement a function `didReceive(note: NoteType)` that  will be called each time a notification is sent and your observer is add as and observer.

> **NOTE:** This function will be executed on the main thread.

```swift
class ViewController: UIViewController, NoteObserver {
	// MARK: - Note Observer -
	func didReceive(note: NoteType) {
		switch note {
		case .SingupForPush(let userId):
			print(userId)
		}
	}
}
```

### Actions

There are three actions Noted supports:

* Add Observer
* Remove Observer*
* Post Note

> *All observers have a weak reference in Noted, so you are not required to manually remove observers if you want them to disappear on deinit.

#### Adding Observer

```swift
func viewDidLoad() {
	super.viewDidLoad()
	Noted.defaultInstance.add(observer: self)
}

```

> **NOTE:** You need to keep a strong reference to the observer, otherwise it will get removed immediately after adding.

#### Removing Observer

```swift
func viewWillDisappear() {
	super.viewWillDisappear()
	Noted.defaultInstance.remove(observer: self)
}

```

#### Posting Notes

Posting notes is as simple as it could get, simply call `post(note: note)` and it will be send momentarily.

```swift
func buttonPressed() {
	Noted.defaultInstance.post(note: Note.SignupForPush(userId: 1))
}
```


> **NOTE:** Be advised that Noted uses a background thread and synchronizes post action with addition and removal of observers.

### Advanced Features

If you send a lot of notifications and have many observers, this section might be useful for you.

#### Filtering

Noted offers an option to filter which observers will receive a notification and by default uses a `PassthroughNoteFilter` that let's all notifications come through.

You can override this behaviour by providing your own `NoteFilter` on the observer.

```swift
struct RandomFilter: NoteFilter {
    func shouldFilter(note: NoteType) -> Bool {
        return arc4random() % 10 < 5
    }
}

class TestObserver: NoteObserver {
    let noteFilter: NoteFilter = RandomFilter()

    func didReceive(note: NoteType) { }
}
```

> **NOTE:** Do not use the filter provided above unless you have #courage.

## 👥 Credits
Made with ❤️ at [Nodes](http://nodesagency.com).

## 📄 License
**Noted** is available under the MIT license. See the [LICENSE](https://github.com/nodes-ios/Noted/blob/master/LICENSE) file for more info.
