"=============================================================================
" File    : autoload/unite/sources/outline/defaults/terraform.vim
" Author  : umiyosh <yumino99@gmail.com>
" Updated : 2016-11-22
"
" Licensed under the MIT license:
" http://www.opensource.org/licenses/mit-license.php
"
"=============================================================================

" Default outline info for terraform tf file
" Version: 0.1.0

function! unite#sources#outline#defaults#terraform#outline_info() abort
  return s:outline_info
endfunction

let s:Util = unite#sources#outline#import('Util')

"-----------------------------------------------------------------------------
" Outline Info

let s:outline_info = {
      \ 'heading-1': s:Util.shared_pattern('sh', 'heading-1'),
      \ 'heading'  : '^\s*\%(\w\+\s*()\|resource\>\)',
      \
      \ 'skip': {
      \   'header': s:Util.shared_pattern('sh', 'header'),
      \ },
      \
      \ 'highlight_rules': [
      \   { 'name'     : 'comment',
      \     'pattern'  : '/#.*/' },
      \   { 'name'     : 'resource',
      \     'pattern'  : '/\h\w*/' },
      \ ],
      \}

function! s:outline_info.create_heading(which, heading_line, matched_line, context) abort
  let l:heading = {
        \ 'word' : a:heading_line,
        \ 'level': 0,
        \ 'type' : 'generic',
        \ }

  if a:which ==# 'heading-1' && a:heading_line =~# '^\s*#'
    let l:m_lnum = a:context.matched_lnum
    let l:heading.type = 'comment'
    let l:heading.level = s:Util.get_comment_heading_level(a:context, l:m_lnum, 5)
  elseif a:which ==# 'heading'
    let l:heading.level = 4
    let l:heading.type = 'resource'
    let l:heading.word = substitute(l:heading.word, '\s*\((.*)\s*\)\={.*$', '', '')
  endif

  if l:heading.level > 0
    return l:heading
  else
    return {}
  endif
endfunction

