//// ```
//// ┍━ test_bound ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem: 130715, cpu:  49597331] finite_start_bound_type
//// │ PASS [mem:  46203, cpu:  17050575] infinite_start_bound_type
//// │ PASS [mem: 132571, cpu:  50506635] finite_end_bound_type
//// │ PASS [mem:  47131, cpu:  17505227] infinite_end_bound_type
//// ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4 tests | 4 passed | 0 failed
//// ```

use aiken/interval.{
  Finite, NegativeInfinity, PositiveInfinity, after, before, between,
  entirely_after, entirely_before, entirely_between,
}
use time_util/bound.{end_bound_type_of, start_bound_type_of}

test finite_start_bound_type() {
  and {
    ( after(4) |> start_bound_type_of ) == Finite(4),
    ( after(6) |> start_bound_type_of ) == Finite(6),
    ( entirely_after(3) |> start_bound_type_of ) == Finite(4),
    ( entirely_after(5) |> start_bound_type_of ) == Finite(6),
    ( between(1, 4) |> start_bound_type_of ) == Finite(1),
    ( between(6, 9) |> start_bound_type_of ) == Finite(6),
    ( entirely_between(2, 5) |> start_bound_type_of ) == Finite(3),
    ( entirely_between(5, 8) |> start_bound_type_of ) == Finite(6),
  }
}

test infinite_start_bound_type() {
  and {
    ( before(4) |> start_bound_type_of ) == NegativeInfinity,
    ( before(6) |> start_bound_type_of ) == NegativeInfinity,
    ( entirely_before(5) |> start_bound_type_of ) == NegativeInfinity,
    ( entirely_before(7) |> start_bound_type_of ) == NegativeInfinity,
  }
}

test finite_end_bound_type() {
  and {
    ( before(4) |> end_bound_type_of ) == Finite(4),
    ( before(6) |> end_bound_type_of ) == Finite(6),
    ( entirely_before(5) |> end_bound_type_of ) == Finite(4),
    ( entirely_before(7) |> end_bound_type_of ) == Finite(6),
    ( between(1, 4) |> end_bound_type_of ) == Finite(4),
    ( between(6, 9) |> end_bound_type_of ) == Finite(9),
    ( entirely_between(2, 5) |> end_bound_type_of ) == Finite(4),
    ( entirely_between(5, 8) |> end_bound_type_of ) == Finite(7),
  }
}

test infinite_end_bound_type() {
  and {
    ( after(4) |> end_bound_type_of ) == PositiveInfinity,
    ( after(6) |> end_bound_type_of ) == PositiveInfinity,
    ( entirely_after(3) |> end_bound_type_of ) == PositiveInfinity,
    ( entirely_after(5) |> end_bound_type_of ) == PositiveInfinity,
  }
}
