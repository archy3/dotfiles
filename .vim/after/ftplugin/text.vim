if filereadable($HOME . "/.vim/spell/es.utf-8.spl")
  setlocal spelllang=en,es
endif
setlocal wrap
setlocal linebreak

" We want spellcheck on new (i.e. empty) files
" (e.g. vim just opened without opening a file, opened a file that doesn't exist,
" opened an empty file, or an `enew`):
" (from https://vi.stackexchange.com/a/2559):
if line('$') == 1 && col('$') == 1
  setlocal spell

  " For some reason, `b:undo_ftplugin` isn't always activated when the
  " current buffer lack a filename (such as when `vim` is opened without
  " arguments), which leaves settings like `spell` still active when a
  " new filetype is entered. Thus we make an autocmd to set the filetype
  " back to `text` and then reset it back to whatever it was before to
  " activate the `b:undo_ftplugin'.
  if (@% == "")
    let w:text_ftplugin_may_need_to_be_undone = 1
    autocmd BufNewFile,BufRead * if exists('w:text_ftplugin_may_need_to_be_undone') | let s:filetype_save = &filetype | set filetype=text | exec 'set filetype=' . s:filetype_save | unlet w:text_ftplugin_may_need_to_be_undone | endif
      " Without the guard `if exists('w:text_ftplugin_may_need_to_be_undone')`,
      " performance problems can occur in plugins that create
      " many buffers (such as quick-fix windows).
  endif
endif

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal spell<'
  let b:undo_ftplugin .= '|setlocal spelllang<'
  let b:undo_ftplugin .= '|setlocal wrap<'
  let b:undo_ftplugin .= '|setlocal linebreak<'
endif
