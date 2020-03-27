syntax match valid_insn   /C0:\s\+\d\+\s\+\[1\].*/
syntax match invalid_insn /C0:\s\+\d\+\s\+\[0\].*/
hi valid_insn ctermfg=cyan cterm=bold
hi link invalid_insn Comment
