return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'terryma/vim-multiple-cursors'
  use 'vim-airline/vim-airline'
  use 'jiangmiao/auto-pairs'
  use 'easymotion/vim-easymotion'
  -- Markdown 编辑和预览插件
  use {
      'plasticboy/vim-markdown',
      config = function()
        vim.g.vim_markdown_strikethrough = 1 -- 支持删除线
        vim.g.vim_markdown_folding_disabled = 1 -- 禁用折叠
      end
  }
  use 'godlygeek/tabular' -- 用于 Markdown 表格对齐
  use 'iamcco/markdown-preview.nvim' -- Markdown 实时预览插件

  -- 语法检查和自动完成插件
  use 'dense-analysis/ale'
  use {'neoclide/coc.nvim', branch = 'release'}
end)

