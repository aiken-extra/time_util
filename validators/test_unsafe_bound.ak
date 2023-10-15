//// ```
//// ┍━ test_unsafe_bound ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem:  315895, cpu: 117363288] finite_start
//// │ PASS [mem:  298967, cpu: 110454444] finite_end
//// ┕━━━━━━━━━━━━━━━━━━━ 2 tests | 2 passed | 0 failed
//// ```

use aiken/interval.{
  after, before, between, entirely_after, entirely_before, entirely_between,
}
use time_util/unsafe/bound.{finite_end_of, finite_start_of}

test finite_start() {
  and {
    ( after(4) |> finite_start_of ) == 4,
    ( after(6) |> finite_start_of ) == 6,
    ( entirely_after(3) |> finite_start_of ) == 4,
    ( entirely_after(5) |> finite_start_of ) == 6,
    ( between(1, 4) |> finite_start_of ) == 1,
    ( between(6, 9) |> finite_start_of ) == 6,
    ( entirely_between(2, 5) |> finite_start_of ) == 3,
    ( entirely_between(5, 8) |> finite_start_of ) == 6,
  }
}

test finite_end() {
  and {
    ( before(4) |> finite_end_of ) == 4,
    ( before(6) |> finite_end_of ) == 6,
    ( entirely_before(5) |> finite_end_of ) == 4,
    ( entirely_before(7) |> finite_end_of ) == 6,
    ( between(1, 4) |> finite_end_of ) == 4,
    ( between(6, 9) |> finite_end_of ) == 9,
    ( entirely_between(2, 5) |> finite_end_of ) == 4,
    ( entirely_between(5, 8) |> finite_end_of ) == 7,
  }
}
