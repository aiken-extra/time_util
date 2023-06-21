//// ```
//// ┍━ test_unsafe_bound ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem:  461540, cpu:  178370318] finite_start
//// │ PASS [mem:  444612, cpu:  171461474] finite_end
//// ┕━━━━━━━━━━━━━━━━━━━━ 2 tests | 2 passed | 0 failed
//// ```

use aiken/interval.{
  after, before, between, strictly_after, strictly_before, strictly_between,
}
use aiken/list
use time_util/unsafe/bound.{finite_end_of, finite_start_of}

test finite_start() {
  [
    ( after(4) |> finite_start_of ) == 4,
    ( after(6) |> finite_start_of ) == 6,
    ( strictly_after(3) |> finite_start_of ) == 4,
    ( strictly_after(5) |> finite_start_of ) == 6,
    ( between(1, 4) |> finite_start_of ) == 1,
    ( between(6, 9) |> finite_start_of ) == 6,
    ( strictly_between(2, 5) |> finite_start_of ) == 3,
    ( strictly_between(5, 8) |> finite_start_of ) == 6,
  ]
    |> list.and
}

test finite_end() {
  [
    ( before(4) |> finite_end_of ) == 4,
    ( before(6) |> finite_end_of ) == 6,
    ( strictly_before(5) |> finite_end_of ) == 4,
    ( strictly_before(7) |> finite_end_of ) == 6,
    ( between(1, 4) |> finite_end_of ) == 4,
    ( between(6, 9) |> finite_end_of ) == 9,
    ( strictly_between(2, 5) |> finite_end_of ) == 4,
    ( strictly_between(5, 8) |> finite_end_of ) == 7,
  ]
    |> list.and
}
