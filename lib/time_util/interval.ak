//// A utility module to help comparing the precedence between intervals.
//// Internally there's only one generic function to handle all logic
//// variations at the cost of memory and CPU usage.
////
//// Use `time_util/cheap/interval` instead for a slightly cheaper memory
//// and CPU usage.

use aiken/interval.{
  Finite, Interval, IntervalBoundType, NegativeInfinity, PositiveInfinity,
}
use time_util/bound.{end_bound_type_of, start_bound_type_of}
use time_util/time.{PosixTime}

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
    fn_l_bound: start_bound_type_of,
    fn_r_bound: end_bound_type_of,
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
    fn_l_bound: start_bound_type_of,
    fn_r_bound: end_bound_type_of,
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
    fn_l_bound: start_bound_type_of,
    fn_r_bound: start_bound_type_of,
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
    fn_l_bound: start_bound_type_of,
    fn_r_bound: start_bound_type_of,
    fn_compare_l_r: less_than_equals_to,
    infinity_type: NegativeInfinity,
  )
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
    fn_l_bound: end_bound_type_of,
    fn_r_bound: end_bound_type_of,
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
    fn_l_bound: end_bound_type_of,
    fn_r_bound: end_bound_type_of,
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
    fn_l_bound: end_bound_type_of,
    fn_r_bound: start_bound_type_of,
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
    fn_l_bound: end_bound_type_of,
    fn_r_bound: start_bound_type_of,
    fn_compare_l_r: less_than_equals_to,
    infinity_type: NegativeInfinity,
  )
}

fn compare(
  l_interval: Interval<PosixTime>,
  r_interval: Interval<PosixTime>,
  fn_l_bound: fn(Interval<PosixTime>) -> IntervalBoundType<PosixTime>,
  fn_r_bound: fn(Interval<PosixTime>) -> IntervalBoundType<PosixTime>,
  fn_compare_l_r: fn(PosixTime, PosixTime) -> Bool,
  infinity_type: IntervalBoundType<PosixTime>,
) {
  let l_bound = l_interval |> fn_l_bound
  let r_bound = r_interval |> fn_r_bound
  when (l_bound, r_bound) is {
    (Finite(l), Finite(r)) -> fn_compare_l_r(l, r)
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
