-- ---------------------------------------------------------------------------
-- extui
-- ---------------------------------------------------------------------------

-- Enable the experimental 'extui' from neovim-0.12+
--
-- Provides syntax highlighting in command line as well as a buffer
-- for messages that are shown. You enter the message buffer with 'g<'.

MiniDeps.now(function() require("vim._extui").enable({}) end)
