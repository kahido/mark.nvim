-- user commands -----------------

vim.api.nvim_create_user_command("MarkSet", require("mark").MarkCurrentWord, {})
vim.api.nvim_create_user_command("MarkSelectedWord", require("mark").MarkSelectedWord, {})

-- mappings ----------------------

vim.keymap.set('n', '<leader>m', '<cmd>MarkSet<CR>', {desc = 'Mark current word key mapping.', noremap = true, silent = true })
vim.keymap.set('v', '<leader>m', '<cmd>MarkSet<CR>', {desc = 'Mark selected word key mapping.', noremap = true, silent = true })


-- Scenarios ---------------------

-- 1. use Mark on selected word
-- * color: first available
-- * regexp: selected

-- 2. use Mark with color on selected word
-- * color: selected
-- * regexp: selected

-- 3. use Mark empty
-- * color: clear color
-- * regexp: clear selected
--
-- 4. use Mark with  color
-- * color: clear selected
-- * regexp: clear selected
