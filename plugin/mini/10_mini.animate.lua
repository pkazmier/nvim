MiniDeps.later(function()
  local animate = require("mini.animate")
  animate.setup({
    cursor = {
      path = animate.gen_path.line({
        -- Enable animation when moving horizontally within the same line as
        -- long as the jump is more than 30 cols. By default, animation is
        -- disabled when moving horizontally.
        predicate = function(dest)
          local rows, cols = unpack(dest)
          return math.abs(rows) > 1 or math.abs(cols) > 30
        end,
      }),
    },
  })
end)
