(function ()
  if vim.fn.executable('chris-nvim-client') == 1 then
    local client_job = vim.fn.jobstart(
      --'chris-nvim-client -debug',
      'chris-nvim-client',
      {rpc = true}
    )
    if client_job < 1 then
      print("Failed to jobstart chris-nvim-client")
    else
      local result = vim.fn.rpcrequest(client_job, 'init', {})
      print(result)
      result = vim.fn.rpcrequest(client_job, 'noop', {})
      print(result)
      result = vim.fn.rpcrequest(client_job, 'die', {})
      print(result)
    end
  else
    print("[ERROR] You should add `chris-nvim-client` to your path")
  end
end)()

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

