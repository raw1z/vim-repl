let s:V = vital#of("vital")
let s:String = s:V.import("Data.String")
let s:Vim = s:V.import("Vim.Buffer")

let s:repl_map = {
      \"ruby" : "irb",
      \"ruby-pry" : "pry",
      \"ruby-rails" : "bundle exec rails console",
      \"ruby-bundler" : "bundler console",
      \"elixir" : "iex",
      \"elixir-mix" : "iex -S mix",
      \"elixir-phoenix" : "iex -S mix phoenix.server",
      \"lisp" : "sbcl",
      \"python" : "python",
      \"elm" : "elm-repl",
      \"javascript" : "node",
      \}

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
  if terminalWindowNumber == 0
    let terminalWindowNumber = repl#open_repl(0)
  endif

  if terminalWindowNumber > 0
    execute terminalWindowNumber . "wincmd w"
    let @r = a:selection
    put r
    call feedkeys("a\r")
  endif
endfunction "}}}
function! repl#send_to_repl() "{{{
  let selection = join(getline(1,'$'), "\n")
  call repl#update_repl(selection)
endfunction "}}}
function! repl#send_visual_selection_to_repl() "{{{
  let selection = s:Vim.get_last_selected()
  call repl#update_repl(selection)
endfunction "}}}
function! repl#run_command_in_terminal(command, vertical) abort "{{{
  let currentBufferName = bufname(winbufnr(0))

  if a:vertical != 0
    execute 'vnew'
  else
    execute 'new'
  endif

  nmap <buffer> q :q<CR>
  call termopen(a:command)

  execute bufwinnr(currentBufferName) . "wincmd w"
endfunction "}}}
function! repl#open_repl(vertical) abort "{{{
  let replCommand = s:repl_map.get_command()
  if replCommand != ""
    call repl#run_command_in_terminal(replCommand, a:vertical)
    return repl#find_terminal_in_current_tab()
  endif
endfunction "}}}
function! s:repl_map.get_command() abort "{{{
  if &ft == 'ruby'
    return self.get_ruby_command()
  elseif &ft == 'elixir'
    return self.get_elixir_command()
  elseif &ft == 'lisp'
    return self.get_lisp_command()
  elseif &ft == 'python'
    return self.get_python_command()
  elseif &ft == 'elm'
    return self.get_elm_command()
  elseif &ft == 'javascript' || &ft == 'javascript.jsx'
    return self.get_javascript_command()
  else
    return ""
  endif
endfunction "}}}
function! s:repl_map.get_ruby_command() abort "{{{
  if executable('bundle') && filereadable('config/application.rb')
    return self['ruby-rails']
  elseif executable('bundle') && filereadable('Gemfile')
    return self['ruby-bundler']
  elseif executable('pry')
    return self['ruby-pry']
  else
    return self['ruby']
  endif
endfunction "}}}
function! s:repl_map.get_elixir_command() abort "{{{
  if executable('iex') && filereadable('mix.exs') && filereadable('deps/phoenix/mix.exs')
    return self['elixir-phoenix']
  elseif executable('iex') && filereadable('mix.exs')
    return self['elixir-mix']
  else
    return self['elixir']
  endif
endfunction "}}}
function! s:repl_map.get_lisp_command() abort "{{{
  return self['lisp']
endfunction "}}}
function! s:repl_map.get_python_command() abort "{{{
  return self['python']
endfunction "}}}
function! s:repl_map.get_elm_command() abort "{{{
  return self['elm']
endfunction "}}}
function! s:repl_map.get_javascript_command() abort "{{{
  return self['javascript']
endfunction "}}}

