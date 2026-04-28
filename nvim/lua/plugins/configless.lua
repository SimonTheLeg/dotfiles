local shared = {
  { 'tpope/vim-commentary' },
  { 'wincent/terminus' },
  { 'tpope/vim-surround' },
  { 'AndrewRadev/splitjoin.vim' },
  { 'jeetsukumaran/vim-indentwise' },
  { 'tpope/vim-sleuth' }, -- correctly detect indents
  { 'terryma/vim-multiple-cursors' },
  { 'tpope/vim-obsession' },
  { 'chaoren/vim-wordmotion' },
  -- allow for text surrounding
  { 'kylechui/nvim-surround' },
}

local nvim_only = {
  { 'easymotion/vim-easymotion' },
  { 'nvim-tree/nvim-tree.lua',         opts = {} },
  { 'hashivim/vim-hashicorp-tools' },
  { 'rust-lang/rust.vim' },
  { 'junegunn/fzf.vim' },
  { 'junegunn/gv.vim' },
  { 'iamcco/markdown-preview.nvim' },
  { 'Chiel92/vim-autoformat' },
  { 'christianrondeau/vim-base64' },
  { 'chuling/vim-equinusocio-material' },
  { 'PeterRincker/vim-searchlight' },
  { 'jlanzarotta/bufexplorer' },
  {
    'pbogut/fzf-mru.vim',
    dependencies = {
      'junegunn/fzf'
    }
  },
  { 'christoomey/vim-tmux-navigator' },
  { 'nvim-lua/popup.nvim' },
  { 'nvim-tree/nvim-web-devicons' },
  { 'ekalinin/Dockerfile.vim',       ft = "Dockerfile" },
  { 'github/copilot.vim' },
}

if vim.g.vscode then
  return shared
end

for _, v in ipairs(nvim_only) do
  shared[#shared + 1] = v
end

return shared
