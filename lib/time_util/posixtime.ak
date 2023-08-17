//// A utility module to help comparing some intervals to specified deadlines.
//// The code reuses `time_util/interval` module, so there's only one generic
//// internal function to handle all logic variations at the cost of memory and
//// CPU usage.
////
//// Use `time_util/cheap/posixtime` instead for cheaper memory and CPU usage.
////
//// ```
//// time_util/posixtime:
//// ┍━ test_time_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem: 3009471, cpu: 1165866267] interval_starts_after_deadline
//// │ PASS [mem: 3004667, cpu: 1164375883] interval_starts_after_or_at_deadline
//// │ PASS [mem: 2984261, cpu: 1159264707] interval_starts_before_deadline
//// │ PASS [mem: 2979457, cpu: 1157774323] interval_starts_before_or_at_deadline
//// │ PASS [mem: 2972465, cpu: 1154226981] interval_ends_after_deadline
//// │ PASS [mem: 2967661, cpu: 1152736597] interval_ends_after_or_at_deadline
//// │ PASS [mem: 2997675, cpu: 1160828541] interval_ends_before_deadline
//// │ PASS [mem: 2992871, cpu: 1159338157] interval_ends_before_or_at_deadline
//// ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 8 tests | 8 passed | 0 failed
//// 
//// time_util/cheap/posixtime:
//// ┍━ test_cheap_posixtime_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem: 1122861, cpu:  427903431] interval_starts_after_deadline
//// │ PASS [mem: 1118057, cpu:  426413047] interval_starts_after_or_at_deadline
//// │ PASS [mem: 1110851, cpu:  424337871] interval_starts_before_deadline
//// │ PASS [mem: 1106047, cpu:  422847487] interval_starts_before_or_at_deadline
//// │ PASS [mem: 1110851, cpu:  424337871] interval_ends_after_deadline
//// │ PASS [mem: 1106047, cpu:  422847487] interval_ends_after_or_at_deadline
//// │ PASS [mem: 1122861, cpu:  427903431] interval_ends_before_deadline
//// │ PASS [mem: 1118057, cpu:  426413047] interval_ends_before_or_at_deadline
//// ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 8 tests | 8 passed | 0 failed
//// ```

use aiken/interval.{Interval, between} as aiken_interval
use aiken/time.{PosixTime} as aiken_time
use time_util/interval

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
  some_interval |> interval.starts_after(between(deadline, deadline))
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
  some_interval |> interval.starts_after_or_at(between(deadline, deadline))
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
  some_interval |> interval.starts_before(between(deadline, deadline))
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
  some_interval |> interval.starts_before_or_at(between(deadline, deadline))
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
  some_interval |> interval.ends_after(between(deadline, deadline))
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
  some_interval |> interval.ends_after_or_at(between(deadline, deadline))
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
  some_interval |> interval.ends_before(between(deadline, deadline))
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
  some_interval |> interval.ends_before_or_at(between(deadline, deadline))
}
