if exists("b:__C_XPT_VIM__")
  finish
endif
let b:__C_XPT_VIM__ = 1



runtime ftplugin/_common/common.xpt.vim
runtime ftplugin/_comment_c_like/cmt.xpt.vim


let s:f = g:XPTfuncs()
let s:v = g:XPTvars()



call XPTemplate('t2', [
      \ '`b^ `^\`d\^ \`\^==\^ \`a\^^', 
      \])


call XPTemplate("inc", 'include <`^.h>')
call XPTemplate("ind", 'include "`^fileRoot()^.h"')

call XPTemplate("assert", [
      \'assert(`isTrue^, "`text^");', 
      \''])

call XPTemplate("once", [
      \'#ifndef `symbol^headerSymbol()^',
      \'#define `symbol^',
      \'`cursor^',
      \'#endif /* `symbol^ */',
      \''])

call XPTemplate("main", [
      \'  int',
      \'main(int argv, char **args)',
      \'{',
      \'  `cursor^',
      \'  return 0;',
      \'}',
      \''])

call XPTemplate("fun", [
      \"  `int^", 
      \"`name^(`a^^)", 
      \"{", 
      \"  `cursor^", 
      \"}"
      \])

call XPTemplate("ifndef", [
      \"ifndef `v^", 
      \"#    define `v^", 
      \"", 
      \"`cursor^", 
      \"#endif /* `v^ */"
      \])

call XPTemplate("while0", ""
      \."do {\n"
      \."  `cursor^\n"
      \."} while (0)")

call XPTemplate("while1", [
      \'while (1) {', 
      \'  `cursor^',
      \'}'
      \])


call XPTemplate("for", ""
      \."for (`i^ = `0^; `i^ < `len^; ++`i^){\n"
      \."  `cursor^\n"
      \."}")

call XPTemplate("forr", ""
      \."for (`i^ = `n^; `i^ >`^=^ `end^; --`i^){\n"
      \."  `cursor^\n"
      \."}")

call XPTemplate('forever', [
      \ 'for (;;) `^/* void */^;'
      \])

call XPTemplate("if", ""
      \."if (`^){\n"
      \."  `cursor^\n"
      \."}")

call XPTemplate("ifn", ""
      \."if (NULL == `^){\n"
      \."  `cursor^\n"
      \."}")

call XPTemplate("ifnn", ""
      \."if (NULL != `^){\n"
      \."  `cursor^\n"
      \."}")

call XPTemplate("if0", ""
      \."if (0 == `^){\n"
      \."  `cursor^\n"
      \."}")

call XPTemplate("ifn0", ""
      \."if (0 != `^){\n"
      \."  `cursor^\n"
      \."}")

call XPTemplate("ifel", "
      \if (`^){\n
      \  `^\n
      \} else {\n
      \  `cursor^\n
      \}")


call XPTemplate("cmt", "
      \/**\n
      \* @author : `$author^ | `$email^\n
      \* @description\n
      \*     `cursor^\n
      \* @return {`int^} `desc^\n
      \*/")


call XPTemplate("para", {'syn' : 'comment'}, "
      \@param {`Object^} `name^ `desc^")


call XPTemplate("filehead", [
      \'/**-------------------------/// `sum^ \\\---------------------------',
      \' *',
      \' * <b>`function^</b>',
      \' * @version : `1.0^',
      \' * @since : `strftime("%Y %b %d")^',
      \' * ',
      \' * @description :',
      \' *   `cursor^',
      \' * @usage : ',
      \' * ',
      \' * @author : `$author^ | `$email^',
      \' * @copyright `.com.cn^ ',
      \' * @TODO : ',
      \' * ',
      \' *--------------------------\\\ `sum^ ///---------------------------*/',
      \''])

call XPTemplate('switch', [
      \ 'switch (`^) {',
      \ '  case `_^ :',
      \ '    `^',
      \ '    break;',
      \ '  `...^', 
      \ '  case `_^ :',
      \ '    `^',
      \ '    break;',
      \ '  `...^', 
      \ '',
      \ '  default:',
      \ '    `cursor^',
      \ '}'
      \])



