let s:V = vital#of("vital")
let s:String = s:V.import("Data.String")
let s:Vim = s:V.import("Vim.Buffer")

function! vim_repl#find_terminal_in_current_tab() "{{{
  let buffers = map(tabpagebuflist(), "bufname(v:val)")
  for buffer in buffers
    if s:String.starts_with(buffer, "term://")
      return bufwinnr(buffer)
    endif
  endfor
endfunction "}}}
function! vim_repl#update_repl(selection) "{{{
  let terminalWindowNumber = s:find_terminal_in_current_tab()
  if terminalWindowNumber > 0
    execute terminalWindowNumber . "wincmd w"
    let @r = a:selection
    put r
    call feedkeys("a\r")
  endif
endfunction "}}}
function! vim_repl#send_to_repl() "{{{
  normal vip
  call s:send_visual_selection_to_repl()
endfunction "}}}
function! vim_repl#send_visual_selection_to_repl() "{{{
  let selection = GetVisuallySelectedText()
  call s:update_repl(selection)
endfunction "}}}

