use aiken/interval.{
  Finite, Interval, IntervalBound, IntervalBoundType, NegativeInfinity,
  PositiveInfinity,
}
use time_util/time.{PosixTime}

/// Returns the `lower_bound` of an `interval`
pub fn start_of(interval: Interval<PosixTime>) -> IntervalBound<PosixTime> {
  //   min(interval.lower_bound, interval.upper_bound)
  interval.lower_bound
}

/// Returns the `lower_bound` type of an `interval` with **normalized** `Finite(PosixTime)`
///
/// i.e. returns,
/// ```
/// let bound = start_of(interval)
/// when bound.bound_type is {
///   Finite(time) ->
///     Finite(
///       if bound.is_inclusive {
///         time
///       } else {
///         time + 1
///       },
///     )
///   PositiveInfinity -> PositiveInfinity
///   NegativeInfinity -> NegativeInfinity
/// }
/// ```
pub fn start_bound_type_of(
  interval: Interval<PosixTime>,
) -> IntervalBoundType<PosixTime> {
  let bound = start_of(interval)
  when bound.bound_type is {
    Finite(time) ->
      Finite(
        if bound.is_inclusive {
          time
        } else {
          time + 1
        },
      )
    PositiveInfinity -> PositiveInfinity
    NegativeInfinity -> NegativeInfinity
  }
}

/// May return the **normalized lower-bound** `Posixtime` of `interval`
pub fn finite_start_of(interval: Interval<PosixTime>) -> Option<PosixTime> {
  let bound = start_of(interval)
  when bound.bound_type is {
    Finite(time) ->
      Some(
        if bound.is_inclusive {
          time
        } else {
          time + 1
        },
      )
    _ -> None
  }
}

/// May return the **normalized uppoer-bound** `PosixTime` of `interval`
pub fn finite_end_of(interval: Interval<PosixTime>) -> Option<PosixTime> {
  let bound = end_of(interval)
  when bound.bound_type is {
    Finite(time) ->
      Some(
        if bound.is_inclusive {
          time
        } else {
          time - 1
        },
      )
    _ -> None
  }
}

/// Returns the `upper_bound` type of an `interval` with **normalized** `Finite(PosixTime)`
///
/// i.e. returns,
/// ```
/// let bound = end_of(interval)
/// when bound.bound_type is {
///   Finite(time) ->
///     Finite(
///       if bound.is_inclusive {
///         time
///       } else {
///         time - 1
///       },
///     )
///   PositiveInfinity -> PositiveInfinity
///   NegativeInfinity -> NegativeInfinity
/// }
/// ```
pub fn end_bound_type_of(
  interval: Interval<PosixTime>,
) -> IntervalBoundType<PosixTime> {
  let bound = end_of(interval)
  when bound.bound_type is {
    Finite(time) ->
      Finite(
        if bound.is_inclusive {
          time
        } else {
          time - 1
        },
      )
    PositiveInfinity -> PositiveInfinity
    NegativeInfinity -> NegativeInfinity
  }
}

/// Returns the `upper_bound` of an `interval`
pub fn end_of(interval: Interval<PosixTime>) -> IntervalBound<PosixTime> {
  //   max(interval.lower_bound, interval.upper_bound)
  interval.upper_bound
}
