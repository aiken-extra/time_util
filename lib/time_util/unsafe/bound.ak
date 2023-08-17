//// A convenient way to unwrap `Finite(PosixTime)` from an `Interval`,
//// but will **panic** if the interval bound is not `Finite`.

use aiken/interval.{Finite, Interval, IntervalBoundType}
use aiken/time.{PosixTime}
use time_util/bound.{end_of, start_of}

/// Returns the **normalized min-bound** `Posixtime` of `interval`
/// > ⚠️ **WARNING**:
/// > Will panic if min-bound is not Finite
pub fn finite_start_of(interval: Interval<PosixTime>) -> PosixTime {
  let bound = start_of(interval)
  expect Finite(time): IntervalBoundType<PosixTime> = bound.bound_type
  if bound.is_inclusive {
    time
  } else {
    time + 1
  }
}

/// Returns the **normalized max-bound** `PosixTime` of `interval`
/// > ⚠️ **WARNING**:
/// > Will panic if max-bound is not Finite
pub fn finite_end_of(interval: Interval<PosixTime>) -> PosixTime {
  let bound = end_of(interval)
  expect Finite(time): IntervalBoundType<PosixTime> = bound.bound_type
  if bound.is_inclusive {
    time
  } else {
    time - 1
  }
}
