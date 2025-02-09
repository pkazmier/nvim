return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>n", group = "Zk Notes", icon = { icon = "󰠮", color = "yellow" } },
      },
    },
  },
  {
    "zk-org/zk-nvim",
    -- cmd = { "ZkNotes", "ZkMeeting" },
    dev = false,
    config = function()
      require("zk").setup({
        picker = "snacks_picker",
        lsp = {
          config = {
            cmd = { "zk", "lsp" },
            name = "zk",
          },
          auto_attach = { enabled = true, filetypes = { "markdown" } },
        },
      })

      require("zk.commands").add("ZkMeeting", function(options)
        options = vim.tbl_extend("force", { dir = "meetings" }, options or {})
        require("util.zk").new_meeting(options)
      end)
    end,
    cmd = { "ZkMeeting", "ZkNotes" },
    keys = {
      {
        "<leader>nb",
        function()
          require("zk.commands").get("ZkBacklinks")()
        end,
        desc = "Backlink Picker",
      },
      {
        "<leader>nd",
        function()
          require("zk.commands").get("ZkCd")()
        end,
        desc = "Change Directory",
      },
      {
        "<leader>nr",
        function()
          require("zk.commands").get("ZkIndex")()
        end,
        desc = "Refresh Index",
      },
      {
        "<leader>nl",
        function()
          require("zk.commands").get("ZkLinks")()
        end,
        desc = "Link Picker",
      },
      {
        "<leader>nm",
        function()
          require("zk.commands").get("ZkNotes")({
            sort = { "created" },
            match = { vim.fn.input("Match: ") },
          })
        end,
        desc = "Match (FTS)",
      },
      {
        "<leader>ns",
        function()
          require("zk.commands").get("ZkNotes")({
            sort = { "created" },
          })
        end,
        desc = "Search",
      },
      {
        "<leader>np",
        function()
          local line = vim.api.nvim_buf_get_lines(0, 0, 1, false)
          if #line == 1 then
            local meeting = line[1]:match("^# %d%d%d%d%-%d%d%-%d%d: (.+)")
            if meeting then
              local filter = 'title: "' .. meeting .. '"'
              local bufname = vim.api.nvim_buf_get_name(0)
              require("zk.commands").get("ZkNotes")({
                excludeHrefs = { bufname },
                sort = { "created" },
                match = { filter },
              })
            end
          end
        end,
        desc = "Search 1:1s",
      },
      {
        "<leader>nn",
        function()
          require("zk.commands").get("ZkNew")({
            title = vim.fn.input("Title: "),
          })
        end,
        desc = "New Note",
      },
      {
        "<leader>nN",
        function()
          require("zk.commands").get("ZkMeeting")()
        end,
        desc = "New Meeting Note",
      },
      {
        "<leader>nt",
        function()
          require("zk.commands").get("ZkTags")()
        end,
        desc = "Tags",
      },
    },
  },
}
