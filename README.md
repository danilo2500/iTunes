# iTunes

Xcode 26.2
Swift 6

Features
Support iPad, iPhoneSupports dark mode and light mode
Offline caching of songs and imagesForward/Backward actions
Repeat song
Search on API
Supports Dynamic accessibility fonts sizes 
Unit tests
Accessibility labels
Swipe to refresh 
Mini Player

Fidelity of Design VS  SwiftUI patternsChoosing to use swiftui on your project has it’s pros and cons, biggest con is that you must do exactly how apple thought a component should be used, sometimes with little room to customization, otherwise you may have a bad timeMy approach is always SwiftUI first, to use the components as apple intendedWhile achieving exactly the design is possible, it may require to completely recreate existing componentsExample on this project: There’s a sidebar on iPad on Player Screen located a the right of screen containing a toolbar item inside it and a custom image to open/close itSidebar on swiftui by default is on left, open/close image cannot be closed, and toolbar items appear on top of them. and an inspector also can almost replicate this UI but not as the designs. So to achieve the designs not only I’d have to recreate a sidebar but a toolbar component as wellSo I choose to stick to how it works on SwiftUI, in a real scenario I’d advise and explain this to the designers/product managers, that while the fidelity of design is possible, it will require more time, more tests to make sure the new component is working, and code wise it would not be a good decision when thinking about maintaining  


API Pagination
Despite API pagination been a must-have requirements, the iTunes API does not support it (despite some stack overflow posts stating that I can, it actually not possible.Simulate a pagination would make the app show incorrect values, which could be interpreted as a bug. So I did not implement it 

Why using environment approach
Many screen require to manipulate current song being played, pause, go to next, to avoid injecting reference and binding all over the flow, I choose to use environment to easily control the audio player 