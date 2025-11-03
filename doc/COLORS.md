How to Get True Color
====
For best color, vim-nftables-syntax works best in 256color or 16M color.

A quick test to see where you stand is to find out how much color your terminal supports now:

```bash
tput colors
```

Result might be:

| `tput` result | Description | `echo $TERM` | `echo $COLORTERM` |
|---|---|---|---|
| `16777216` | The whole color spectrum, almost | `xterm-direct` | `truecolor` |
| `256` | 256 EVGA RGB colors | `xterm-256color` | ignores `truecolor` |
| `88` | 88-color Xterm | `xterm` or `xterm-88color` | n/a |
| `16` | 16-color (IBM VGA) | `xterm-color` or `xterm-direct16` | n/a |
| `8` | 8-color (Atari) | `ansi` | n/a |
| `2` | bold, italic, regular | `vt52` or `xterm-direct2` | n/a |
| `1` | teletype | `tty`, `dumb`, `vt50`, or `xterm-mono` | n/a |


TL/DR
-----
Most common approach for multi-color support for Vim/NeoVim is to insert following snippet of Vimscript code into your `~/.vimrc`:

```vim
" echo &termguicolors
" echo &t_Co
if $COLORTERM == "truecolor"
  " echo "has TRUECOLOR"
  if $TERM == "xterm-256color" || $TERM == "xterm-direct"
    if has('termguicolors')
      " echo "Has termguicolors"
      set termguicolors
    endif
  endif
else
  " echo "COLORTERM has weird something: \'" $COLORTERM "\'"
  if $TERM == "xterm-direct"
    if has('termguicolors')
      " echo "Has termguicolors"
      set termguicolors
    endif
  endif
endif
" echo &termguicolors
" echo &t_Co
syntax on
```

Get your `$TERM` defined to `xterm-direct` (or in very old editors: `xterm-256color`):
```bash
export TERM=xterm-direct
```

Stick the above statements into your `~/.bashrc`.

At this point, you are ready to highlight any Vim syntax-supported files.

Only read on if you need support outside of Vim/Neovim editor.



Color Terminal Setup
====
For a color X11-based terminal and no shell configuration needed, the recommended approach to colorized your X11 terminal is to use `.Xresources` file:

```ini
# File: ~/.Xresources
xterm*background: black
xterm*foreground: white
xterm*cursorColor: green
xterm*reverseVideo: false
```

Then apply in a bash/csh/zsh shell session:
```bash
xrdb -merge ~/.Xresources
```

Some common color themes are:

| Theme | .Xresources |
|-------|-------------|
| Black on White | "background: black foreground: white" |
| Solarized Dark | "background: #002b36 foreground: #839496" |
| Zenburn | "background: #3f3f3f foreground: #dcdccc" |


Alternative Method 1 (Quickie)
----
Test the terminal quickly (or permanently), if Xresources file is not an option:
```bash
xterm -bg black -fg white -cr green &
```

Alternative Method 2 (Older X11)
----
For much older pre-2011 X platform, insert this into your `~/.Xdefault` file:

```ini
xterm*background: #000000
xterm*foreground: #ffffff
```

Then apply:
```bash
xrdb -load ~/.Xdefaults
```

Troubleshooting
====
Check Terminal Firstly
----
Always start with the terminal when determining color capabilities:

Execute this in your bash shell:
```bash
printf '\e[38;2;255;100;0mTRUECOLOR\e[0m\n'
```  
*  If lettering to the word TRUECOLOR appears in red with a bit of orange tint, then terminal is TRUECOLOR-capable.  
*  nothing, then it is either an 8-bit or 16-bit RGB; might even be older.


Setups
====
To get at least 256-colors or more, the set up for various terminals and editors are here:

Terminal Setups
----
| Terminal | Commands |
|----------|----------|
| `tmux` | `set -ga terminal-overrides ",xterm-256color:Tc"` |
| `screen` | `term screen-256color` |
| `xterm` |  `export TERM=xterm-256color` |

Editor Setups
----
| Best for Truecolor | `TERM=`  | `COLORTERM=` |
|-----------------|----------|-----------|
| Vim/NeoVim | `xterm-direct` | (unset or `truecolor`) |
| Konsole  | `xterm-direct`  |     (unset or `truecolor`) |
| Alacritty/Kitty |  `alacritty` / `kitty` |  `truecolor` |


Rainbow Time (32-bit)
====
This section only applies if `TERM=xterm-256color` or `TERM=xterm-direct`.

You can see what your terminal has for color support on Debian 13:

```console
$ echo $TERM
xterm-direct
```

insert the following into `~/.vimrc` file

File: `~/.vimrc`
```vim
if has("termguicolors")
    set termguicolors
endif
```

To get full 32-bit color across multiple editors/applications, the shell environment:

File: `~/.bash_profile`
```bash
export TERM=TRUECOLOR
```



Linux Console (16-bit)
====
The `TERM=linux` is becoming less common since Slackware v1.0 introduced it in 1993.

```bash
" ~/.vimrc — enable truecolor in Konsole
if has("termguicolors")
    set termguicolors
endif
```

set background=dark
colorscheme desert     " or: default, koelher, ron, industry

```vim
if has("termguicolors")
    set termguicolors
endif
```

Shell `TERM` environment be set to:
```bash
export TERM=xterm-256colors
```

RGB Color
====
Original RGB is 8-bit or 256-color.

Shell `TERM` environment be set to:
```bash
export TERM=xterm
```


Less RGB Support (2-bitWhite)
====
2-bit is just plain letters, underscore and bold highlighting. Often found from 2009 to 2013.

Vim defaults to 8-bit color, so if your terminal requires less color 
support, additional settings are needed to reduce color support.

For `Vim` (since v7.4.-1799 (2016)):
```vim
set notermguicolors
set &t_Co=2
```
For `NeoVim` (since v0.1.5 (2016))
```vim
set termguicolors&
set &t_Co=2
```

Shell `TERM` environment be set to:
```bash
export TERM=xterm
```

Black and White Only
====
1-bit is just plain letters or a background.  You won't benefit at all from all of us highlighting developers.  ;-)

Vim defaults to 8-bit color, so if your terminal is older then 2001
and requires less color support, additional settings may be necessary
to reduce color support.

For `Vim` (since v7.4.-1799 (2016)):
```vim
set notermguicolors
set &t_Co=1
```
For `NeoVim` (since v0.1.5 (2016))
```vim
set termguicolors&
set &t_Co=1
```

Also must set `TERM` to:
```bash
export TERM=tty
# or
export TERM=dumb
```
