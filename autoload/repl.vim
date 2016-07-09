let s:V = vital#of("vital")
let s:String = s:V.import("Data.String")
let s:Vim = s:V.import("Vim.Buffer")

function! repl#find_terminal_in_current_tab() "{{{
  let buffers = map(tabpagebuflist(), "bufname(v:val)")
  for buffer in buffers
    if s:String.starts_with(buffer, "term://")
      return bufwinnr(buffer)
    endif
  endfor
endfunction "}}}
function! repl#update_repl(selection) "{{{
  let terminalWindowNumber = repl#find_terminal_in_current_tab()
  if terminalWindowNumber > 0
    execute terminalWindowNumber . "wincmd w"
    let @r = a:selection
    put r
    call feedkeys("a\r")
  endif
endfunction "}}}
function! repl#send_to_repl() "{{{
  exe "%SendVisualSelectionToREPL"
endfunction "}}}
function! repl#send_visual_selection_to_repl() "{{{
  let selection = s:Vim.get_last_selected()
  call repl#update_repl(selection)
endfunction "}}}

