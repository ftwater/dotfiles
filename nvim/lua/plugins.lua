return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'terryma/vim-multiple-cursors'
  use 'vim-airline/vim-airline'
  use 'jiangmiao/auto-pairs'
  use 'easymotion/vim-easymotion'
end)
