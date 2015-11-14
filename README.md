{{ GAMENAME }} game
================

It's all about {{ GAMENAME }}

HOW TO INSTALL DEV
==================

```sh
$ git clone git@github.com:SweepySweepers/Minesweeper.git && cd Minesweeper
$ nimble install -y
$ bin/nake
```

P.S. `bin/nake` is a wrapper for `nake`, which overrides known issues and takes
same params.

P.P.S. After running `bin/nake` first, you may use `./nakefile` binary instead.
