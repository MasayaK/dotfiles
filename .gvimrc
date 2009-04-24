
scriptencoding euc-jp

" ���顼���������� {{{1

call RandomColorScheme()
set t_vb=

" }}}1

""" �ե�������� {{{1
"
if has('win32')
  " Windows��
  set guifont=M+2VM+IPAG_circle:h13
  set printfont=M+2VM+IPAG_circle:h13
"   set guifont=Osaka������:h13
  " �Դֳ֤�����
  set linespace=1
  " ������UCSʸ��������ư��¬���Ʒ���
  if has('kaoriya')
    set ambiwidth=auto
  endif
elseif has('mac')
  set guifont=Osaka������:h14
elseif has('xfontset')
  " UNIX�� (xfontset�����)
"   set guifontset=a14,r14,k14
  set guifont=Monospace\ 12
endif

""" }}}1

""" ������ɥ��˴ؤ������� {{{1
"
" ������ɥ�����
set columns=90
" ������ɥ��ι⤵
set lines=45
" ���ޥ�ɥ饤��ι⤵(GUI���ѻ�)
set cmdheight=1

""" }}}1

""" ���ܸ����Ϥ˴ؤ������� {{{1
"
if has('multi_byte_ime') || has('xim')
  " IME ON���Υ�������ο�������(������:��)
  highlight CursorIM guibg=Purple guifg=NONE
  " �����⡼�ɡ������⡼�ɤǤΥǥե���Ȥ�IME��������
  set iminsert=0 imsearch=0
  if has('xim') && has('GUI_GTK')
    " XIM�����ϳ��ϥ���������:
    " ������ s-space ��Shift+Space�ΰ�̣��kinput2+canna������
    "set imactivatekey=s-space
  endif
  " �����⡼�ɤǤ�IME���֤򵭲������ʤ���硢���ԤΥ����Ȥ���
  "inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif

""" }}}1

""" �Х��ʥ��Խ�(xxd)�⡼�� {{{1
"��vim -b �Ǥε�ư���⤷���� *.bin �ե�����򳫤���ȯư��
"
"augroup BinaryXXD
"  autocmd!
"  autocmd BufReadPre  *.bin let &binary =1
"  autocmd BufReadPost * if &binary | silent %!xxd -g 1
"  autocmd BufReadPost * set ft=xxd | endif
"  autocmd BufWritePre * if &binary | %!xxd -r | endif
"  autocmd BufWritePost * if &binary | silent %!xxd -g 1
"  autocmd BufWritePost * set nomod | endif
"augroup END

""" }}}1

" vim: fdm=marker : fen :
