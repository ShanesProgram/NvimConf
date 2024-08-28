--###########
--# OPTIONS #
--###########
vim.opt.swapfile = false
vim.opt.number = true
vim.opt.showmatch = true
vim.opt.foldmethod = 'syntax'
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true

--##########
--# REMAPS #
--##########
vim.g.mapleader = " "

-- Save
vim.keymap.set("n", "<C-s>", vim.cmd.w)
-- Save Quit
vim.keymap.set("n", "<C-q>", vim.cmd.wq)

-- Open Directory View
vim.keymap.set("n", "<C-d>", vim.cmd.Ex)
vim.keymap.set("n", "<C-n>", vim.cmd.tabnew)


--##########
--# PACKER #
--##########
local function bootstrap_pckr()
    local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

    if not vim.uv.fs_stat(pckr_path) then
        vim.fn.system({
            'git',
            'clone',
            "--filter=blob:none",
            'https://github.com/lewis6991/pckr.nvim',
            pckr_path
        })
    end

    vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

require('pckr').add{
    
    {
        'Mofiqul/dracula.nvim',
        run = ":colorscheme dracula"
    },

    {
        'nvim-treesitter/nvim-treesitter',
        run = ":TSUpdate"
    },

    {
        'nvim-lualine/lualine.nvim',
        requires = { { "nvim-tree/nvim-web-devicons"} }
    },

    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        requires = { { 'nvim-lua/plenary.nvim'} }
    },

    {
        'akinsho/toggleterm.nvim'
    },

    {
        'akinsho/bufferline.nvim',
        requires = { { "nvim-tree/nvim-web-devicons" } }
    },

    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/nvim-cmp' },
    {
        'L3MON4D3/LuaSnip',
        run = "make install_jsregexp"
    },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },

    { 'anuvyklack/pretty-fold.nvim' },

    { 'm4xshen/autoclose.nvim' }
}

--#############
--# AUTOCLOSE #
--#############
require('autoclose').setup()

--#########
--# FOLDS #
--#########
require('pretty-fold').setup()


--###############
--# COLORSCHEME #
--###############
vim.cmd[[colorscheme dracula]]

--##############
--# TREESITTER #
--##############
require("nvim-treesitter.configs").setup {
    highlight = { enable = true }
}
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

--###########
--# LUALINE #
--###########
require('lualine').setup {
    options = {
        theme = 'dracula-nvim'
    }
}

--#############
--# TELESCOPE #
--#############
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-f>', builtin.find_files, {})

--##############
--# BUFFERLINE #
--##############
vim.opt.termguicolors = true
require("bufferline").setup {
    options = {
        diagnostics = "nvim_lsp",
        diagnostics_update_on_event = true,
        separator_style = "slant",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            return "("..count..")"
        end

    }
}

vim.keymap.set("n", "<C-Right>", vim.cmd.BufferLineCycleNext)
vim.keymap.set("n", "<C-Left>", vim.cmd.BufferLineCyclePrev)
vim.keymap.set("i", "<C-Right>", vim.cmd.BufferLineCycleNext)
vim.keymap.set("i", "<C-Left>", vim.cmd.BufferLineCyclePrev)
vim.keymap.set("n", "<C-c>", vim.cmd.bdelete)

--############
--# TERMINAL #
--############
require('toggleterm').setup {
    direction = 'horizontal',
    vim.keymap.set('n', '<C-/>', vim.cmd.ToggleTerm),
    vim.keymap.set('t', '<C-/>', vim.cmd.quit),
    vim.keymap.set('n', '<C-Up>', [[<Cmd>wincmd k<CR>]], opts),
    vim.keymap.set('t', '<C-Up>', [[<Cmd>wincmd k<CR>]], opts),
    vim.keymap.set('n', '<C-Down>', [[<Cmd>wincmd j<CR>]], opts),
    vim.keymap.set('t', '<C-Down>', [[<Cmd>wincmd j<CR>]], opts)
}

--##############
--# COMPLETION #
--##############

require("mason").setup()
require("luasnip.loaders.from_snipmate").lazy_load()
require("luasnip").setup()

require'cmp'.setup({
    snippet = {
        expand = function(args)
            require'luasnip'.lsp_expand(args.body)
        end,
    },
    window = {
        completion = require("cmp").config.window.bordered(),
        documentation = require("cmp").config.window.bordered()
    },
    mapping = require'cmp'.mapping.preset.insert({
        ['<C-b>'] = require'cmp'.mapping.scroll_docs(-4),
        ['<C-f>'] = require'cmp'.mapping.scroll_docs(4),
        ['<C-Space>'] = require'cmp'.mapping.complete(),
        ['<C-e>'] = require'cmp'.mapping.abort(),
        ['<CR>'] = require'cmp'.mapping.confirm({ select = true }),
    }),
    sources = require'cmp'.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip', option = { show_autosnippets = true } },
    }, {
        { name = 'buffer' },
    })
})

require'cmp'.setup.cmdline({ '/', '?' }, {
    mapping = require'cmp'.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

require'cmp'.setup.cmdline(':', {
    mapping = require'cmp'.mapping.preset.cmdline(),
    sources = require'cmp'.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

require("mason").setup()
require("mason-lspconfig").setup()

require("lspconfig").lua_ls.setup {}
require("lspconfig").clangd.setup {}
require("lspconfig").rust_analyzer.setup {}
require("lspconfig").html.setup {}
