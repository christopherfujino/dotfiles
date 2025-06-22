---- Debug Adapter
---- https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt
--
--local dap = require('dap')
--
--dap.adapters.dart = {
--  type = "executable",
--  command = "dart",
--  args = {"debug_adapter"}
--}
--dap.configurations.dart = {
--  {
--    type = "dart",
--    request = "launch",
--    name = "Launch Dart Program",
--    program = "${workspaceFolder}/main.dart",
--    cwd = "${workspaceFolder}",
--    --args = {"run", "-d", "web-server"},
--  }
--}
--
---- See :help dap-widgets
--local cmd = vim.api.nvim_create_user_command
--local widgets = require('dap.ui.widgets')
---- widgets.sidebar could be widgets.centered_float
--cmd(
--  'DapShowScopes',
--  function()
--    widgets.sidebar(widgets.scopes).open()
--  end,
--  {}
--)
--cmd(
--  'DapShowFrames',
--  function()
--    widgets.sidebar(widgets.frames).open()
--  end,
--  {}
--)
--
---- Syntaxes
---- autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) | execute 'cd' argv()[0] | endif
--vim.api.nvim_create_autocmd(
--  "VimEnter",
--  {
--    pattern = "*",
--    command = "if argc() == 1 && isdirectory(argv()[0]) | execute 'cd' argv()[0] | endif",
--  }
--)

---- https://devforum.roblox.com/t/unnamed-anonymous-functions-give-ambiguous-syntax-errors-if-previous-line-contains-a-function-call/1450059
f = (function ()
  if vim.fn.executable('chris-nvim-client') == 1 then
    local client_job = vim.fn.jobstart(
      --'/home/chris/git/chris-monorepo/go/nvim-client/run.sh',
      '/home/chris/git/dotfiles/nvim-client/nvim-client',
      {rpc = true}
    )
    if client_job < 1 then
      print("Failed to jobstart run.sh")
    else
      local result = vim.fn.rpcrequest(client_job, 'init', {})
      print(result)
    end
  else
    print("[ERROR] You should add `chris-nvim-client` to your path")
  end
end)
f()
