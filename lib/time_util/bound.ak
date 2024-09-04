use aiken/interval.{
  Finite, Interval, IntervalBound, IntervalBoundType, NegativeInfinity,
  PositiveInfinity, max, min,
}
use time_util/time.{PosixTime}

/// Returns the **min-bound** of `interval`
/// ```
/// start_of(after(5)).bound_type == Finite(5)
/// start_of(before(5)).bound_type == NegativeInfinity
/// start_of(between(5, 10)).bound_type == Finite(5)
/// 
/// // also works with flipped `between` arguments
/// start_of(between(10, 5)).bound_type == Finite(5)
/// // as of Aiken v1.0.8-alpha
/// ```
pub fn start_of(interval: Interval<PosixTime>) -> IntervalBound<PosixTime> {
  min(interval.lower_bound, interval.upper_bound)
}

/// Returns the **min-bound type** of `interval` with **normalized** `Finite(PosixTime)`
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

/// May return the **normalized min-bound** `Posixtime` of `interval`
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

/// May return the **normalized max-bound** `PosixTime` of `interval`
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

/// Returns the **max-bound type** of `interval` with **normalized** `Finite(PosixTime)`
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

/// Returns the **max-bound** of `interval`
/// ```
/// end_of(after(5)).bound_type == PositiveInfinity
/// end_of(before(5)).bound_type == Finite(5)
/// end_of(between(5, 10)).bound_type == Finite(10)
/// 
/// // also works with flipped `between` arguments
/// end_of(between(10, 5)).bound_type == Finite(10)
/// // as of Aiken v1.0.8-alpha
/// ```
pub fn end_of(interval: Interval<PosixTime>) -> IntervalBound<PosixTime> {
  max(interval.lower_bound, interval.upper_bound)
}
