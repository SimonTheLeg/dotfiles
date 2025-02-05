-- Plugins to use inside nvim as well as vscode
Plugins_to_install = {
  { 'sheerun/vim-polyglot' },
  { 'tpope/vim-commentary' },
  { 'wincent/terminus' },
  { 'vim-scripts/ReplaceWithRegister' },
  { 'tpope/vim-abolish' },
  { 'tpope/vim-surround' },
  { 'AndrewRadev/splitjoin.vim' },
  { 'jeetsukumaran/vim-indentwise' },
  { 'terryma/vim-multiple-cursors' },
  { 'tpope/vim-obsession' },
}

-- Plugins to only use inside nvim
if vim.g.vscode == nil then
  nvim_only_plugins = {
    -- always load colorscheme first, as some plugins depend on it
    {
      'navarasu/onedark.nvim',
      config = require("plugins.onedark").Setup
    },
    { 'easymotion/vim-easymotion' },
    { 'hashivim/vim-hashicorp-tools' },
    { 'rust-lang/rust.vim' },
    { 'junegunn/fzf.vim' },
    { 'junegunn/gv.vim' },
    {
      "NeogitOrg/neogit",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "nvim-telescope/telescope.nvim",
      },
      config = require("plugins.neogit").Setup
    },
    { 'iamcco/markdown-preview.nvim' },
    { 'Chiel92/vim-autoformat' },
    { 'itchyny/lightline.vim' },
    { 'christianrondeau/vim-base64' },
    { 'chuling/vim-equinusocio-material' },
    { 'PeterRincker/vim-searchlight' },
    { '907th/vim-auto-save' },
    { 'jlanzarotta/bufexplorer' },
    { 'pbogut/fzf-mru.vim' },
    { 'christoomey/vim-tmux-navigator' },
    { 'nvim-lua/popup.nvim' },
    {
      'nvim-telescope/telescope.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'BurntSushi/ripgrep',
      }
    },
    { 'ekalinin/Dockerfile.vim', ft = "Dockerfile" },
    {
      'luukvbaal/statuscol.nvim',
      config = require("plugins.statuscol").Setup
    },
    {
      'lewis6991/gitsigns.nvim',
      config = require("plugins.gitsigns").Setup
    }
  }
  local function concattables(t1, t2)
    for i = 1, #t2 do
      t1[#t1 + 1] = t2[i]
    end
    return t1
  end

  Plugins_to_install = concattables(Plugins_to_install, nvim_only_plugins)
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
