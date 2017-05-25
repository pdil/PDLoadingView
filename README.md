#### _This library is still a work in progress, as such not all features may work at this time._
_Feel free to submit pull requests, however._

# PDLoadingView

## Installation

Download [`PDLoadingView.swift`](https://github.com/pdil/PDLoadingView/blob/master/PDLoadingView.swift) and add it to your iOS project.

## Usage

* Create the view
``` swift
  let loadingView = PDLoadingView(foreColor: .blue)
```

* Start with a message
``` swift
  loadingView.start(with: "Loading...")
```

* Start with no message
``` swift
  loadingView.start()
```

![no message](https://media.giphy.com/media/xUPGcInptzpKGyS9Mc/giphy.gif)

* Pause & resume loading
``` swift
  if loadingView.isPaused {
    loadingView.resume()
  } else {
    loadingView.pause()
  }
```

* Finish loading
``` swift
  loadingView.end()
```
