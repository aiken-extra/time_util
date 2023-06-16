//// A utility module to help comparing some intervals to specified deadlines.
//// The code reuses `time_util/interval` module, so there's only one generic
//// internal function to handle all logic variations at the cost of memory and
//// CPU usage.
////
//// Use `time_util/cheap/posixtime` instead for cheaper memory and CPU usage.
////
//// ```
//// time_util/posixtime:
//// ┍━ test_time_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem: 2803844, cpu: 1095244947] interval_is_after_deadline
//// │ PASS [mem: 2799040, cpu: 1093754563] interval_is_after_or_at_deadline
//// │ PASS [mem: 2792048, cpu: 1090207221] interval_is_before_deadline
//// │ PASS [mem: 2787244, cpu: 1088716837] interval_is_before_or_at_deadline
//// ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4 tests | 4 passed | 0 failed
//// 
//// time_util/cheap/posixtime:
//// ┍━ test_cheap_posixtime_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem: 1209662, cpu:  463148119] interval_is_after_deadline
//// │ PASS [mem: 1204858, cpu:  461657735] interval_is_after_or_at_deadline
//// │ PASS [mem: 1209662, cpu:  463148119] interval_is_before_deadline
//// │ PASS [mem: 1204858, cpu:  461657735] interval_is_before_or_at_deadline
//// ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4 tests | 4 passed | 0 failed
//// ```

use aiken/interval.{Interval, IntervalBound, between} as aiken_interval
use aiken/time.{PosixTime} as aiken_time
use time_util/interval

/// Tells whether `some_interval` is **after** the specified `PosixTime`
/// ```
/// after(6) |> is_after(5) == True
/// between(6, 9) |> is_after(5) == True
/// strictly_after(5) |> is_after(5) == True
/// strictly_between(5, 8) |> is_after(5) == True
/// 
/// // negative cases:
/// after(4) |> is_after(5) == False
/// strictly_after(3) |> is_after(5) == False
/// before(4) |> is_after(5) == False
/// before(5) |> is_after(5) == False
/// before(6) |> is_after(5) == False
/// strictly_before(5) |> is_after(5) == False
/// strictly_before(6) |> is_after(5) == False
/// strictly_before(7) |> is_after(5) == False
/// between(1, 4) |> is_after(5) == False
/// between(2, 5) |> is_after(5) == False
/// between(3, 6) |> is_after(5) == False
/// between(4, 7) |> is_after(5) == False
/// strictly_between(2, 5) |> is_after(5) == False
/// strictly_between(3, 6) |> is_after(5) == False
/// 
/// // interval starts AT deadline:
/// after(5) |> is_after(5) == False
/// between(5, 8) |> is_after(5) == False
/// strictly_after(4) |> is_after(5) == False
/// strictly_between(4, 7) |> is_after(5) == False
/// ```
pub fn is_after(some_interval: Interval<PosixTime>, deadline: PosixTime) -> Bool {
  some_interval |> interval.is_after(between(deadline, deadline))
}

/// Tells whether `some_interval` is **after-or-at** the specified `PosixTime`
/// ```
/// after(6) |> is_after_or_at(5) == True
/// strictly_after(5) |> is_after_or_at(5) == True
/// between(6, 9) |> is_after_or_at(5) == True
/// strictly_between(5, 8) |> is_after_or_at(5) == True
/// 
/// // interval starts AT deadline:
/// after(5) |> is_after_or_at(5) == True
/// strictly_after(4) |> is_after_or_at(5) == True
/// between(5, 8) |> is_after_or_at(5) == True
/// strictly_between(4, 7) |> is_after_or_at(5) == True
/// 
/// // negative cases:
/// after(4) |> is_after_or_at(5) == False
/// strictly_after(3) |> is_after_or_at(5) == False
/// before(4) |> is_after_or_at(5) == False
/// before(5) |> is_after_or_at(5) == False
/// before(6) |> is_after_or_at(5) == False
/// strictly_before(5) |> is_after_or_at(5) == False
/// strictly_before(6) |> is_after_or_at(5) == False
/// strictly_before(7) |> is_after_or_at(5) == False
/// between(1, 4) |> is_after_or_at(5) == False
/// between(2, 5) |> is_after_or_at(5) == False
/// between(3, 6) |> is_after_or_at(5) == False
/// between(4, 7) |> is_after_or_at(5) == False
/// strictly_between(2, 5) |> is_after_or_at(5) == False
/// strictly_between(3, 6) |> is_after_or_at(5) == False
/// ```
pub fn is_after_or_at(
  some_interval: Interval<PosixTime>,
  deadline: PosixTime,
) -> Bool {
  some_interval |> interval.is_after_or_at(between(deadline, deadline))
}

/// Tells whether `some_interval` is **before** the specified `PosixTime`
/// ```
/// before(4) |> is_before(5) == True
/// strictly_before(5) |> is_before(5) == True
/// between(1, 4) |> is_before(5) == True
/// strictly_between(2, 5) |> is_before(5) == True
/// 
/// // negative cases:
/// after(4) |> is_before(5) == False
/// after(5) |> is_before(5) == False
/// after(6) |> is_before(5) == False
/// strictly_after(3) |> is_before(5) == False
/// strictly_after(4) |> is_before(5) == False
/// strictly_after(5) |> is_before(5) == False
/// before(6) |> is_before(5) == False
/// strictly_before(7) |> is_before(5) == False
/// between(3, 6) |> is_before(5) == False
/// between(4, 7) |> is_before(5) == False
/// between(5, 8) |> is_before(5) == False
/// between(6, 9) |> is_before(5) == False
/// strictly_between(4, 7) |> is_before(5) == False
/// strictly_between(5, 8) |> is_before(5) == False
/// 
/// // interval ends AT deadline:
/// before(5) |> is_before(5) == False
/// strictly_before(6) |> is_before(5) == False
/// between(2, 5) |> is_before(5) == False
/// strictly_between(3, 6) |> is_before(5) == False
/// ```
pub fn is_before(
  some_interval: Interval<PosixTime>,
  deadline: PosixTime,
) -> Bool {
  some_interval |> interval.is_before(between(deadline, deadline))
}

/// Tells whether `some_interval` is **before-or-at** the specified `PosixTime`
/// ```
/// before(4) |> is_before_or_at(5) == True
/// strictly_before(5) |> is_before_or_at(5) == True
/// between(1, 4) |> is_before_or_at(5) == True
/// strictly_between(2, 5) |> is_before_or_at(5) == True
/// 
/// // interval ends AT deadline:
/// before(5) |> is_before_or_at(5) == True
/// strictly_before(6) |> is_before_or_at(5) == True
/// between(2, 5) |> is_before_or_at(5) == True
/// strictly_between(3, 6) |> is_before_or_at(5) == True
/// 
/// // negative cases:
/// after(4) |> is_before_or_at(5) == False
/// after(5) |> is_before_or_at(5) == False
/// after(6) |> is_before_or_at(5) == False
/// strictly_after(3) |> is_before_or_at(5) == False
/// strictly_after(4) |> is_before_or_at(5) == False
/// strictly_after(5) |> is_before_or_at(5) == False
/// before(6) |> is_before_or_at(5) == False
/// strictly_before(7) |> is_before_or_at(5) == False
/// between(3, 6) |> is_before_or_at(5) == False
/// between(4, 7) |> is_before_or_at(5) == False
/// between(5, 8) |> is_before_or_at(5) == False
/// between(6, 9) |> is_before_or_at(5) == False
/// strictly_between(4, 7) |> is_before_or_at(5) == False
/// strictly_between(5, 8) |> is_before_or_at(5) == False
/// ```
pub fn is_before_or_at(
  some_interval: Interval<PosixTime>,
  deadline: PosixTime,
) -> Bool {
  some_interval |> interval.is_before_or_at(between(deadline, deadline))
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
  interval.start_of(interval)
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
  interval.end_of(interval)
}
