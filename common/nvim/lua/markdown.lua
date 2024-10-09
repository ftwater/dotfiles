-- 使用 Packer 安装插件
return require('packer').startup(function(use)
    -- Packer 自我管理
    use 'wbthomason/packer.nvim'

    use {
        "ellisonleao/glow.nvim", 
        config = function()
            require("glow").setup()
        end,
    }
    -- Markdown 编辑和预览插件
    use 'plasticboy/vim-markdown'
    -- 用于 Markdown 表格对齐
    use {
        'godlygeek/tabular',
        config = function()
            vim.g.tabularize_2char_separator = 1 -- 两字符间隔
        end,
    }
    -- markdown-preview.nvim 需要使用 npm 进行安装并设置配置
    use {
        'iamcco/markdown-preview.nvim',
        run = 'cd app && npm install',
        config = function() -- `config` 替代 `setup`
            vim.g.mkdp_auto_start = 0 -- 自动开始预览
            vim.g.mkdp_auto_close = 1 -- 自动关闭预览
            vim.g.mkdp_refresh_slow = 0 -- 不延迟刷新预览
            vim.g.mkdp_command_for_global = 0 -- 不在全局命令中使用 mkdp
            vim.g.vim_markdown_folding_disabled = 1 -- 禁用折叠
            vim.g.vim_markdown_frontmatter = 1 -- 识别 YAML frontmatter
            vim.g.vim_markdown_new_list_item_indent = 0 -- 新列表项的缩进
            vim.g.vim_markdown_no_extensions_in_markdown = 1 -- 不在 Markdown 文件中识别扩展名
            vim.g.vim_markdown_strikethrough = 1 -- 支持删除线
        end,
    }

    -- 语法检查和自动完成插件
    use {
        'dense-analysis/ale',
        config = function()
            vim.g.ale_linters = {
                markdown = {'markdownlint'},
            }
            vim.g.ale_fixers = {
                markdown = {'prettier'},
            }
        end,

    }
    use {
        'neoclide/coc.nvim', 
        branch = 'release',
        config = function()
            vim.g.coc_global_extensions = {
                'coc-markdownlint',
                'coc-prettier',
            }
        end,
    }
end)
