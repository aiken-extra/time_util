//// A slightly cheaper version of `time_util/interval` in terms of memory and CPU usage.
////
//// ```
//// time_util/cheap/interval:
//// ┍━ test_cheap_interval_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem: 2642516, cpu: 1030016700] interval_starts_after_deadline
//// │ PASS [mem: 2637712, cpu: 1028526316] interval_starts_after_or_at_deadline
//// │ PASS [mem: 2617306, cpu: 1023415140] interval_starts_before_deadline
//// │ PASS [mem: 2612502, cpu: 1021924756] interval_starts_before_or_at_deadline
//// │ PASS [mem: 2605510, cpu: 1018377414] interval_ends_after_deadline
//// │ PASS [mem: 2600706, cpu: 1016887030] interval_ends_after_or_at_deadline
//// │ PASS [mem: 2630720, cpu: 1024978974] interval_ends_before_deadline
//// │ PASS [mem: 2625916, cpu: 1023488590] interval_ends_before_or_at_deadline
//// ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 8 tests | 8 passed | 0 failed
//// 
//// time_util/interval:
//// ┍━ test_time_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem: 3061280, cpu: 1188413503] interval_starts_after_deadline
//// │ PASS [mem: 3056476, cpu: 1186923119] interval_starts_after_or_at_deadline
//// │ PASS [mem: 3036070, cpu: 1181811943] interval_starts_before_deadline
//// │ PASS [mem: 3031266, cpu: 1180321559] interval_starts_before_or_at_deadline
//// │ PASS [mem: 3036070, cpu: 1181811943] interval_ends_after_deadline
//// │ PASS [mem: 3031266, cpu: 1180321559] interval_ends_after_or_at_deadline
//// │ PASS [mem: 3061280, cpu: 1188413503] interval_ends_before_deadline
//// │ PASS [mem: 3056476, cpu: 1186923119] interval_ends_before_or_at_deadline
//// ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 8 tests | 8 passed | 0 failed
//// ```

use aiken/interval.{Finite, Interval, NegativeInfinity, PositiveInfinity}
use aiken/time.{PosixTime}
use time_util/bound.{end_of, start_of}

/// Tells whether an interval is **after** another interval.
/// This function is an alias for `starts_after`.
pub fn is_after(
  some_interval: Interval<PosixTime>,
  other_interval: Interval<PosixTime>,
) -> Bool {
  some_interval |> starts_after(other_interval)
}

/// Tells whether `some_interval` is **after-or-at** another interval.
/// This function is an alias for `starts_after_or_at`.
pub fn is_after_or_at(
  some_interval: Interval<PosixTime>,
  other_interval: Interval<PosixTime>,
) -> Bool {
  some_interval |> starts_after_or_at(other_interval)
}

/// Tells whether `some_interval` is **before** another interval.
/// This function is an alias for `ends_before`.
pub fn is_before(
  some_interval: Interval<PosixTime>,
  other_interval: Interval<PosixTime>,
) -> Bool {
  some_interval |> ends_before(other_interval)
}

/// Tells whether `some_interval` is **before-or-at** another interval.
/// This function is an alias for `ends_before_or_at`.
pub fn is_before_or_at(
  some_interval: Interval<PosixTime>,
  other_interval: Interval<PosixTime>,
) -> Bool {
  some_interval |> ends_before_or_at(other_interval)
}

/// Tells whether an interval starts **after** another interval.
/// ```
/// let an_interval = between(0, 5)
/// 
/// after(6) |> starts_after(an_interval) == True
/// between(6, 9) |> starts_after(an_interval) == True
/// strictly_after(5) |> starts_after(an_interval) == True
/// strictly_between(5, 8) |> starts_after(an_interval) == True
/// 
/// // negative cases:
/// after(4) |> starts_after(an_interval) == False
/// strictly_after(3) |> starts_after(an_interval) == False
/// before(4) |> starts_after(an_interval) == False
/// before(5) |> starts_after(an_interval) == False
/// before(6) |> starts_after(an_interval) == False
/// strictly_before(5) |> starts_after(an_interval) == False
/// strictly_before(6) |> starts_after(an_interval) == False
/// strictly_before(7) |> starts_after(an_interval) == False
/// between(1, 4) |> starts_after(an_interval) == False
/// between(2, 5) |> starts_after(an_interval) == False
/// between(3, 6) |> starts_after(an_interval) == False
/// between(4, 7) |> starts_after(an_interval) == False
/// strictly_between(2, 5) |> starts_after(an_interval) == False
/// strictly_between(3, 6) |> starts_after(an_interval) == False
/// 
/// // interval starts AT another interval:
/// after(5) |> starts_after(an_interval) == False
/// between(5, 8) |> starts_after(an_interval) == False
/// strictly_after(4) |> starts_after(an_interval) == False
/// strictly_between(4, 7) |> starts_after(an_interval) == False
/// ```
pub fn starts_after(
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

// <s>DRY - Don't Repeat Yourself</s>
// it is cheaper to put the logics of `start/end_bound_type_of` here;
// proven by the tests result

/// Tells whether `some_interval` starts **after-or-at** another interval.
/// ```
/// let an_interval = between(0, 5)
/// 
/// after(6) |> starts_after_or_at(an_interval) == True
/// strictly_after(5) |> starts_after_or_at(an_interval) == True
/// between(6, 9) |> starts_after_or_at(an_interval) == True
/// strictly_between(5, 8) |> starts_after_or_at(an_interval) == True
/// 
/// // interval starts AT another interval:
/// after(5) |> starts_after_or_at(an_interval) == True
/// strictly_after(4) |> starts_after_or_at(an_interval) == True
/// between(5, 8) |> starts_after_or_at(an_interval) == True
/// strictly_between(4, 7) |> starts_after_or_at(an_interval) == True
/// 
/// // negative cases:
/// after(4) |> starts_after_or_at(an_interval) == False
/// strictly_after(3) |> starts_after_or_at(an_interval) == False
/// before(4) |> starts_after_or_at(an_interval) == False
/// before(5) |> starts_after_or_at(an_interval) == False
/// before(6) |> starts_after_or_at(an_interval) == False
/// strictly_before(5) |> starts_after_or_at(an_interval) == False
/// strictly_before(6) |> starts_after_or_at(an_interval) == False
/// strictly_before(7) |> starts_after_or_at(an_interval) == False
/// between(1, 4) |> starts_after_or_at(an_interval) == False
/// between(2, 5) |> starts_after_or_at(an_interval) == False
/// between(3, 6) |> starts_after_or_at(an_interval) == False
/// between(4, 7) |> starts_after_or_at(an_interval) == False
/// strictly_between(2, 5) |> starts_after_or_at(an_interval) == False
/// strictly_between(3, 6) |> starts_after_or_at(an_interval) == False
/// ```
pub fn starts_after_or_at(
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

/// Tells whether `some_interval` starts **before** another interval.
/// ```
/// let an_interval = between(5, 10)
/// 
/// after(4) |> starts_before(an_interval) == True
/// strictly_after(3) |> starts_before(an_interval) == True
/// before(4) |> starts_before(an_interval) == True
/// before(5) |> starts_before(an_interval) == True
/// before(6) |> starts_before(an_interval) == True
/// strictly_before(5) |> starts_before(an_interval) == True
/// strictly_before(6) |> starts_before(an_interval) == True
/// strictly_before(7) |> starts_before(an_interval) == True
/// between(1, 4) |> starts_before(an_interval) == True
/// between(2, 5) |> starts_before(an_interval) == True
/// between(3, 6) |> starts_before(an_interval) == True
/// between(4, 7) |> starts_before(an_interval) == True
/// strictly_between(2, 5) |> starts_before(an_interval) == True
/// strictly_between(3, 6) |> starts_before(an_interval) == True
/// 
/// // negative cases:
/// after(6) |> starts_before(an_interval) == False
/// strictly_after(5) |> starts_before(an_interval) == False
/// between(6, 9) |> starts_before(an_interval) == False
/// strictly_between(5, 8) |> starts_before(an_interval) == False
/// 
/// // interval starts AT another interval:
/// after(5) |> starts_before(an_interval) == False
/// strictly_after(4) |> starts_before(an_interval) == False
/// between(5, 8) |> starts_before(an_interval) == False
/// strictly_between(4, 7) |> starts_before(an_interval) == False
/// ```
pub fn starts_before(
  some_interval: Interval<PosixTime>,
  other_interval: Interval<PosixTime>,
) -> Bool {
  let l_bound = start_of(some_interval)
  let r_bound = start_of(other_interval)
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

/// Tells whether `some_interval` starts **before-or-at** another interval.
/// ```
/// let an_interval = between(5, 10)
/// 
/// after(4) |> starts_before_or_at(an_interval) == True
/// strictly_after(3) |> starts_before_or_at(an_interval) == True
/// before(4) |> starts_before_or_at(an_interval) == True
/// before(5) |> starts_before_or_at(an_interval) == True
/// before(6) |> starts_before_or_at(an_interval) == True
/// strictly_before(5) |> starts_before_or_at(an_interval) == True
/// strictly_before(6) |> starts_before_or_at(an_interval) == True
/// strictly_before(7) |> starts_before_or_at(an_interval) == True
/// between(1, 4) |> starts_before_or_at(an_interval) == True
/// between(2, 5) |> starts_before_or_at(an_interval) == True
/// between(3, 6) |> starts_before_or_at(an_interval) == True
/// between(4, 7) |> starts_before_or_at(an_interval) == True
/// strictly_between(2, 5) |> starts_before_or_at(an_interval) == True
/// strictly_between(3, 6) |> starts_before_or_at(an_interval) == True
/// 
/// // interval starts AT another interval:
/// after(5) |> starts_before_or_at(an_interval) == True
/// strictly_after(4) |> starts_before_or_at(an_interval) == True
/// between(5, 8) |> starts_before_or_at(an_interval) == True
/// strictly_between(4, 7) |> starts_before_or_at(an_interval) == True
/// 
/// // negative cases:
/// after(6) |> starts_before_or_at(an_interval) == False
/// strictly_after(5) |> starts_before_or_at(an_interval) == False
/// between(6, 9) |> starts_before_or_at(an_interval) == False
/// strictly_between(5, 8) |> starts_before_or_at(an_interval) == False
/// ```
pub fn starts_before_or_at(
  some_interval: Interval<PosixTime>,
  other_interval: Interval<PosixTime>,
) -> Bool {
  let l_bound = start_of(some_interval)
  let r_bound = start_of(other_interval)
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

/// Tells whether `some_interval` ends **after** another interval.
/// ```
/// let an_interval = between(0, 5)
/// 
/// after(4) |> ends_after(an_interval) == True
/// after(5) |> ends_after(an_interval) == True
/// after(6) |> ends_after(an_interval) == True
/// strictly_after(3) |> ends_after(an_interval) == True
/// strictly_after(4) |> ends_after(an_interval) == True
/// strictly_after(5) |> ends_after(an_interval) == True
/// before(6) |> ends_after(an_interval) == True
/// strictly_before(7) |> ends_after(an_interval) == True
/// between(3, 6) |> ends_after(an_interval) == True
/// between(4, 7) |> ends_after(an_interval) == True
/// between(5, 8) |> ends_after(an_interval) == True
/// between(6, 9) |> ends_after(an_interval) == True
/// strictly_between(4, 7) |> ends_after(an_interval) == True
/// strictly_between(5, 8) |> ends_after(an_interval) == True
/// 
/// // negative cases:
/// before(4) |> ends_after(an_interval) == False
/// strictly_before(5) |> ends_after(an_interval) == False
/// between(1, 4) |> ends_after(an_interval) == False
/// strictly_between(2, 5) |> ends_after(an_interval) == False
/// 
/// // interval ends AT another interval:
/// before(5) |> ends_after(an_interval) == False
/// strictly_before(6) |> ends_after(an_interval) == False
/// between(2, 5) |> ends_after(an_interval) == False
/// strictly_between(3, 6) |> ends_after(an_interval) == False
/// ```
pub fn ends_after(
  some_interval: Interval<PosixTime>,
  other_interval: Interval<PosixTime>,
) -> Bool {
  let l_bound = end_of(some_interval)
  let r_bound = end_of(other_interval)
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

/// Tells whether `some_interval` ends **after-or-at** another interval.
/// ```
/// let an_interval = between(0, 5)
/// 
/// after(4) |> ends_after_or_at(an_interval) == True
/// after(5) |> ends_after_or_at(an_interval) == True
/// after(6) |> ends_after_or_at(an_interval) == True
/// strictly_after(3) |> ends_after_or_at(an_interval) == True
/// strictly_after(4) |> ends_after_or_at(an_interval) == True
/// strictly_after(5) |> ends_after_or_at(an_interval) == True
/// before(6) |> ends_after_or_at(an_interval) == True
/// strictly_before(7) |> ends_after_or_at(an_interval) == True
/// between(3, 6) |> ends_after_or_at(an_interval) == True
/// between(4, 7) |> ends_after_or_at(an_interval) == True
/// between(5, 8) |> ends_after_or_at(an_interval) == True
/// between(6, 9) |> ends_after_or_at(an_interval) == True
/// strictly_between(4, 7) |> ends_after_or_at(an_interval) == True
/// strictly_between(5, 8) |> ends_after_or_at(an_interval) == True
/// 
/// // interval ends AT another interval:
/// before(5) |> ends_after_or_at(an_interval) == True
/// strictly_before(6) |> ends_after_or_at(an_interval) == True
/// between(2, 5) |> ends_after_or_at(an_interval) == True
/// strictly_between(3, 6) |> ends_after_or_at(an_interval) == True
/// 
/// // negative cases:
/// before(4) |> ends_after_or_at(an_interval) == False
/// strictly_before(5) |> ends_after_or_at(an_interval) == False
/// between(1, 4) |> ends_after_or_at(an_interval) == False
/// strictly_between(2, 5) |> ends_after_or_at(an_interval) == False
/// ```
pub fn ends_after_or_at(
  some_interval: Interval<PosixTime>,
  other_interval: Interval<PosixTime>,
) -> Bool {
  let l_bound = end_of(some_interval)
  let r_bound = end_of(other_interval)
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

/// Tells whether `some_interval` ends **before** another interval.
/// ```
/// let an_interval = between(5, 10)
/// 
/// before(4) |> ends_before(an_interval) == True
/// strictly_before(5) |> ends_before(an_interval) == True
/// between(1, 4) |> ends_before(an_interval) == True
/// strictly_between(2, 5) |> ends_before(an_interval) == True
/// 
/// // negative cases:
/// after(4) |> ends_before(an_interval) == False
/// after(5) |> ends_before(an_interval) == False
/// after(6) |> ends_before(an_interval) == False
/// strictly_after(3) |> ends_before(an_interval) == False
/// strictly_after(4) |> ends_before(an_interval) == False
/// strictly_after(5) |> ends_before(an_interval) == False
/// before(6) |> ends_before(an_interval) == False
/// strictly_before(7) |> ends_before(an_interval) == False
/// between(3, 6) |> ends_before(an_interval) == False
/// between(4, 7) |> ends_before(an_interval) == False
/// between(5, 8) |> ends_before(an_interval) == False
/// between(6, 9) |> ends_before(an_interval) == False
/// strictly_between(4, 7) |> ends_before(an_interval) == False
/// strictly_between(5, 8) |> ends_before(an_interval) == False
/// 
/// // interval ends AT another interval:
/// before(5) |> ends_before(an_interval) == False
/// strictly_before(6) |> ends_before(an_interval) == False
/// between(2, 5) |> ends_before(an_interval) == False
/// strictly_between(3, 6) |> ends_before(an_interval) == False
/// ```
pub fn ends_before(
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

/// Tells whether `some_interval` ends **before-or-at** another interval.
/// ```
/// let an_interval = between(5, 10)
/// 
/// before(4) |> ends_before_or_at(an_interval) == True
/// strictly_before(5) |> ends_before_or_at(an_interval) == True
/// between(1, 4) |> ends_before_or_at(an_interval) == True
/// strictly_between(2, 5) |> ends_before_or_at(an_interval) == True
/// 
/// // interval ends AT another interval:
/// before(5) |> ends_before_or_at(an_interval) == True
/// strictly_before(6) |> ends_before_or_at(an_interval) == True
/// between(2, 5) |> ends_before_or_at(an_interval) == True
/// strictly_between(3, 6) |> ends_before_or_at(an_interval) == True
/// 
/// // negative cases:
/// after(4) |> ends_before_or_at(an_interval) == False
/// after(5) |> ends_before_or_at(an_interval) == False
/// after(6) |> ends_before_or_at(an_interval) == False
/// strictly_after(3) |> ends_before_or_at(an_interval) == False
/// strictly_after(4) |> ends_before_or_at(an_interval) == False
/// strictly_after(5) |> ends_before_or_at(an_interval) == False
/// before(6) |> ends_before_or_at(an_interval) == False
/// strictly_before(7) |> ends_before_or_at(an_interval) == False
/// between(3, 6) |> ends_before_or_at(an_interval) == False
/// between(4, 7) |> ends_before_or_at(an_interval) == False
/// between(5, 8) |> ends_before_or_at(an_interval) == False
/// between(6, 9) |> ends_before_or_at(an_interval) == False
/// strictly_between(4, 7) |> ends_before_or_at(an_interval) == False
/// strictly_between(5, 8) |> ends_before_or_at(an_interval) == False
/// ```
pub fn ends_before_or_at(
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
