if filereadable($HOME . "/.vim/spell/es.utf-8.spl")
  setlocal spelllang=en,es
endif
setlocal wrap
setlocal linebreak

" We want spellcheck on new (i.e. empty) files
" (e.g. vim just opened without opening a file, opened a file that doesn't exist,
" opened an empty file, or an `enew`):
" (from https://vi.stackexchange.com/a/2559):
if line('$') ==# 1 && col('$') ==# 1
  setlocal spell

  " For some reason, `b:undo_ftplugin` is not activated when entering a
  " new file (e.g. `:edit /etc/fstab`) when `bufname('%')` is empty
  " while `&modified` is false (such as when `vim` is opened without
  " arguments and no edits are made to the initial empty and unnamed
  " buffer), which leaves window-local settings like `spell` still
  " active when the new filetype is entered (it seems buffer-local
  " settings are not carried over into the new file regardless if
  " `b:undo_ftplugin` is executed or not, despite the buffer of the new
  " file having the same `bufnr('%')` as the empty buffer it was entered
  " from). Thus we make an autocmd to set the filetype back to `text`
  " and then reset it back to whatever it was before to activate the
  " `b:undo_ftplugin' of the text ftplugin.
  if (@% ==# "")
    if !exists('g:text_ftplugin_may_need_to_be_undone')
      let g:text_ftplugin_may_need_to_be_undone = {}
    endif
    let g:text_ftplugin_may_need_to_be_undone[bufnr('%')] = 1
    augroup text_ft_fix_b_undo_ftplugin_not_activating_bug
      autocmd!
      autocmd BufNewFile,BufRead *
        \ if exists('g:text_ftplugin_may_need_to_be_undone') && has_key(g:text_ftplugin_may_need_to_be_undone, bufnr('%')) |
        \   let s:filetype_save = &filetype |
        \   set filetype=text |
        \   exec 'set filetype=' . s:filetype_save |
        \   call remove(g:text_ftplugin_may_need_to_be_undone, bufnr('%')) |
        \ endif
        " Without the guard `if exists('g:text_ftplugin_may_need_to_be_undone') && ...`,
        " performance problems can occur in plugins that create
        " many buffers (such as quick-fix windows).
    augroup END
  endif
endif

" Create undo checkpoints when writing prose:
inoremap <buffer> . .<c-g>u
inoremap <buffer> , ,<c-g>u
inoremap <buffer> ; ;<c-g>u
inoremap <buffer> : :<c-g>u
inoremap <buffer> ! !<c-g>u
inoremap <buffer> ? ?<c-g>u
inoremap <buffer> <cr> <c-g>u<cr>

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal spell<'
  let b:undo_ftplugin .= '|setlocal spelllang<'
  let b:undo_ftplugin .= '|setlocal wrap<'
  let b:undo_ftplugin .= '|setlocal linebreak<'
  let b:undo_ftplugin .= '|mapclear <buffer> | mapclear! <buffer>'
endif
