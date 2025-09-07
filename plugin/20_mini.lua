local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Step one ===================================================================
now(function() -- colorscheme
  -- vim.cmd.colorscheme("minihues-slate")
  -- vim.cmd.colorscheme('minihues-blue')
  -- vim.cmd.colorscheme('minihues-purple')
end)

now(function() -- mini.basics
  require("mini.basics").setup({
    options = { extra_ui = false, win_borders = "bold" },
    mappings = { windows = true, move_with_alt = true },
    autocommands = { relnum_in_visual_mode = true },
  })
end)

now(function() -- mini.icons
  require("mini.icons").setup({
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= "scm" and suf3 ~= "txt" and suf3 ~= "yml" and suf4 ~= "json" and suf4 ~= "yaml"
    end,
  })
  later(MiniIcons.mock_nvim_web_devicons)
  later(MiniIcons.tweak_lsp_kind)
end)

now(function() -- mini.notify
  local predicate = function(notif)
    if not (notif.data.source == "lsp_progress" and notif.data.client_name == "lua_ls") then
      return true
    end
    -- Filter out some LSP progress notifications from 'lua_ls'
    return notif.msg:find("Diagnosing") == nil and notif.msg:find("semantic tokens") == nil
  end
  local custom_sort = function(notif_arr)
    return MiniNotify.default_sort(vim.tbl_filter(predicate, notif_arr))
  end

  require("mini.notify").setup({
    content = { sort = custom_sort },
    window = { max_width_share = 0.75 },
  })
  vim.notify = MiniNotify.make_notify()
end)

now(function() -- mini.sessions
  require("mini.sessions").setup()
end)

now(function() -- mini.starter
  local starter = require("mini.starter")
  starter.setup({
    -- Default values with exception of '-' as I use it to open mini.files.
    query_updaters = "abcdefghijklmnopqrstuvwxyz0123456789_.",

    -- stylua: ignore
    items = {
      starter.sections.sessions(5, true),
      starter.sections.recent_files(3, false, false),
      {
        { name = "Mason",         action = "Mason",            section = "Updaters"},
        { name = "Update deps",   action = "DepsUpdate",       section = "Updaters"},
        { name = "New Meeting",   action = "ZkNewMeeting",     section = "Builtin actions"},
        { name = "Visited files", action = "Pick visit_paths", section = "Builtin actions"},
        { name = "Quit Neovim",   action = "qall",             section = "Builtin actions"},
      },
    },

    header = function()
      local banner = [[

      ████ ██████           █████      ██
     ███████████             █████ 
     █████████ ███████████████████ ███   ███████████
    █████████  ███    █████████████ █████ ██████████████
   █████████ ██████████ █████████ █████ █████ ████ █████
 ███████████ ███    ███ █████████ █████ █████ ████ █████
██████  █████████████████████ ████ █████ █████ ████ ██████

  ]]
      local msg = Config.greeting()
      local n = math.floor((70 - msg:len()) / 2)
      return banner .. Config.pad(msg, n)
    end,

    -- Fortune slows startup by about 10ms ... ugh
    footer = Config.fortune(),
    -- footer = "",
  })
end)

now(function() -- mini.statusline
  require("mini.statusline").setup({
    use_icons = true,
    content = {
      inactive = function()
        local pathname = Config.section_pathname({ trunc_width = 120 })
        return MiniStatusline.combine_groups({
          { hl = "MiniStatuslineInactive", strings = { pathname } },
        })
      end,
      active = function()
        -- stylua: ignore start
        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
        local git           = MiniStatusline.section_git({ trunc_width = 40 })
        local diff          = MiniStatusline.section_diff({ trunc_width = 80 })
        local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 60 })
        local lsp           = MiniStatusline.section_lsp({ trunc_width = 40 })
        local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 100 })
        local filetype      = Config.section_filetype({ trunc_width = 70 })
        local location      = Config.section_location({ trunc_width = 120 })
        local search        = Config.section_searchcount({ trunc_width = 80 })
        local pathname      = Config.section_pathname({
          trunc_width = 100,
          filename_hl = "MiniStatuslineFilename",
          modified_hl = "MiniStatuslineFilenameModified" })

          -- Usage of `MiniStatusline.combine_groups()` ensures highlighting and
          -- correct padding with spaces between groups (accounts for 'missing'
          -- sections, etc.)
          return MiniStatusline.combine_groups({
            { hl = mode_hl,                   strings = { mode:upper() } },
            { hl = 'MiniStatuslineDevinfo',   strings = { git, diff } },
            '%<', -- Mark general truncate point
            { hl = 'MiniStatuslineDirectory', strings = { pathname } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineFileinfo',  strings = { diagnostics, filetype, lsp } },
            { hl = mode_hl,                   strings = { search .. location } },
            { hl = 'MiniStatuslineDirectory', strings = {} },
          })
        -- stylua: ignore end
      end,
    },
  })
end)

now(function() -- mini.tabline
  require("mini.tabline").setup()
end)

-- Step two =================================================================
later(function() -- mini.extra
  require("mini.extra").setup()
end)

later(function() -- mini.ai
  local ai = require("mini.ai")
  local extra = require("mini.extra")
  ai.setup({
    n_lines = 500,
    custom_textobjects = {
      F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      o = ai.gen_spec.treesitter({
        a = { "@block.outer", "@loop.outer", "@conditional.outer" },
        i = { "@block.inner", "@loop.inner", "@conditional.inner" },
      }),
      B = extra.gen_ai_spec.buffer(),
      D = extra.gen_ai_spec.diagnostic(),
      I = extra.gen_ai_spec.indent(),
      L = extra.gen_ai_spec.line(),
      N = extra.gen_ai_spec.number(),
    },
  })
end)

later(function() -- mini.align
  require("mini.align").setup()
end)

later(function() -- mini.animate
  require("mini.animate").setup({ cursor = { enable = false }, scroll = { enable = false } })
end)

later(function() -- mini.bracketed
  require("mini.bracketed").setup()

  local clues = {}
  for target, opts in pairs(MiniBracketed.config) do
    local lower_suffix = opts.suffix
    local upper_suffix = opts.suffix:upper()
    local replacements = {
      ["["] = { old = "first", new = "forward" },
      ["]"] = { old = "last", new = "backward" },
    }

    for bracket, pattern in pairs(replacements) do
      -- Use hydra mode for all bracketed targets
      table.insert(clues, { mode = "n", keys = bracket .. lower_suffix, postkeys = bracket })
      table.insert(clues, { mode = "n", keys = bracket .. upper_suffix, postkeys = bracket })

      -- Make uppercase navigate in other direction instead of first/last
      local map = vim.fn.maparg(bracket .. upper_suffix, "n", false, true)
      local new_rhs = map.rhs:gsub(pattern.old, pattern.new)
      local new_desc = map.desc:gsub(pattern.old, pattern.new)
      vim.keymap.set("n", bracket .. upper_suffix, new_rhs, { desc = new_desc })
    end
  end

  -- These will be used later when mini.clues is setup
  _G.Config.bracketed_clues = clues
end)

later(function() -- mini.bufremove
  require("mini.bufremove").setup()
end)

later(function() -- mini.clue
  local clue = require("mini.clue")
  clue.setup({
    clues = {
      -- Config.surround_clues,
      Config.bracketed_clues,
      Config.leader_group_clues,
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers({ show_contents = true }),
      clue.gen_clues.windows({ submode_resize = true }),
      clue.gen_clues.z(),
    },
    triggers = {
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },
      { mode = "n", keys = [[\]] }, -- mini.basics
      { mode = "n", keys = "[" }, -- mini.bracketed
      { mode = "n", keys = "]" },
      { mode = "x", keys = "[" },
      { mode = "x", keys = "]" },
      { mode = "i", keys = "<C-x>" }, -- built-in completion
      { mode = "n", keys = "g" }, -- `g` key
      { mode = "x", keys = "g" },
      { mode = "n", keys = "'" }, -- marks
      { mode = "n", keys = "`" },
      { mode = "x", keys = "'" },
      { mode = "x", keys = "`" },
      { mode = "n", keys = '"' }, -- registers
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },
      { mode = "n", keys = "s" }, -- surround
      { mode = "n", keys = "<C-w>" }, -- windows
      { mode = "n", keys = "z" }, -- folds
      { mode = "x", keys = "z" },
    },
    window = {
      delay = 300,
      config = { width = "auto" },
    },
  })
end)

later(function() -- mini.colors
  require("mini.colors").setup()
end)

later(function() -- mini.comment
  require("mini.comment").setup()
end)

later(function() -- mini.completion
  -- I want to like mini.completion but I cannot tolerate the lagginess and
  -- flickering I get when using the out of box experience.
  require("mini.completion").setup({
    lsp_completion = { source_func = "omnifunc", auto_setup = false },
  })
  local on_attach = function(args)
    vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
  end
  vim.api.nvim_create_autocmd("LspAttach", { callback = on_attach })
  vim.lsp.config("*", { capabilities = MiniCompletion.get_lsp_capabilities() })
end)

later(function() -- mini.cursorword
  require("mini.cursorword").setup()
end)

later(function() -- mini.diff
  require("mini.diff").setup()
end)

later(function() -- mini.files
  require("mini.files").setup({
    mappings = { mark_set = "M" },
    windows = { preview = true },
  })

  local minifiles_augroup = vim.api.nvim_create_augroup("ec-mini-files", {})
  vim.api.nvim_create_autocmd("User", {
    group = minifiles_augroup,
    pattern = "MiniFilesExplorerOpen",
    callback = function()
      MiniFiles.set_bookmark("c", vim.fn.stdpath("config"), { desc = "Config" })
      MiniFiles.set_bookmark("m", vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim", { desc = "mini.nvim" })
      MiniFiles.set_bookmark("p", vim.fn.stdpath("data") .. "/site/pack/deps/opt", { desc = "Plugins" })
      MiniFiles.set_bookmark("w", vim.fn.getcwd, { desc = "Working directory" })
    end,
  })
end)

later(function() -- mini.git
  require("mini.git").setup({})

  local align_blame = function(au_data)
    if au_data.data.git_subcommand ~= "blame" then
      return
    end

    -- Align blame output with source
    local win_src = au_data.data.win_source
    vim.wo.wrap = false
    vim.fn.winrestview({ topline = vim.fn.line("w0", win_src) })
    vim.api.nvim_win_set_cursor(0, { vim.fn.line(".", win_src), 0 })

    -- Bind both windows so that they scroll together
    vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
  end

  local group = vim.api.nvim_create_augroup("kaz-minigit", { clear = true })

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "MiniGitCommandSplit",
    callback = align_blame,
  })

  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = group,
    pattern = { "git", "diff" },
    desc = "Set fold configuration for mini.git",
    callback = function()
      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "v:lua.MiniGit.diff_foldexpr()"
    end,
  })
end)

later(function() -- mini.hipatterns
  local hipatterns = require("mini.hipatterns")

  local censor_extmark_opts = function(_, match, _)
    local mask = string.rep("x", vim.fn.strchars(match))
    return {
      virt_text = { { mask, "Comment" } },
      virt_text_pos = "overlay",
      priority = 2000,
      right_gravity = false,
    }
  end

  hipatterns.setup({
    highlighters = {
      -- Hide passwords
      censor = {
        pattern = "password: ()%S+()",
        group = "",
        extmark_opts = censor_extmark_opts,
      },
      -- Hex colors
      hex_color = hipatterns.gen_highlighter.hex_color({
        style = "inline",
        inline_text = " ",
      }),
      -- TODO/FIXME/HACK/NOTE
      -- stylua: ignore start
      fixme       = { pattern = "() FIXME():",   group = "MiniHipatternsFixme" },
      hack        = { pattern = "() HACK():",    group = "MiniHipatternsHack" },
      todo        = { pattern = "() TODO():",    group = "MiniHipatternsTodo" },
      note        = { pattern = "() NOTE():",    group = "MiniHipatternsNote" },
      fixme_colon = { pattern = " FIXME():()",   group = "MiniHipatternsFixmeColon" },
      hack_colon  = { pattern = " HACK():()",    group = "MiniHipatternsHackColon" },
      todo_colon  = { pattern = " TODO():()",    group = "MiniHipatternsTodoColon" },
      note_colon  = { pattern = " NOTE():()",    group = "MiniHipatternsNoteColon" },
      fixme_body  = { pattern = " FIXME:().*()", group = "MiniHipatternsFixmeBody" },
      hack_body   = { pattern = " HACK:().*()",  group = "MiniHipatternsHackBody" },
      todo_body   = { pattern = " TODO:().*()",  group = "MiniHipatternsTodoBody" },
      note_body   = { pattern = " NOTE:().*()",  group = "MiniHipatternsNoteBody" },
      -- stylua: ignore end
    },
  })
end)

later(function() -- mini.indentscope
  require("mini.indentscope").setup({})
end)

later(function() -- mini.jump
  require("mini.jump").setup()
end)

-- later(function() -- mini.jump2d
--   local jump2d = require("mini.jump2d")
--   jump2d.setup({
--     labels = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
--     view = { dim = true, n_steps_ahead = 2 },
--     mappings = { start_jumping = "m" },
--   })
--
--   -- NOTE: <Cr> binding must be set here as jump2d overwrites our mappings.lua.
--   -- Relies on jump2d opts.mappings.start_jumping being set to <Cr>, so the
--   -- autocomands to unmap <Cr> in quickfix are installed. I think it would be
--   -- better if one could just specify the default jump function as an option so
--   -- one doesn't have to define their own keymap to override it.
--   vim.keymap.set(
--     { "o", "x", "n" },
--     "m",
--     "<Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.single_character)<CR>",
--     { desc = "Jump anywhere" }
--   )
-- end)

later(function() -- mini.keymap
  local map_combo = require("mini.keymap").map_combo
  local map_multistep = require("mini.keymap").map_multistep

  local copilot_accept = {
    condition = function()
      return vim.g.kaz_copilot and require("copilot.suggestion").is_visible()
    end,
    action = function()
      require("copilot.suggestion").accept()
    end,
  }

-- stylua: ignore start
  map_multistep("i", "<Tab>",   { "minisnippets_next", "minisnippets_expand", copilot_accept, "increase_indent", "jump_after_close" })
  map_multistep("i", "<S-Tab>", { "minisnippets_prev", "decrease_indent",     "jump_before_open" })
  map_multistep("i", "<CR>",    { "blink_accept",      "pmenu_accept",        "nvimautopairs_cr" })
  map_multistep("i", "<BS>",    { "nvimautopairs_bs" })
  map_multistep("i", "<Tab>",   { "minisnippets_next", "minisnippets_expand", copilot_accept, "increase_indent", "jump_after_close" })
  -- stylua: ignore end

  map_combo({ "i", "c", "x", "s" }, "jk", "<BS><BS><Esc>")

  local notify_many_keys = function(key)
    local lhs = string.rep(key, 5)
    local action = function()
      vim.notify("Too many " .. key)
    end
    map_combo({ "n", "x" }, lhs, action)
  end

  notify_many_keys("h")
  notify_many_keys("j")
  notify_many_keys("k")
  notify_many_keys("l")
end)

later(function() -- mini.map
  local map = require("mini.map")

  -- stylua: ignore
  map.setup({
    integrations = {
      map.gen_integration.builtin_search(),
      map.gen_integration.diff(),
      map.gen_integration.diagnostic(),
    },
    symbols = {
      encode = map.gen_encode_symbols.dot("4x2"),
    },
    window = {
      -- place above treesitter-context, which is 20
      zindex = 21,
    },
  })

  vim.keymap.set("n", [[\h]], ":let v:hlsearch = 1 - v:hlsearch<CR>", { desc = "Toggle hlsearch", silent = true })
  for _, key in ipairs({ "n", "N", "*" }) do
    vim.keymap.set("n", key, key .. "zv<Cmd>lua MiniMap.refresh({}, { lines = false, scrollbar = false })<CR>")
  end

  -- stylua: ignore
  local auto_enable = {
    go       = true,
    lua      = true,
    markdown = true,
    python   = true,
    rust     = true,
  }

  -- Return true if the current buffer is supposed to have a map.
  -- 1. User has expilicity enabled it via M.buf_toggle
  -- 2. Filetype of buffer is in the auto_enable table
  Config.minimap_should_be_enabled = function()
    local ft = vim.bo.filetype
    local disabled = vim.b.minimap_disable
    local enabled_explicitly = vim.b.minimap_disable == false
    return enabled_explicitly or auto_enable[ft] and not disabled
  end

  vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("kaz-minimap", { clear = true }),
    desc = "Toggle 'mini.map' based on filetype",
    callback = function()
      if Config.minimap_should_be_enabled() then
        MiniMap.open()
      else
        MiniMap.close()
      end
    end,
  })
end)

later(function() -- mini.misc
  require("mini.misc").setup({ make_global = { "put", "put_text", "stat_summary", "bench_time" } })
  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()
  MiniMisc.setup_termbg_sync()
end)

later(function() -- mini.move
  require("mini.move").setup()
end)

later(function() -- mini.operators
  local remap = function(mode, lhs_from, lhs_to)
    local keymap = vim.fn.maparg(lhs_from, mode, false, true)
    local rhs = keymap.callback or keymap.rhs
    if rhs == nil then
      error("Could not remap from " .. lhs_from .. " to " .. lhs_to)
    end
    vim.keymap.set(mode, lhs_to, rhs, { desc = keymap.desc })
  end
  remap("n", "gx", "gX")
  remap("x", "gx", "gX")
  MiniClue.set_mapping_desc("n", "gX", "Open file or URI")
  MiniClue.set_mapping_desc("x", "gX", "Open file or URI")

  -- From https://github.com/echasnovski/mini.nvim/discussions/1835
  local comment_multiply = false
  local my_multiply_func = function(content)
    if not (comment_multiply and content.submode == "V") then
      return content.lines
    end

    -- Add comment
    comment_multiply = false
    local commentstring = vim.bo.commentstring
    return vim.tbl_map(function(l)
      return (commentstring:gsub("%%s", l))
    end, content.lines)
  end
  require("mini.operators").setup({ multiply = { func = my_multiply_func } })

  local map_comment_multiply = function(mode, lhs, multiply_keys, desc)
    local rhs = function()
      -- Preserve cursor position so that it is on *not* commented part
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.schedule(function()
        vim.api.nvim_win_set_cursor(0, pos)
      end)

      comment_multiply = true
      return multiply_keys
    end

    local opts = { expr = true, remap = true, desc = desc }
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  map_comment_multiply({ "n", "x" }, "gC", "gm", "Multiply and comment")
  map_comment_multiply("n", "gCC", "gmm", "Multiply and comment line")
end)

later(function() -- mini.pairs
  -- I don't use MiniPairs as it doesn't handle Python triple quotes or
  -- markdown triple backticks. Nvim_autopairs is better
end)

later(function() -- mini.pick
  require("mini.pick").setup({
    source = {
      preview = function(buf_id, item)
        return MiniPick.default_preview(buf_id, item, { line_position = "center" })
      end,
    },
  })

  vim.ui.select = MiniPick.ui_select

  -- Config picker ==========================================================
  MiniPick.registry.config = function()
    return MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath("config") } })
  end

  -- Project picker =========================================================
  MiniPick.registry.projects = function()
    local cwd = vim.fn.expand("~/repos")
    local choose = function(item)
      vim.schedule(function()
        MiniPick.builtin.files(nil, { source = { cwd = item.path } })
      end)
    end
    return MiniExtra.pickers.explorer({ cwd = cwd }, { source = { choose = choose } })
  end

  -- Aligned Grep live picker ===============================================
  MiniPick.registry.grep_live_align = function(opts)
    MiniPick.builtin.grep_live(opts, {
      source = { show = Config.minipick_align_on_nul },
    })
  end

  -- Aligned TODO picker ====================================================
  MiniPick.registry.grep_todo_keywords = function(opts)
    opts.pattern = "(TODO|FIXME|HACK|NOTE):"
    MiniPick.builtin.grep(opts, {
      source = {
        show = function(buf_id, items, query)
          Config.minipick_align_on_nul(buf_id, items, query)
          Config.minipick_highlight_keywords(buf_id)
        end,
      },
    })
  end
end)

later(function() -- mini.snippets
  local snippets = require("mini.snippets")
  snippets.setup({
    snippets = {
      snippets.gen_loader.from_file("~/.config/minivim/snippets/global.json"),
      snippets.gen_loader.from_file("~/.config/minivim/snippets/mini-test.json"),
      snippets.gen_loader.from_lang(),
    },
  })
end)

later(function() -- mini.splitjoin
  require("mini.splitjoin").setup()
end)

later(function() -- mini.surround
  require("mini.surround").setup()
end)

later(function() -- mini.trailspace
  require("mini.trailspace").setup()
end)

later(function() -- mini.visits
  require("mini.visits").setup()
end)
