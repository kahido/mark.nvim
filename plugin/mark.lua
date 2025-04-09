-- user commands -----------------

vim.api.nvim_create_user_command("MarkSet", require("mark").MarkCurrentWord, {})

-- mappings ----------------------

vim.keymap.set('n', '<leader>m', '<cmd>MarkSet<CR>', {desc = 'Mark current word key mapping.', noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>m', require("mark").MarkCurrentWord, {desc = 'Mark current word key mapping.', remap = false})
