command! OpenREPL call repl#open_repl(0)
command! VOpenREPL call repl#open_repl(1)
command! SendToREPL call repl#send_to_repl()
command! -range SendVisualSelectionToREPL call repl#send_visual_selection_to_repl()

if !exists("g:repl_map_keys")
  let g:repl_map_keys = 1
endif

if g:repl_map_keys
  nnoremap <leader><leader>! :OpenREPL<CR>
  nnoremap <leader>! :SendToREPL<CR>
  vnoremap <leader>! :SendVisualSelectionToREPL<CR>
endif

