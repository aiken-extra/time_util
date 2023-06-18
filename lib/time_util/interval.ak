//// A utility module to help comparing the precedence between intervals.
//// Internally there's only one generic function to handle all logic
//// variations at the cost of memory and CPU usage.
////
//// Use `time_util/cheap/interval` instead for a slightly cheaper memory
//// and CPU usage.
////
//// ```
//// time_util/interval:
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
//// 
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
//// ```

use aiken/builtin.{add_integer, subtract_integer}
use aiken/interval.{
  Finite, Interval, IntervalBound, IntervalBoundType, NegativeInfinity,
  PositiveInfinity, max, min,
}
use aiken/time.{PosixTime}

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
  compare(
    l_interval: some_interval,
    r_interval: other_interval,
    fn_l_bound: start_of,
    fn_r_bound: end_of,
    fn_l_exclusive: add_integer(_, 1),
    fn_r_exclusive: subtract_integer(_, 1),
    fn_compare_l_r: greater_than,
    infinity_type: PositiveInfinity,
  )
}

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
  compare(
    l_interval: some_interval,
    r_interval: other_interval,
    fn_l_bound: start_of,
    fn_r_bound: end_of,
    fn_l_exclusive: add_integer(_, 1),
    fn_r_exclusive: subtract_integer(_, 1),
    fn_compare_l_r: greater_than_equals_to,
    infinity_type: PositiveInfinity,
  )
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
  compare(
    l_interval: some_interval,
    r_interval: other_interval,
    fn_l_bound: start_of,
    fn_r_bound: start_of,
    fn_l_exclusive: add_integer(_, 1),
    fn_r_exclusive: add_integer(_, 1),
    fn_compare_l_r: less_than,
    infinity_type: NegativeInfinity,
  )
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
  compare(
    l_interval: some_interval,
    r_interval: other_interval,
    fn_l_bound: start_of,
    fn_r_bound: start_of,
    fn_l_exclusive: add_integer(_, 1),
    fn_r_exclusive: add_integer(_, 1),
    fn_compare_l_r: less_than_equals_to,
    infinity_type: NegativeInfinity,
  )
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
  compare(
    l_interval: some_interval,
    r_interval: other_interval,
    fn_l_bound: end_of,
    fn_r_bound: end_of,
    fn_l_exclusive: subtract_integer(_, 1),
    fn_r_exclusive: subtract_integer(_, 1),
    fn_compare_l_r: greater_than,
    infinity_type: PositiveInfinity,
  )
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
  compare(
    l_interval: some_interval,
    r_interval: other_interval,
    fn_l_bound: end_of,
    fn_r_bound: end_of,
    fn_l_exclusive: subtract_integer(_, 1),
    fn_r_exclusive: subtract_integer(_, 1),
    fn_compare_l_r: greater_than_equals_to,
    infinity_type: PositiveInfinity,
  )
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
  compare(
    l_interval: some_interval,
    r_interval: other_interval,
    fn_l_bound: end_of,
    fn_r_bound: start_of,
    fn_l_exclusive: subtract_integer(_, 1),
    fn_r_exclusive: add_integer(_, 1),
    fn_compare_l_r: less_than,
    infinity_type: NegativeInfinity,
  )
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
  compare(
    l_interval: some_interval,
    r_interval: other_interval,
    fn_l_bound: end_of,
    fn_r_bound: start_of,
    fn_l_exclusive: subtract_integer(_, 1),
    fn_r_exclusive: add_integer(_, 1),
    fn_compare_l_r: less_than_equals_to,
    infinity_type: NegativeInfinity,
  )
}

fn compare(
  l_interval: Interval<PosixTime>,
  r_interval: Interval<PosixTime>,
  fn_l_bound: fn(Interval<PosixTime>) -> IntervalBound<PosixTime>,
  fn_r_bound: fn(Interval<PosixTime>) -> IntervalBound<PosixTime>,
  fn_l_exclusive: fn(PosixTime) -> PosixTime,
  fn_r_exclusive: fn(PosixTime) -> PosixTime,
  fn_compare_l_r: fn(PosixTime, PosixTime) -> Bool,
  infinity_type: IntervalBoundType<PosixTime>,
) {
  let l_bound = l_interval |> fn_l_bound
  let r_bound = r_interval |> fn_r_bound
  when (l_bound.bound_type, r_bound.bound_type) is {
    (Finite(l), Finite(r)) -> {
      let l =
        if l_bound.is_inclusive {
          l
        } else {
          l |> fn_l_exclusive
        }
      let r =
        if r_bound.is_inclusive {
          r
        } else {
          r |> fn_r_exclusive
        }
      fn_compare_l_r(l, r)
    }
    // (infinity, _) -> infinity == infinity_type // bugged as of Aiken v1.0.8-alpha
    (PositiveInfinity, _) -> PositiveInfinity == infinity_type
    (NegativeInfinity, _) -> NegativeInfinity == infinity_type
    (_, PositiveInfinity) -> PositiveInfinity != infinity_type
    (_, NegativeInfinity) -> NegativeInfinity != infinity_type
  }
}

fn greater_than(a, b) {
  a > b
}

fn greater_than_equals_to(a, b) {
  a >= b
}

fn less_than(a, b) {
  a < b
}

fn less_than_equals_to(a, b) {
  a <= b
}
