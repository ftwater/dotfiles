-- 使用 Packer 安装插件
return require('packer').startup(function()
    -- Markdown 编辑和预览插件
    use 'plasticboy/vim-markdown'
    use 'godlygeek/tabular' -- 用于 Markdown 表格对齐
    use 'iamcco/markdown-preview.nvim' -- Markdown 实时预览插件

    -- 语法检查和自动完成插件
    use 'dense-analysis/ale'
    use {'neoclide/coc.nvim', branch = 'release'}
end)

-- Markdown 插件配置
vim.g.vim_markdown_folding_disabled = 1 -- 禁用折叠
vim.g.vim_markdown_frontmatter = 1 -- 识别 YAML frontmatter
vim.g.vim_markdown_new_list_item_indent = 0 -- 新列表项的缩进
-- vim.g.vim_markdown_auto_insert_bullets = 0 -- 不自动插入列表符号
vim.g.vim_markdown_no_extensions_in_markdown = 1 -- 不在 Markdown 文件中识别扩展名
vim.g.vim_markdown_strikethrough = 1 -- 支持删除线
-- vim.g.vim_markdown_edit_url_inplace = 0 -- 不在原地编辑链接

-- Tabular 插件配置
vim.g.tabularize_2char_separator = 1 -- 两字符间隔

-- Markdown 预览插件配置
vim.g.mkdp_auto_start = 1 -- 自动开始预览
vim.g.mkdp_auto_close = 1 -- 自动关闭预览
vim.g.mkdp_refresh_slow = 0 -- 不延迟刷新预览
vim.g.mkdp_command_for_global = 0 -- 不在全局命令中使用 mkdp

-- ALE 插件配置
vim.g.ale_linters = {
    markdown = {'markdownlint'},
}
vim.g.ale_fixers = {
    markdown = {'prettier'},
}

-- coc.nvim 插件配置
vim.g.coc_global_extensions = {
    'coc-markdownlint',
    'coc-prettier',
}
