lua << EOF
local nvim_lsp = require'nvim_lsp'
nvim_lsp.gopls.setup{}
nvim_lsp.rls.setup{}
nvim_lsp.tsserver.setup{}
EOF
