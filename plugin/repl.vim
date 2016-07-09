command! SendToREPL call repl#send_to_repl()
command! -range SendVisualSelectionToREPL call repl#send_visual_selection_to_repl()

if !exists("g:repl_map_keys")
  let g:repl_map_keys = 1
endif

if g:repl_map_keys
  nmap <leader>cc :SendToREPL<CR>
  vmap <leader>cc :SendVisualSelectionToREPL<CR>
endif

