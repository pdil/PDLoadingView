# PDLoadingView

## Installation

Download `PDLoadingView.swift` and add it to your iOS project.

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
  loadingView.start(with: "")
```

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
