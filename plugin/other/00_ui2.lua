-- ---------------------------------------------------------------------------
-- _core.ui2
-- ---------------------------------------------------------------------------

-- Enable the experimental 'ui2' from neovim-0.12+
--
-- Provides syntax highlighting in command line as well as a buffer
-- for messages that are shown. You enter the message buffer with 'g<'.

Config.now(function() require("vim._core.ui2").enable({}) end)
