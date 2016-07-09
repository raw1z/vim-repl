command! SendToREPL call vim_repl#send_to_repl()
command! -range SendVisualSelectionToREPL call vim_repl#send_visual_selection_to_repl()

if !exists("g:repl_map_keys")
  let g:repl_map_keys = 1
endif

if g:repl_map_keys
  nmap <leader>c :SendToREPL<CR>
  vmap <leader>c :SendVisualSelectionToREPL<CR>
endif

