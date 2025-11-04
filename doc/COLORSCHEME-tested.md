TERM            COLORTERM  &t_Co  
xterm-direct    truecolor  16777216  (requires 'set termguicolors')
xterm-direct               16777216  
xterm-256color  truecolor  256
xterm-256color             256


Debian installs the following colorschemes:
  tput (not run)
  TERM=xterm-direct
  COLORTERM=truecolor
  KConsole Green on Black
  echo &termguicolors is not enabled (forces 8-bit RGB)
  echo &t_Co 16777216

Light background:
/usr/share/vim/vim91/colors/default.vim (ok)
/usr/share/vim/vim91/colors/delek.vim
/usr/share/vim/vim91/colors/elflord.vim (?)
/usr/share/vim/vim91/colors/evening.vim (?)
/usr/share/vim/vim91/colors/habamax.vim (?)
/usr/share/vim/vim91/colors/morning.vim (?)
/usr/share/vim/vim91/colors/lunaperche.vim (?)
/usr/share/vim/vim91/colors/peachpuff.vim
/usr/share/vim/vim91/colors/shine.vim
/usr/share/vim/vim91/colors/zellner.vim

Dark background:
/usr/share/vim/vim91/colors/blue.vim   (poor)
/usr/share/vim/vim91/colors/darkblue.vim   (poor)
/usr/share/vim/vim91/colors/desert.vim (fair)
/usr/share/vim/vim91/colors/industry.vim (blue-washed)
/usr/share/vim/vim91/colors/koehler.vim
/usr/share/vim/vim91/colors/murphy.vim (blue-washed)
/usr/share/vim/vim91/colors/pablo.vim (blue-washed)
/usr/share/vim/vim91/colors/quiet.vim (blue-washed)
/usr/share/vim/vim91/colors/retrobox.vim (blue-washed)
/usr/share/vim/vim91/colors/ron.vim (blue-washed)
/usr/share/vim/vim91/colors/slate.vim (blue-washed)
/usr/share/vim/vim91/colors/sorbet.vim (blue-washed)
/usr/share/vim/vim91/colors/torte.vim
/usr/share/vim/vim91/colors/unokai.vim (blue-washed)
/usr/share/vim/vim91/colors/wildcharm.vim
/usr/share/vim/vim91/colors/zaibatsu.vim


Basically, this means that it is paramount to have the `termguicolors` command in your Vimscript or either that or scale back your terminal color support to 256-color.

-  `vim -c 'termguicolors'`
or
-  `export TERM=xterm-256color`
