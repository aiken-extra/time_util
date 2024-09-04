//// Bring back [`aiken/time.{PosixTime}`](https://github.com/aiken-lang/stdlib/blob/205e8f9a06c6f3c9e7c93bb7745e390515e2e2cf/lib/aiken/time.ak)
//// after being removed in [`stdlib v2.0.0`](https://github.com/aiken-lang/stdlib/releases/tag/v2.0.0#:~:text=The%20module%20aiken/time.%20The%20PosixTime%20alias%20is%20no%20longer%20used%20anywhere)

/// A number of milliseconds since 00:00:00 UTC on 1 January 1970.
pub type PosixTime =
  Int
