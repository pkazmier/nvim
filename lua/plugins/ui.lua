local util = require("util")
return {
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options = vim.tbl_deep_extend("force", opts.options, vim.g.kaz_transparency and {
        indicator = { style = "underline" },
        separator_style = { "┃", "┃" },
      } or {
        separator_style = "slope",
      })
      return opts
    end,
  },
  {
    "folke/noice.nvim",
    opts = {
      views = {
        cmdline_popup = {
          position = {
            row = 2,
            col = "50%",
          },
          border = {
            padding = {
              left = 0,
              right = 0,
            },
          },
          size = {
            width = "78",
            height = "auto",
          },
        },
        cmdline_popupmenu = {
          position = {
            row = 4,
            col = "50%",
          },
          size = {
            width = 78,
            height = "auto",
          },
          border = {
            style = { "", "", "", " ", "", "", "", " " },
            padding = {
              left = 0,
              right = 0,
            },
          },
          win_options = {
            winhighlight = { Normal = "NormalFloat", FloatBorder = "Constant" },
          },
        },
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = function(_, opts)
      if vim.g.kaz_transparency then
        opts.transparent = true
        opts.styles = {
          sidebars = "transparent",
          floats = "transparent",
        }
      end
      opts.lualine_bold = true
      opts.on_highlights = function(hl, c)
        if vim.g.kaz_transparency then
          hl["BufferLineSeparator"] = { fg = c.bg_statusline }
          hl["BufferLineGroupSeparator"] = { fg = c.bg_statusline }
          hl["BufferLineOffsetSeparator"] = { fg = c.bg_statusline }
          hl["BufferLineSeparatorSelected"] = { fg = c.bg_statusline }
          hl["BufferLineSeparatorVisible"] = { fg = c.bg_statusline }
          hl["BufferLineTabSeparator"] = { fg = c.bg_statusline }
          hl["BufferLineTabSeparatorSelected"] = { fg = c.bg_statusline }
        end
        hl["LeapLabel"] = { fg = c.blue1, bold = true }
        hl["NoiceCmdlinePopup"] = hl.NormalFloat
        hl["NoiceCmdlinePopupBorder"] = hl.Constant
        hl["SnacksDashboardHeader"] = {
          fg = util.choose({
            c.blue,
            c.blue1,
            c.blue2,
            c.blue5,
            c.cyan,
            c.green,
            c.green2,
            c.magenta,
            c.orange,
            c.purple,
            c.red,
            c.teal,
            c.yellow,
          }),
        }
        hl["SnacksDashboardTitle"] = { fg = c.magenta, bold = true }
        hl["SnacksDashboardKey"] = { fg = c.orange, bold = true }
      end
      return opts
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local empty = require("lualine.component"):extend()
      function empty:draw(default_highlight)
        self.status = ""
        self.applied_separator = ""
        self:apply_highlights(default_highlight)
        self:apply_section_separators()
        return self.status
      end

      local function add_spacer(section, side)
        local left = side == "left"
        local separator = left and { right = "" } or { left = "" }
        section[1] = { section[1], separator = separator }
        local color = Snacks.util.color("StatusLine", "bg")
        local spacer = { empty, color = { fg = color, bg = color }, separator = separator }
        table.insert(section, left and #section + 1 or 1, spacer)
        return section
      end

      opts.sections["lualine_a"] = add_spacer(opts.sections["lualine_a"], "left")
      opts.sections["lualine_z"] = add_spacer(opts.sections["lualine_z"], "right")
      opts.options.section_separators = { left = "", right = "" }
      opts.options.component_separators = { left = "╲", right = "╱" }
      return opts
    end,
  },
  {
    "snacks.nvim",
    dev = false,
    keys = {
      {
        "<leader><space>",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart Open",
      },
      { "<leader>n", false },
      {
        "<leader>N",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification History",
      },
    },
    opts = {
      ---@type snacks.picker.Config
      image = { enabled = true },
      picker = {
        sources = {
          insert_markdown_link = {
            name = "Insert Markdown Link",
            cmd = "fd",
            args = { "-e", "md", "-e", "png", "-e", "jpg" },
            finder = "files",
            format = "file",
            show_empty = true,
            hidden = false,
            ignored = false,
            follow = false,
            supports_live = true,
            confirm = function(picker, item)
              picker:close()
              if item then
                local ext = vim.fn.fnamemodify(item.file, ":e")
                local tail = vim.fn.fnamemodify(item.file, ":t")
                local link = string.format("[%s](%s)", tail, item.file)
                local inline = vim.tbl_contains({ "png", "jpg" }, ext)
                vim.api.nvim_put({ (inline and "!" or "") .. link }, "c", true, true)
                local pos = vim.api.nvim_win_get_cursor(0)
                vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] - #link + 2 })
              end
            end,
          },
        },
        previewers = {
          git = {
            native = true,
          },
        },
        win = {
          input = {
            keys = {
              ["<a-l>"] = { "cycle_layouts", mode = { "i", "n" } },
            },
          },
          preview = {
            wo = {
              number = false,
              signcolumn = "no",
            },
          },
        },
        actions = {
          cycle_layouts = function(picker)
            return require("util.snacks_picker").set_next_preferred_layout(picker)
          end,
        },
        layout = {
          preset = function()
            return require("util.snacks_picker").preferred_layout()
          end,
        },
      },
      dashboard = {
        width = 40,
        sections = function()
          local header = [[
      ████ ██████           █████      ██                    
     ███████████             █████                            
     █████████ ███████████████████ ███   ███████████  
    █████████  ███    █████████████ █████ ██████████████  
   █████████ ██████████ █████████ █████ █████ ████ █████  
 ███████████ ███    ███ █████████ █████ █████ ████ █████ 
██████  █████████████████████ ████ █████ █████ ████ ██████
]]
          local function greeting()
            local hour = tonumber(vim.fn.strftime("%H"))
            -- [02:00, 10:00) - morning, [10:00, 18:00) - day, [18:00, 02:00) - evening
            local part_id = math.floor((hour + 6) / 8) + 1
            local day_part = ({ "evening", "morning", "afternoon", "evening" })[part_id]
            local username = os.getenv("USER") or os.getenv("USERNAME") or "user"
            return ("Good %s, %s"):format(day_part, username)
          end

          -- stylua: ignore
          return {
            { padding = 0, align = "center", text = { header, hl = "header" } },
            { padding = 2, align = "center", text = { greeting(), hl = "header" } },
            { title = "Builtin Actions", indent = 2, padding = 1,
              { icon = " ", key = "f", desc = "Find File",       action = ":lua Snacks.dashboard.pick('files')" },
              { icon = " ", key = "n", desc = "New Meeting",     action = ":ZkMeeting" },
              { icon = " ", key = "s", desc = "Restore Session", section = "session" },
              { icon = " ", key = "q", desc = "Quit",            action = ":qa" } },
            { title = "Recent Projects", section = "projects", indent = 2, padding = 1 },
            { title = "Maintenance Actions", indent = 2, padding = 2,
              { icon = " ", key = "c", desc = "Config",      action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})", },
              { icon = "󰒲 ", key = "l", desc = "Lazy",        action = ":Lazy" },
              { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
              { icon = "󱁤 ", key = "m", desc = "Mason",       action = ":Mason" },                          },
            { section = "startup" },
          }
        end,
      },
    },
  },
  {
    "zenbones-theme/zenbones.nvim",
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.zenbones = {
        darken_non_text = 30,
        solid_float_border = true,
      }
      local lush = require("lush")
      local base = require("zenbones")
      local specs = lush.parse(function()
        return {
          NoiceCmdlinePopup({ base.NormalFloat }),
        }
      end)
      lush.apply(lush.compile(specs))
    end,
  },
}
