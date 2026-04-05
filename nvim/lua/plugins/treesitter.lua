return {
  {
    'nvim-treesitter/nvim-treesitter',
    cond = not vim.g.vscode,
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install({
        "lua",
        "vim",
        "vimdoc",
        "bash",
        "go",
        "python",
        "rust",
        "javascript",
        "typescript",
        "json",
        "yaml",
        "toml",
        "markdown",
        "markdown_inline",
        "nix",
        "hcl",
        "dockerfile",
        "fish",
        "kdl",
      })

      -- Treesitter highlighting (built into Neovim 0.12+)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })

      -- Treesitter indentation (skip nix where it breaks spacing)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          if args.match ~= 'nix' then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

    end,
  },
}
