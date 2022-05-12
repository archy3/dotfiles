function! SilentScriptExec(file, interpreter, script) abort
  execute 'autocmd BufWritePost' fnameescape(a:file) 'silent :!' a:interpreter shellescape(a:script, 1)
endfunction

function! ExecAndNotify(file, exec, notify) abort
  let l:script = a:exec . ' && notify-send --hint=int:transient:1 -- "' . a:notify . ' reconfigured"'
  call SilentScriptExec(a:file, 'sh -c', l:script)
endfunction

function! BuffWriteAutoCmds() abort
  call ExecAndNotify('~/.Xresources', 'xrdb -merge ~/.Xresources', 'Xresources')
  call ExecAndNotify('~/.config/sxhkd/sxhkdrc', 'pkill -USR1 -U "$(id -un)" -x sxhkd', 'sxhkd')
  call ExecAndNotify('~/.config/openbox/rc.xml', 'openbox --reconfigure', 'Openbox')

  let l:file = '~/scripts/tags/tag-tools.sh'
  let l:script = 'printf %s\\n\\n "RUNNING TEST:";
    \ time ~/scripts/tags/tag-tools-test.sh;
    \ printf \\n%s "Press CTRL-C to exit ";
    \ tail -f /dev/null'
  call SilentScriptExec(l:file, 'xterm -e bash -c', l:script)
endfunction

call BuffWriteAutoCmds()

delfunction BuffWriteAutoCmds
delfunction SilentScriptExec
delfunction ExecAndNotify

autocmd BufRead ~/.xinitrc set filetype=sh
autocmd BufRead ~/.config/polybar/config set filetype=dosini
autocmd BufRead ~/.config/dunst/dunstrc set filetype=dosini
autocmd BufRead ~/.config/zathura/zathurarc set filetype=vim
