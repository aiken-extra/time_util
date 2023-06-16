//// A slightly cheaper version of `time_util/interval` in terms of memory and CPU usage.
////
//// ```
//// time_util/cheap/interval:
//// ┍━ test_cheap_interval_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem: 2642516, cpu: 1030016700] interval_is_after_deadline
//// │ PASS [mem: 2637712, cpu: 1028526316] interval_is_after_or_at_deadline
//// │ PASS [mem: 2630720, cpu: 1024978974] interval_is_before_deadline
//// │ PASS [mem: 2625916, cpu: 1023488590] interval_is_before_or_at_deadline
//// ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4 tests | 4 passed | 0 failed
//// 
//// time_util/interval:
//// ┍━ test_time_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem: 2803844, cpu: 1095244947] interval_is_after_deadline
//// │ PASS [mem: 2799040, cpu: 1093754563] interval_is_after_or_at_deadline
//// │ PASS [mem: 2792048, cpu: 1090207221] interval_is_before_deadline
//// │ PASS [mem: 2787244, cpu: 1088716837] interval_is_before_or_at_deadline
//// ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4 tests | 4 passed | 0 failed
//// ```

use aiken/interval.{
  Finite, Interval, IntervalBound, NegativeInfinity, PositiveInfinity, max, min,
}
use aiken/time.{PosixTime}

/// Tells whether an interval is **after** another interval.
/// ```
/// let an_interval = between(0, 5)
/// 
/// after(6) |> is_after(an_interval) == True
/// between(6, 9) |> is_after(an_interval) == True
/// strictly_after(5) |> is_after(an_interval) == True
/// strictly_between(5, 8) |> is_after(an_interval) == True
/// 
/// // negative cases:
/// after(4) |> is_after(an_interval) == False
/// strictly_after(3) |> is_after(an_interval) == False
/// before(4) |> is_after(an_interval) == False
/// before(5) |> is_after(an_interval) == False
/// before(6) |> is_after(an_interval) == False
/// strictly_before(5) |> is_after(an_interval) == False
/// strictly_before(6) |> is_after(an_interval) == False
/// strictly_before(7) |> is_after(an_interval) == False
/// between(1, 4) |> is_after(an_interval) == False
/// between(2, 5) |> is_after(an_interval) == False
/// between(3, 6) |> is_after(an_interval) == False
/// between(4, 7) |> is_after(an_interval) == False
/// strictly_between(2, 5) |> is_after(an_interval) == False
/// strictly_between(3, 6) |> is_after(an_interval) == False
/// 
/// // interval starts AT deadline:
/// after(5) |> is_after(an_interval) == False
/// between(5, 8) |> is_after(an_interval) == False
/// strictly_after(4) |> is_after(an_interval) == False
/// strictly_between(4, 7) |> is_after(an_interval) == False
/// ```
pub fn is_after(
  some_interval: Interval<PosixTime>,
  other_interval: Interval<PosixTime>,
) -> Bool {
  let l_bound = start_of(some_interval)
  let r_bound = end_of(other_interval)
  when (l_bound.bound_type, r_bound.bound_type) is {
    (Finite(l), Finite(r)) -> {
      let l =
        if l_bound.is_inclusive {
          l
        } else {
          l + 1
        }
      let r =
        if r_bound.is_inclusive {
          r
        } else {
          r - 1
        }
      l > r
    }
    (PositiveInfinity, _) -> True
    (NegativeInfinity, _) -> False
    (_, PositiveInfinity) -> False
    (_, NegativeInfinity) -> True
  }
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
  other_interval: Interval<PosixTime>,
) -> Bool {
  let l_bound = start_of(some_interval)
  let r_bound = end_of(other_interval)
  when (l_bound.bound_type, r_bound.bound_type) is {
    (Finite(l), Finite(r)) -> {
      let l =
        if l_bound.is_inclusive {
          l
        } else {
          l + 1
        }
      let r =
        if r_bound.is_inclusive {
          r
        } else {
          r - 1
        }
      l >= r
    }
    (PositiveInfinity, _) -> True
    (NegativeInfinity, _) -> False
    (_, PositiveInfinity) -> False
    (_, NegativeInfinity) -> True
  }
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
  other_interval: Interval<PosixTime>,
) -> Bool {
  let l_bound = end_of(some_interval)
  let r_bound = start_of(other_interval)
  when (l_bound.bound_type, r_bound.bound_type) is {
    (Finite(l), Finite(r)) -> {
      let l =
        if l_bound.is_inclusive {
          l
        } else {
          l - 1
        }
      let r =
        if r_bound.is_inclusive {
          r
        } else {
          r + 1
        }
      l < r
    }
    (PositiveInfinity, _) -> False
    (NegativeInfinity, _) -> True
    (_, PositiveInfinity) -> True
    (_, NegativeInfinity) -> False
  }
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
  other_interval: Interval<PosixTime>,
) -> Bool {
  let l_bound = end_of(some_interval)
  let r_bound = start_of(other_interval)
  when (l_bound.bound_type, r_bound.bound_type) is {
    (Finite(l), Finite(r)) -> {
      let l =
        if l_bound.is_inclusive {
          l
        } else {
          l - 1
        }
      let r =
        if r_bound.is_inclusive {
          r
        } else {
          r + 1
        }
      l <= r
    }
    (PositiveInfinity, _) -> False
    (NegativeInfinity, _) -> True
    (_, PositiveInfinity) -> True
    (_, NegativeInfinity) -> False
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
