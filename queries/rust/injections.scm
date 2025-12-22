; 告诉编辑器：view! 宏里面的内容是 HTML
(macro_invocation
  macro: (identifier) @macro_name
  (token_tree) @injection.content
  (#eq? @macro_name "view")
  (#set! injection.language "html"))
