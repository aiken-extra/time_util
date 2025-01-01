# time_util

A utility library to help comparing and mocking time intervals.

| ℹ️  | Package info    | aiken-extra/time_util v6.220.202501 | 🐞  |
| --- | --------------- | ----------------------------------- | --- |
| 🟢  | **Depends on**  | **aiken-lang/stdlib v2.2.0**        | ✔️  |
| 🟢  | **Tested with** | **aiken v1.1.9**                    | ✔️  |

## Get the latest **block-time**, and run `aiken check`

You can have a real latest block-time value when running tests!

> [!NOTE]
> For Linux

Copy [`./check.sh`](./check.sh) and paste it in the root directory of your Aiken project.
Make it an executable.

Add `now` to `aiken.toml` configurations like:

```toml
[config.default]
...
now = 0
...

[config.any]
...
now = 0
...
```

Run `./check.sh` (with optional `-m` and/or `-E` arguments)

```bash
$ ./check.sh -H
Usage: ./check.sh -m <MATCH_TEST> -E <ENV>
```

It will get the latest block-time, thanks to [Koios](https://www.koios.rest),
and reconfigure the value for `now` in all environments.

Access it from your code by:

```gleam
use config
trace config.now
```
