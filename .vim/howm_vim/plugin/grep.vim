"
" grep.vim - grep �� Vim Script �ˤ�������
"
" Last Change: 04-Jun-2006.
" Written By: Kouichi NANASHIMA <claymoremine@anet.ne.jp>

scriptencoding euc-jp

" �ҤȤޤ� HInr ���ǡ�
function! GrepSearch(searchWord, searchPath, options)
  let searchWord = escape(a:searchWord, "~@=")
  if a:options =~ "\\CF"
    let searchWord = "\\V".escape(searchWord, "\\")
  else
    let searchWord = "\\v".searchWord
  endif
  if a:options !~ "\\Ci"
    let searchWord = "\\C".searchWord
  endif

  silent! new
  silent! setlocal bt=nofile bh=delete noswf binary
  let pathList = strpart(a:searchPath, match(a:searchPath, "\\S"))
  let idx = match(pathList, "\\s")
  if idx != -1
    let file = strpart(pathList, 0, idx)
    let pathList = strpart(pathList, idx)
  else
    let file = pathList
    let pathList = ""
  endif
  let retval = ""
  while file != ""
    let file = expand(file)
    if isdirectory(file)
      if file !~ "[\\/]$"
        let file = file."/"
      endif
      let file = file."*"
      let file = substitute(expand(file), "\<NL>", " ", "g")
      let pathList = file." ".pathList
    elseif filereadable(file)
      if has('win32') && substitute(file, '.*\.\(.\{-}\)', '\1', '') == 'lnk'
        " Win32 �Υ��硼�ȥ��åȤ��ɤ�����ν���
        silent! exe "new ".file
        let linkto = expand("%:p")
        silent! close
        if file != linkto
          let file = linkto
          continue
        endif
      endif
      silent! exe "$r ".file
      silent! 1delete _
			let retval = retval.GrepBuffer(searchWord, file, 1, 1)
      silent! g/^/d
    endif
    let pathList = strpart(pathList, match(pathList, "\\S"))
    let idx = match(pathList, "\\s")
    if idx != -1
      let file = strpart(pathList, 0, idx)
      let pathList = strpart(pathList, idx)
    else
      let file = pathList
      let pathList = ""
    endif
  endwhile
  silent! close

  return retval
endfunction

" ���߳����Ƥ���Хåե���򸡺�����
" searchWord ���ޤޤ�Ƥ���Ԥ���Ф��롣
" �ե�����ɽ���ե饰�����ֹ�ɽ���ե饰�� 0 �ʳ��ξ���
" ������̤ˤ��줾�측���ե�����ȹ��ֹ��ɽ�����롣
"
" - searchWord ������
" - file �����ե�����ʸ�����̤�ɽ����
" - bFile �ե�����ɽ���ե饰
" - bLine ���ֹ�ɽ���ե饰
" 
" - return �������
function! GrepBuffer(searchWord, file, bFile, bLine)
	let retval = ''
	call cursor(1, 1)
	if getline(1) =~ a:searchWord
		let line = 1
	else
		let line = search(a:searchWord, "W")
	endif
	while line != 0
		let retLine = ''
		" ���ֹ��ɲ�
		if a:bFile
			let retLine = retLine.substitute(a:file, "\\\\", "/", "g").':'
		endif
		" �����ե������ɲ�
		if a:bLine
			let retLine = retLine.line.':'
		endif
		let retLine = retLine.getline(line)."\<NL>"
		let retval = retval.retLine
		silent! normal! $
		let line = search(a:searchWord, "W")
	endwhile
	return retval
endfunction
