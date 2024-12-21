return {
  { "akinsho/bufferline.nvim", opts = { options = { separator_style = "slope" } } },
  {
    "folke/tokyonight.nvim",
    opts = function(_, opts)
      opts.lualine_bold = true
      opts.on_highlights = function(hl, c)
        hl["SnacksDashboardHeader"] = { fg = c.blue2 }
        hl["SnacksDashboardTitle"] = { fg = c.magenta, bold = true }
        hl["SnacksDashboardKey"] = { fg = c.yellow, bold = true }
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
    opts = {
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
            { padding = 0, text = { header, hl = "header" } },
            { align = "center", desc = greeting(), padding = 2 },
            { title = "Builtin Actions", indent = 2, padding = 1,
              { icon = " ", key = "f", desc = "Find File",       action = ":lua Snacks.dashboard.pick('files')" },
              { icon = " ", key = "n", desc = "New File",        action = ":ene | startinsert" },
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
}
