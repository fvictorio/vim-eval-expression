" taken from tommcdo/vim-exchange
function! s:restore_reg(name, reg)
	silent! call setreg(a:name, a:reg[0], a:reg[1])
endfunction

" taken from tommcdo/vim-exchange
function! s:save_reg(name)
	try
		return [getreg(a:name), getregtype(a:name)]
	catch /.*/
		return ['', '']
	endtry
endfunction

" taken from tommcdo/vim-exchange
function! s:create_map(mode, lhs, rhs)
	if !hasmapto(a:rhs, a:mode)
		execute a:mode.'map '.a:lhs.' '.a:rhs
	endif
endfunction

function! s:eval_expression(type, ...)
	let reg = s:save_reg('"')
	let reg_star = s:save_reg('*')
	let reg_plus = s:save_reg('+')
	let reg_zeta = s:save_reg('z')

  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  elseif a:type ==# 'line'
    normal! yy
  else
    " redraw so that the error is not hidden when using visual mode
    redraw
    echom "[vim-eval-expression] Object type not supported: " . a:type
    return
  endif

  let expr_to_eval = trim(@@)

  try
    let @z = eval(expr_to_eval)

    if a:type ==# 'v'
      normal! `<v`>"zp
    elseif a:type ==# 'char'
      normal! `[v`]"zp
    elseif a:type ==# 'line'
      normal! V"zp
    else
      throw "[vim-eval-expression] Assertion error, only visual and char modes are supported, please report this"
    endif
  " catch all errors except the one thrown by our code
  catch /\v^(\[vim-eval-expression\])@!/
    " redraw so that the error is not hidden when using visual mode
    redraw
    echom "[vim-eval-expression] Error evaluating: '".expr_to_eval."' Reason: ".v:exception
  finally
    call s:restore_reg('"', reg)
    call s:restore_reg('*', reg_star)
    call s:restore_reg('+', reg_plus)
    call s:restore_reg('z', reg_zeta)
  endtry
endfunction

nnoremap <silent> <expr> <Plug>(EvalExpression) ':<C-u>set operatorfunc=<SID>eval_expression<CR>'.(v:count1 == 1 ? '' : v:count1).'g@'
vnoremap <silent> <Plug>(EvalExpression) :<C-u>call <SID>eval_expression(visualmode(), 1)<CR>
nnoremap <silent> <expr> <Plug>(EvalExpressionLine) ':<C-u>set operatorfunc=<SID>eval_expression<CR>'.(v:count1 == 1 ? '' : v:count1).'g@_'

call s:create_map('n', '<leader>=', '<Plug>(EvalExpression)')
call s:create_map('x', '<leader>=', '<Plug>(EvalExpression)')
call s:create_map('n', '<leader>==', '<Plug>(EvalExpressionLine)')
