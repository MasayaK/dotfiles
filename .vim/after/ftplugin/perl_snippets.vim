if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet sub sub ".st."FunctionName".et." {<CR>".st.et."<CR>}"
exec "Snippet class package ".st."ClassName".et.";<CR><CR>".st.et.st."ParentClass".et.st.et.";<CR><CR>sub new {<CR>my \$class = shift;<CR>\$class = ref \$class if ref \$class;<CR>my $self = bless {}, \$class;<CR>\$self;<CR>}<CR><CR>1;"
exec "Snippet xfore ".st."expression".et." foreach @".st."array".et.";"
exec "Snippet xwhile ".st."expression".et." while ".st."condition".et.";"
exec "Snippet xunless ".st."expression".et." unless ".st."condition".et.";"
exec "Snippet slurp my $".st."var".et.";<CR><CR>{ local $/ = undef; local *FILE; open FILE, \"<".st."file".et.">\"; $".st."var".et." = <FILE>; close FILE }"
exec "Snippet if if (".st.et.") {<CR>".st.et."<CR>}"
exec "Snippet elsif elsif (".st.et.") {<CR>".st.et."<CR>}"
exec "Snippet unless unless (".st.et.") {<CR>".st.et."<CR>}"
exec "Snippet ife if (".st.et.") {<CR>".st.et."<CR>} else {<CR>".st.et."<CR>}"
exec "Snippet for for (my \$".st."var".et." = 0; \$".st."var".et." < ".st."expression".et."; \$".st."var".et."++) {<CR>".st.et."<CR>}"
exec "Snippet fore foreach my \$".st."var".et." (@".st."array".et.") {<CR>".st.et."<CR>}"
exec "Snippet eval eval {<CR>".st.et."<CR>};<CR>if ($@) {<CR>".st.et."<CR>}"
exec "Snippet while while (".st.et.") {<CR>".st.et."<CR>}"
exec "Snippet xif ".st."expression".et." if ".st."condition".et.";"
