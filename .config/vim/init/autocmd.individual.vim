augroup individual_autocmds
  autocmd!
  autocmd BufRead ~/.xinitrc setfiletype sh
  autocmd BufRead ~/.config/polybar/config setfiletype dosini
  autocmd BufRead ~/.config/zathura/zathurarc setfiletype vim

  autocmd BufRead ~/.XCompose inoremap <buffer> <C-f><C-f> <Multi_key><space>
augroup END

function! s:ScriptExecInVimTerminal(file, interpreter, script, term_rows) abort
  execute 'autocmd individual_autocmds BufWritePost ' . fnameescape(a:file) .
    \ ' term ++rows=' . a:term_rows . ' ' . a:interpreter . ' ' .
    \ escape(a:script, '%# "\' . "\<tab>\<cword>\n")
endfunction

function! s:SilentScriptExec(file, interpreter, script) abort
  execute 'autocmd individual_autocmds BufWritePost ' . fnameescape(a:file) .
    \ ' silent :! ' . a:interpreter . ' ' . shellescape(a:script, 1)
endfunction

function! s:ExecAndNotify(file, exec, notify) abort
  let l:script = a:exec . ' && notify-send --hint=int:transient:1 -- "' .
    \ a:notify . ' reconfigured"'
  call s:SilentScriptExec(a:file, 'sh -c', l:script)
endfunction

function! s:BuffWriteAutoCmds() abort
  call s:ExecAndNotify('~/.Xresources', 'xrdb -merge ~/.Xresources', 'Xresources')
  call s:ExecAndNotify('~/.config/sxhkd/sxhkdrc', 'pkill -USR1 -U "$(id -un)" -x sxhkd', 'sxhkd')
  call s:ExecAndNotify('~/.config/openbox/rc.xml', 'openbox --reconfigure', 'Openbox')
  call s:ExecAndNotify('~/.themes/Numix-Alt/openbox-3/themerc', 'openbox --reconfigure', 'Openbox')

  let l:file = '~/scripts/tags/tag-tools.sh'
  let l:script = 'printf %s\\n\\n "RUNNING TEST:";' .
    \ 'time ~/scripts/tags/tag-tools-test.sh'
  call s:ScriptExecInVimTerminal(l:file, 'bash -c', l:script, 11)
endfunction

call s:BuffWriteAutoCmds()
