# FAQ for build Makefile

## 1 In your code, I saw that sometime you add `""` and sometime not, so when shall I add `""`?

The **when** is your string as *input argument as next program* (getopt case)

Let see following examples:

for example:

```bash
#/bin/bash
var="is a string contain space"
bash a.bash -i ${var}
```

or

```makefile
#makefile
var="is a string contain space"
make -C /path/to/makefile/dir arg="${var}"
```

if you don't add `""` (${var}), then bash and makefile and tcl will expend as:

(1)

```bash
#bash
-i is a string contain space
```

for the `-i` will only read `is` as opt of `-i`

(2)

```makefile
#makefile
arg=is a string contain space
```

for the `arg` will only read `is` as opt of `arg`

So if your `var` may conatin **space**, than please `""` into your `${var}` when **invoke form argument list**

### Note

Some case such as `vivado x.tcl -args ...` or `xsct x.tcl -args ...`

will auto handling arguments  `...`, so **don't add `""` for this case**