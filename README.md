# SwiftyLiveApi

SwiftyLiveApi is a simple package to work with Infinite Flight Live API. It features support for all available endpoints, safety mechanisms against exceeding request limits, Live API error types, beautiful documentation right in XCode and support up to Swift 3.

## Usage

Setup is as easy as initializing an instance of ```LiveApiClient``` with your API key. If needed, you can set the ```requestLimitPerMinute``` value both in the initializer and later as just a value of the class. Please remember that just like on the road, unless you know what you're doing you shouldn't go over 100. Results have different extensions which transform stuff like ```Int``` frequency type into a nice enum. For your convenience, all functions are named almost exactly as the pages on them in the User Guide.

## Reporting bugs
I tested it on random flights from expert server to the point I didn't get errors, but I could have easily missed an optional somewhere or misspelled a value. If you stumble upon something, just PM me your problem and a copy of the JSON response that causes problems on Discord or [IFC](https://community.infiniteflight.com/u/Alexander_Nikitin).
