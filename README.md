# iTunes

## Tech Stack

- Xcode 26.2
- Swift 6

## Features

- Supports iPad and iPhone
- Supports Dark Mode and Light Mode
- Offline caching of songs and images
- Forward/Backward actions
- Repeat song
- Search using the iTunes API
- Supports Dynamic Type accessibility font sizes
- Unit tests
- Accessibility labels
- Pull to refresh
- Mini Player

---

## Fidelity of Design vs SwiftUI Patterns

Choosing to use SwiftUI in a project has its pros and cons. One of the biggest cons is that you are often expected to use components exactly how Apple designed them, sometimes with limited room for customization.

My approach is always SwiftUI-first, using components as Apple intended whenever possible.

While achieving exact design fidelity is possible, it may require completely recreating existing components.

### Example from this project

On iPad, the Player screen design includes a sidebar located on the right side of the screen containing:
- A toolbar item
- A custom image button to open/close the sidebar

However, SwiftUI’s default sidebar behavior differs from the design:
- Sidebars are placed on the left by default
- The open/close indicator cannot be fully customized
- Toolbar items appear above the sidebar
- `Inspector` can partially replicate the layout, but not exactly as designed

To achieve the exact design, I would need to recreate:
- A custom sidebar component
- A custom toolbar component

Instead, I chose to follow SwiftUI’s native behavior.

In a real-world scenario, I would explain this tradeoff to designers and product managers: while exact fidelity is possible, it would require:
- More development time
- Additional testing
- More maintenance complexity

From a long-term engineering perspective, it would not be the best decision for maintainability.

---

## API Pagination

Although API pagination was a requirement, the iTunes API does not actually support pagination.

Some Stack Overflow posts suggest otherwise, but in practice it is not possible.

Simulating pagination would cause the app to display inconsistent or incorrect results, which could easily be interpreted as a bug

Because of this, I chose not to implement fake pagination behavior.

---

## Why I Used the Environment Approach

Many screens need to:
- Control the currently playing song
- Pause playback
- Skip to the next track

To avoid injecting bindings and references throughout the entire navigation flow, I chose to use SwiftUI Environment values to control the audio player globally in a cleaner and more scalable way.

---

## No Third-Party Frameworks

No third-party dependencies were used in this project.

This decision helps:
- Keep the app lightweight
- Avoid potential issues with abandoned libraries
- Showcase my Swift and SwiftUI skills directly

This is generally the approach I prefer for my projects unless a dependency is absolutely necessary or is a well-established industry standard.

Examples of acceptable exceptions would include:
- Lottie
- Firebase integration libraries
