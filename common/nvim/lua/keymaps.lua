-- === base key map ===
-- === no leader key map ===
-- --- nmap ---
-- ;映射为: 进入命令模式
vim.api.nvim_set_keymap('n', 'nl', ':nohlsearch<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', 'J', '3j', {noremap = true})
vim.api.nvim_set_keymap('n', 'K', '3k', {noremap = true})
vim.api.nvim_set_keymap('n', 'H', '^', {noremap = true})
vim.api.nvim_set_keymap('n', 'L', '$', {noremap = true})

-- ---imap---
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', {noremap = true})

-- ---vmap---
vim.api.nvim_set_keymap('v', 'jk', '<ESC>', {noremap = true})
vim.api.nvim_set_keymap('v', 'J', '3j', {noremap = true})
vim.api.nvim_set_keymap('v', 'K', '3k', {noremap = true})
vim.api.nvim_set_keymap('v', 'H', '^', {noremap = true})
vim.api.nvim_set_keymap('v', 'L', '$', {noremap = true})

-- === leader key map ===
vim.g.mapleader = ' ' 
vim.g.EasyMotion_leader_key = ' '
vim.api.nvim_set_keymap('n', '<SPACE>s', '<Plug>(easymotion-prefix)s', {noremap = false})
vim.api.nvim_set_keymap('n', '<SPACE>b', '<Plug>(easymotion-bw)', {noremap = false})
vim.api.nvim_set_keymap('n', '<SPACE>w', '<Plug>(easymotion-w)', {noremap = false})
vim.api.nvim_set_keymap('n', '<leader>y', '"+', {noremap = false})
