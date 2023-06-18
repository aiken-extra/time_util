//// A cheaper version of `time_util/posixtime` in terms of memory and CPU usage.
////
//// ```
//// time_util/cheap/posixtime:
//// ┍━ test_cheap_posixtime_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem: 1209662, cpu:  463148119] interval_starts_after_deadline
//// │ PASS [mem: 1204858, cpu:  461657735] interval_starts_after_or_at_deadline
//// │ PASS [mem: 1197652, cpu:  459582559] interval_starts_before_deadline
//// │ PASS [mem: 1192848, cpu:  458092175] interval_starts_before_or_at_deadline
//// │ PASS [mem: 1197652, cpu:  459582559] interval_ends_after_deadline
//// │ PASS [mem: 1192848, cpu:  458092175] interval_ends_after_or_at_deadline
//// │ PASS [mem: 1209662, cpu:  463148119] interval_ends_before_deadline
//// │ PASS [mem: 1204858, cpu:  461657735] interval_ends_before_or_at_deadline
//// ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 8 tests | 8 passed | 0 failed
//// 
//// time_util/posixtime:
//// ┍━ test_time_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem: 2803844, cpu: 1095244947] interval_starts_after_deadline
//// │ PASS [mem: 2799040, cpu: 1093754563] interval_starts_after_or_at_deadline
//// │ PASS [mem: 2778634, cpu: 1088643387] interval_starts_before_deadline
//// │ PASS [mem: 2773830, cpu: 1087153003] interval_starts_before_or_at_deadline
//// │ PASS [mem: 2766838, cpu: 1083605661] interval_ends_after_deadline
//// │ PASS [mem: 2762034, cpu: 1082115277] interval_ends_after_or_at_deadline
//// │ PASS [mem: 2792048, cpu: 1090207221] interval_ends_before_deadline
//// │ PASS [mem: 2787244, cpu: 1088716837] interval_ends_before_or_at_deadline
//// ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 8 tests | 8 passed | 0 failed
//// ```

use aiken/interval.{
  Finite, Interval, IntervalBound, NegativeInfinity, PositiveInfinity, max, min,
}
use aiken/time.{PosixTime}

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
