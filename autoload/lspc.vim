function! lspc#config()

endfunction

let s:root = expand('<sfile>:p:h:h')

function! lspc#output(log)
  if s:output_buffer == v:null || !nvim_buf_is_loaded(s:output_buffer)
    let s:output_buffer = nvim_create_buf(v:true, v:false)
    call nvim_buf_set_name(s:output_buffer, "[LSPC Output]")
    call nvim_buf_set_option(s:output_buffer, "buftype", "nofile")
    call nvim_buf_set_option(s:output_buffer, "buflisted", v:true)
    call nvim_buf_set_option(s:output_buffer, "noswapfile", v:true)
  endif

  let l:line = nvim_buf_line_count(s:output_buffer) - 1
  call nvim_buf_set_lines(s:output_buffer, l:line, l:line, v:true, a:log)
endfunction

function! s:echo_handler(job_id, data, name)
  let l:log = "[LSPC][" . a:name ."]. Data: " . string(a:data)
  lspc#output([l:log])
endfunction

function! lspc#init()
  let l:binpath = s:root . '/target/debug/lspc'

  let s:job_id = jobstart([l:binpath], {
        \ 'rpc': v:true,
        \ 'on_stderr': function('s:echo_handler'),
        \ 'on_exit':   function('s:echo_handler'),
        \ })
  if s:job_id == -1
    echo "[LSPC] Cannot execute " . l:binpath
  endif
endfunction

function! lspc#destroy()
  call jobstop(s:job_id)
endfunction

function! lspc#current_file_type()

endfunction

function! lspc#start_lang_server()
  call rpcnotify(s:job_id, 'start_lang_server')
endfunction

function! lspc#hello_from_the_other_side()
  call rpcnotify(s:job_id, 'hello')
endfunction

function! lspc#debug()
  echo "Output Buffer: " . s:output_buffer
endfunction
