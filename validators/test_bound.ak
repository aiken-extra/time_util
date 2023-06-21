//// ```
//// ┍━ test_bound ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem:  472308, cpu:  189633054] finite_start_bound_type
//// │ PASS [mem:  173004, cpu:   69469162] infinite_start_bound_type
//// │ PASS [mem:  455380, cpu:  182724210] finite_end_bound_type
//// │ PASS [mem:  189932, cpu:   76378006] infinite_end_bound_type
//// ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4 tests | 4 passed | 0 failed
//// ```

use aiken/interval.{
  Finite, NegativeInfinity, PositiveInfinity, after, before, between,
  strictly_after, strictly_before, strictly_between,
}
use aiken/list
use time_util/bound.{end_bound_type_of, start_bound_type_of}

test finite_start_bound_type() {
  [
    ( after(4) |> start_bound_type_of ) == Finite(4),
    ( after(6) |> start_bound_type_of ) == Finite(6),
    ( strictly_after(3) |> start_bound_type_of ) == Finite(4),
    ( strictly_after(5) |> start_bound_type_of ) == Finite(6),
    ( between(1, 4) |> start_bound_type_of ) == Finite(1),
    ( between(6, 9) |> start_bound_type_of ) == Finite(6),
    ( strictly_between(2, 5) |> start_bound_type_of ) == Finite(3),
    ( strictly_between(5, 8) |> start_bound_type_of ) == Finite(6),
  ]
    |> list.and
}

test infinite_start_bound_type() {
  [
    ( before(4) |> start_bound_type_of ) == NegativeInfinity,
    ( before(6) |> start_bound_type_of ) == NegativeInfinity,
    ( strictly_before(5) |> start_bound_type_of ) == NegativeInfinity,
    ( strictly_before(7) |> start_bound_type_of ) == NegativeInfinity,
  ]
    |> list.and
}

test finite_end_bound_type() {
  [
    ( before(4) |> end_bound_type_of ) == Finite(4),
    ( before(6) |> end_bound_type_of ) == Finite(6),
    ( strictly_before(5) |> end_bound_type_of ) == Finite(4),
    ( strictly_before(7) |> end_bound_type_of ) == Finite(6),
    ( between(1, 4) |> end_bound_type_of ) == Finite(4),
    ( between(6, 9) |> end_bound_type_of ) == Finite(9),
    ( strictly_between(2, 5) |> end_bound_type_of ) == Finite(4),
    ( strictly_between(5, 8) |> end_bound_type_of ) == Finite(7),
  ]
    |> list.and
}

test infinite_end_bound_type() {
  [
    ( after(4) |> end_bound_type_of ) == PositiveInfinity,
    ( after(6) |> end_bound_type_of ) == PositiveInfinity,
    ( strictly_after(3) |> end_bound_type_of ) == PositiveInfinity,
    ( strictly_after(5) |> end_bound_type_of ) == PositiveInfinity,
  ]
    |> list.and
}
