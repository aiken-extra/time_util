//// A cheaper version of `time_util/posixtime` in terms of memory and CPU usage.

use aiken/interval.{Finite, Interval, NegativeInfinity, PositiveInfinity}
use time_util/bound.{end_of, start_of}
use time_util/time.{PosixTime}

/// Tells whether `some_interval` is **after** the specified `PosixTime`.
/// This function is an alias for `starts_after`.
pub fn is_after(some_interval: Interval<PosixTime>, deadline: PosixTime) -> Bool {
  some_interval |> starts_after(deadline)
}

/// Tells whether `some_interval` is **after-or-at** the specified `PosixTime`.
/// This function is an alias for `starts_after_or_at`.
pub fn is_after_or_at(
  some_interval: Interval<PosixTime>,
  deadline: PosixTime,
) -> Bool {
  some_interval |> starts_after_or_at(deadline)
}

/// Tells whether `some_interval` is **before** the specified `PosixTime`.
/// This function is an alias for `ends_before`.
pub fn is_before(
  some_interval: Interval<PosixTime>,
  deadline: PosixTime,
) -> Bool {
  some_interval |> ends_before(deadline)
}

/// Tells whether `some_interval` is **before-or-at** the specified `PosixTime`.
/// This function is an alias for `ends_before_or_at`.
pub fn is_before_or_at(
  some_interval: Interval<PosixTime>,
  deadline: PosixTime,
) -> Bool {
  some_interval |> ends_before_or_at(deadline)
}

/// Tells whether `some_interval` starts **after** the specified `PosixTime`
/// ```
/// after(6) |> starts_after(5) == True
/// between(6, 9) |> starts_after(5) == True
/// strictly_after(5) |> starts_after(5) == True
/// strictly_between(5, 8) |> starts_after(5) == True
/// 
/// // negative cases:
/// after(4) |> starts_after(5) == False
/// strictly_after(3) |> starts_after(5) == False
/// before(4) |> starts_after(5) == False
/// before(5) |> starts_after(5) == False
/// before(6) |> starts_after(5) == False
/// strictly_before(5) |> starts_after(5) == False
/// strictly_before(6) |> starts_after(5) == False
/// strictly_before(7) |> starts_after(5) == False
/// between(1, 4) |> starts_after(5) == False
/// between(2, 5) |> starts_after(5) == False
/// between(3, 6) |> starts_after(5) == False
/// between(4, 7) |> starts_after(5) == False
/// strictly_between(2, 5) |> starts_after(5) == False
/// strictly_between(3, 6) |> starts_after(5) == False
/// 
/// // interval starts AT deadline:
/// after(5) |> starts_after(5) == False
/// between(5, 8) |> starts_after(5) == False
/// strictly_after(4) |> starts_after(5) == False
/// strictly_between(4, 7) |> starts_after(5) == False
/// ```
pub fn starts_after(
  some_interval: Interval<PosixTime>,
  deadline: PosixTime,
) -> Bool {
  let start = start_of(some_interval)
  when start.bound_type is {
    Finite(time) -> {
      let time =
        if start.is_inclusive {
          time
        } else {
          time + 1
        }
      time > deadline
    }
    PositiveInfinity -> True
    NegativeInfinity -> False
  }
}

// <s>DRY - Don't Repeat Yourself</s>
// it is cheaper to put the logics of `start/end_bound_type_of` here;
// proven by the tests result

/// Tells whether `some_interval` starts **after-or-at** the specified `PosixTime`
/// ```
/// after(6) |> starts_after_or_at(5) == True
/// strictly_after(5) |> starts_after_or_at(5) == True
/// between(6, 9) |> starts_after_or_at(5) == True
/// strictly_between(5, 8) |> starts_after_or_at(5) == True
/// 
/// // interval starts AT deadline:
/// after(5) |> starts_after_or_at(5) == True
/// strictly_after(4) |> starts_after_or_at(5) == True
/// between(5, 8) |> starts_after_or_at(5) == True
/// strictly_between(4, 7) |> starts_after_or_at(5) == True
/// 
/// // negative cases:
/// after(4) |> starts_after_or_at(5) == False
/// strictly_after(3) |> starts_after_or_at(5) == False
/// before(4) |> starts_after_or_at(5) == False
/// before(5) |> starts_after_or_at(5) == False
/// before(6) |> starts_after_or_at(5) == False
/// strictly_before(5) |> starts_after_or_at(5) == False
/// strictly_before(6) |> starts_after_or_at(5) == False
/// strictly_before(7) |> starts_after_or_at(5) == False
/// between(1, 4) |> starts_after_or_at(5) == False
/// between(2, 5) |> starts_after_or_at(5) == False
/// between(3, 6) |> starts_after_or_at(5) == False
/// between(4, 7) |> starts_after_or_at(5) == False
/// strictly_between(2, 5) |> starts_after_or_at(5) == False
/// strictly_between(3, 6) |> starts_after_or_at(5) == False
/// ```
pub fn starts_after_or_at(
  some_interval: Interval<PosixTime>,
  deadline: PosixTime,
) -> Bool {
  let start = start_of(some_interval)
  when start.bound_type is {
    Finite(time) -> {
      let time =
        if start.is_inclusive {
          time
        } else {
          time + 1
        }
      time >= deadline
    }
    PositiveInfinity -> True
    NegativeInfinity -> False
  }
}

/// Tells whether `some_interval` starts **before** the specified `PosixTime`
/// ```
/// after(4) |> starts_before(5) == True
/// strictly_after(3) |> starts_before(5) == True
/// before(4) |> starts_before(5) == True
/// before(5) |> starts_before(5) == True
/// before(6) |> starts_before(5) == True
/// strictly_before(5) |> starts_before(5) == True
/// strictly_before(6) |> starts_before(5) == True
/// strictly_before(7) |> starts_before(5) == True
/// between(1, 4) |> starts_before(5) == True
/// between(2, 5) |> starts_before(5) == True
/// between(3, 6) |> starts_before(5) == True
/// between(4, 7) |> starts_before(5) == True
/// strictly_between(2, 5) |> starts_before(5) == True
/// strictly_between(3, 6) |> starts_before(5) == True
///
/// // negative cases:
/// after(6) |> starts_before(5) == False
/// strictly_after(5) |> starts_before(5) == False
/// between(6, 9) |> starts_before(5) == False
/// strictly_between(5, 8) |> starts_before(5) == False
///
/// // interval starts AT deadline:
/// after(5) |> starts_before(5) == False
/// strictly_after(4) |> starts_before(5) == False
/// between(5, 8) |> starts_before(5) == False
/// strictly_between(4, 7) |> starts_before(5) == False
/// ```
pub fn starts_before(
  some_interval: Interval<PosixTime>,
  deadline: PosixTime,
) -> Bool {
  let start = start_of(some_interval)
  when start.bound_type is {
    Finite(time) -> {
      let time =
        if start.is_inclusive {
          time
        } else {
          time + 1
        }
      time < deadline
    }
    PositiveInfinity -> False
    NegativeInfinity -> True
  }
}

/// Tells whether `some_interval` starts **before-or-at** the specified `PosixTime`
/// ```
/// after(4) |> starts_before_or_at(5) == True
/// strictly_after(3) |> starts_before_or_at(5) == True
/// before(4) |> starts_before_or_at(5) == True
/// before(5) |> starts_before_or_at(5) == True
/// before(6) |> starts_before_or_at(5) == True
/// strictly_before(5) |> starts_before_or_at(5) == True
/// strictly_before(6) |> starts_before_or_at(5) == True
/// strictly_before(7) |> starts_before_or_at(5) == True
/// between(1, 4) |> starts_before_or_at(5) == True
/// between(2, 5) |> starts_before_or_at(5) == True
/// between(3, 6) |> starts_before_or_at(5) == True
/// between(4, 7) |> starts_before_or_at(5) == True
/// strictly_between(2, 5) |> starts_before_or_at(5) == True
/// strictly_between(3, 6) |> starts_before_or_at(5) == True
///
/// // interval starts AT deadline:
/// after(5) |> starts_before_or_at(5) == True
/// strictly_after(4) |> starts_before_or_at(5) == True
/// between(5, 8) |> starts_before_or_at(5) == True
/// strictly_between(4, 7) |> starts_before_or_at(5) == True
///
/// // negative cases:
/// after(6) |> starts_before_or_at(5) == False
/// strictly_after(5) |> starts_before_or_at(5) == False
/// between(6, 9) |> starts_before_or_at(5) == False
/// strictly_between(5, 8) |> starts_before_or_at(5) == False
/// ```
pub fn starts_before_or_at(
  some_interval: Interval<PosixTime>,
  deadline: PosixTime,
) -> Bool {
  let start = start_of(some_interval)
  when start.bound_type is {
    Finite(time) -> {
      let time =
        if start.is_inclusive {
          time
        } else {
          time + 1
        }
      time <= deadline
    }
    PositiveInfinity -> False
    NegativeInfinity -> True
  }
}

/// Tells whether `some_interval` ends **after** the specified `PosixTime`
/// ```
/// after(4) |> ends_after(5) == True
/// after(5) |> ends_after(5) == True
/// after(6) |> ends_after(5) == True
/// strictly_after(3) |> ends_after(5) == True
/// strictly_after(4) |> ends_after(5) == True
/// strictly_after(5) |> ends_after(5) == True
/// before(6) |> ends_after(5) == True
/// strictly_before(7) |> ends_after(5) == True
/// between(3, 6) |> ends_after(5) == True
/// between(4, 7) |> ends_after(5) == True
/// between(5, 8) |> ends_after(5) == True
/// between(6, 9) |> ends_after(5) == True
/// strictly_between(4, 7) |> ends_after(5) == True
/// strictly_between(5, 8) |> ends_after(5) == True
///
/// // negative cases:
/// before(4) |> ends_after(5) == False
/// strictly_before(5) |> ends_after(5) == False
/// between(1, 4) |> ends_after(5) == False
/// strictly_between(2, 5) |> ends_after(5) == False
///
/// // interval ends AT deadline:
/// before(5) |> ends_after(5) == False
/// strictly_before(6) |> ends_after(5) == False
/// between(2, 5) |> ends_after(5) == False
/// strictly_between(3, 6) |> ends_after(5) == False
/// ```
pub fn ends_after(
  some_interval: Interval<PosixTime>,
  deadline: PosixTime,
) -> Bool {
  let end = end_of(some_interval)
  when end.bound_type is {
    Finite(time) -> {
      let time =
        if end.is_inclusive {
          time
        } else {
          time - 1
        }
      time > deadline
    }
    PositiveInfinity -> True
    NegativeInfinity -> False
  }
}

/// Tells whether `some_interval` ends **after-or-at** the specified `PosixTime`
/// ```
/// after(4) |> ends_after_or_at(5) == True
/// after(5) |> ends_after_or_at(5) == True
/// after(6) |> ends_after_or_at(5) == True
/// strictly_after(3) |> ends_after_or_at(5) == True
/// strictly_after(4) |> ends_after_or_at(5) == True
/// strictly_after(5) |> ends_after_or_at(5) == True
/// before(6) |> ends_after_or_at(5) == True
/// strictly_before(7) |> ends_after_or_at(5) == True
/// between(3, 6) |> ends_after_or_at(5) == True
/// between(4, 7) |> ends_after_or_at(5) == True
/// between(5, 8) |> ends_after_or_at(5) == True
/// between(6, 9) |> ends_after_or_at(5) == True
/// strictly_between(4, 7) |> ends_after_or_at(5) == True
/// strictly_between(5, 8) |> ends_after_or_at(5) == True
///
/// // interval ends AT deadline:
/// before(5) |> ends_after_or_at(5) == True
/// strictly_before(6) |> ends_after_or_at(5) == True
/// between(2, 5) |> ends_after_or_at(5) == True
/// strictly_between(3, 6) |> ends_after_or_at(5) == True
///
/// // negative cases:
/// before(4) |> ends_after_or_at(5) == False
/// strictly_before(5) |> ends_after_or_at(5) == False
/// between(1, 4) |> ends_after_or_at(5) == False
/// strictly_between(2, 5) |> ends_after_or_at(5) == False
/// ```
pub fn ends_after_or_at(
  some_interval: Interval<PosixTime>,
  deadline: PosixTime,
) -> Bool {
  let end = end_of(some_interval)
  when end.bound_type is {
    Finite(time) -> {
      let time =
        if end.is_inclusive {
          time
        } else {
          time - 1
        }
      time >= deadline
    }
    PositiveInfinity -> True
    NegativeInfinity -> False
  }
}

/// Tells whether `some_interval` ends **before** the specified `PosixTime`
/// ```
/// before(4) |> ends_before(5) == True
/// strictly_before(5) |> ends_before(5) == True
/// between(1, 4) |> ends_before(5) == True
/// strictly_between(2, 5) |> ends_before(5) == True
/// 
/// // negative cases:
/// after(4) |> ends_before(5) == False
/// after(5) |> ends_before(5) == False
/// after(6) |> ends_before(5) == False
/// strictly_after(3) |> ends_before(5) == False
/// strictly_after(4) |> ends_before(5) == False
/// strictly_after(5) |> ends_before(5) == False
/// before(6) |> ends_before(5) == False
/// strictly_before(7) |> ends_before(5) == False
/// between(3, 6) |> ends_before(5) == False
/// between(4, 7) |> ends_before(5) == False
/// between(5, 8) |> ends_before(5) == False
/// between(6, 9) |> ends_before(5) == False
/// strictly_between(4, 7) |> ends_before(5) == False
/// strictly_between(5, 8) |> ends_before(5) == False
/// 
/// // interval ends AT deadline:
/// before(5) |> ends_before(5) == False
/// strictly_before(6) |> ends_before(5) == False
/// between(2, 5) |> ends_before(5) == False
/// strictly_between(3, 6) |> ends_before(5) == False
/// ```
pub fn ends_before(
  some_interval: Interval<PosixTime>,
  deadline: PosixTime,
) -> Bool {
  let end = end_of(some_interval)
  when end.bound_type is {
    Finite(time) -> {
      let time =
        if end.is_inclusive {
          time
        } else {
          time - 1
        }
      time < deadline
    }
    PositiveInfinity -> False
    NegativeInfinity -> True
  }
}

/// Tells whether `some_interval` ends **before-or-at** the specified `PosixTime`
/// ```
/// before(4) |> ends_before_or_at(5) == True
/// strictly_before(5) |> ends_before_or_at(5) == True
/// between(1, 4) |> ends_before_or_at(5) == True
/// strictly_between(2, 5) |> ends_before_or_at(5) == True
/// 
/// // interval ends AT deadline:
/// before(5) |> ends_before_or_at(5) == True
/// strictly_before(6) |> ends_before_or_at(5) == True
/// between(2, 5) |> ends_before_or_at(5) == True
/// strictly_between(3, 6) |> ends_before_or_at(5) == True
/// 
/// // negative cases:
/// after(4) |> ends_before_or_at(5) == False
/// after(5) |> ends_before_or_at(5) == False
/// after(6) |> ends_before_or_at(5) == False
/// strictly_after(3) |> ends_before_or_at(5) == False
/// strictly_after(4) |> ends_before_or_at(5) == False
/// strictly_after(5) |> ends_before_or_at(5) == False
/// before(6) |> ends_before_or_at(5) == False
/// strictly_before(7) |> ends_before_or_at(5) == False
/// between(3, 6) |> ends_before_or_at(5) == False
/// between(4, 7) |> ends_before_or_at(5) == False
/// between(5, 8) |> ends_before_or_at(5) == False
/// between(6, 9) |> ends_before_or_at(5) == False
/// strictly_between(4, 7) |> ends_before_or_at(5) == False
/// strictly_between(5, 8) |> ends_before_or_at(5) == False
/// ```
pub fn ends_before_or_at(
  some_interval: Interval<PosixTime>,
  deadline: PosixTime,
) -> Bool {
  let end = end_of(some_interval)
  when end.bound_type is {
    Finite(time) -> {
      let time =
        if end.is_inclusive {
          time
        } else {
          time - 1
        }
      time <= deadline
    }
    PositiveInfinity -> False
    NegativeInfinity -> True
  }
}
