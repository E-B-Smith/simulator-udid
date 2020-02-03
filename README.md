[![MIT licensed](https://img.shields.io/badge/license-MIT-orange.svg)](https://raw.githubusercontent.com/hyperium/hyper/master/LICENSE)

# simulator-udid

Returns an iOS simulator udid given a system name and OS version.

[Contribute at https://github.com/E-B-Smith/simulator-udid!](https://github.com/E-B-Smith/simulator-udid)

```
usage: simulator-udid [-hvV] [ -n <simulator-name> -s <simulator-system> ] | -d <simulator-device> ]

    -h --help      Show help.
    -l --list      List the simulators and exit.
    -n --name      The simultor name, like 'iPhone 6s'.
    -s --system    The simulator system, like '12.2'.
    -d --device    The simulator device, like 'name=iPhone 6s,OS=12.2'
    -v --verbose   Verbose.
    -V --version   Show version.
```

## Example

![Example](./Documentation/Example.png)
