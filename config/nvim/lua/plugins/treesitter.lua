return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- 1. Basic Settings
      opts.auto_install = false
      opts.ensure_installed = {}
      opts.sync_install = true

      -- 2. Add Local Parser Logic safely inside the opts function
      -- This ensures 'nvim-treesitter' is available when this runs
      opts.parsers = {
        -- Example: If you need to add a local python parser
        -- python = {
        --   install_info = {
        --     url = "~/path/to/tree-sitter-python",
        --     files = { "src/parser.c" },
        --     generate_requires_npm = false,
        --     requires_generate_from_grammar = false,
        --   },
        --   filetype = "py",
        -- },
      }
    end,
  },
}
