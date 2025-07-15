-- Return to previously accessed window.
function popWindow()
  local lastWin = vim.fn.winnr("#")
  vim.api.nvim_command(lastWin .. " wincmd w")
end

function pushWindow(win)
  vim.api.nvim_command(win .. " wincmd w")
end

function setColor(group, attr, color)
  -- See has('termguicolors'), which means 24-bit colors in TUI
  local cmd = "hi " .. group .. " gui" .. attr .. "=" .. color
  vim.api.nvim_command(cmd)
end

function colorize()
  for _, group in ipairs({
    "NonText",
    "FoldColumn",
    "ColorColumn",
    "VertSplit",
    "StatusLine",
    "StatusLineNC",
    "SignColumn",
  }) do
    setColor(group, "fg", "black")
    setColor(group, "bg", "NONE")
    setColor(group, "", "NONE")
  end
end

-- TODO delete
function DeepPrint (t)
  local request_headers_all = ""
  for k, v in pairs(t) do
    if type(v) == "table" then
      request_headers_all = request_headers_all .. "[" .. k .. " " .. DeepPrint(v) .. "] "
    else
      local rowtext = ""
      rowtext = string.format("[%s %s] ", k, v)
      request_headers_all = request_headers_all .. rowtext
    end
  end
  return request_headers_all
end

function createMargin(command)
  vim.api.nvim_command(command)

  vim.opt_local.buftype = "nofile"
  vim.opt_local.winfixwidth = true
  vim.opt_local.winfixheight = true
  vim.opt_local.statusline = ""

  local buf = vim.fn.winbufnr(0)
  popWindow()
  return buf
end

function resize(handles)
  local totalWidth = vim.opt.columns._value
  local totalHeight = vim.opt.lines._value
  local horizontalMargin = (function()
    local excessWidth = totalWidth - 81
    if excessWidth < 1 then
      excessWidth = 1
    end
    return math.floor(excessWidth / 2)
  end)()
  local verticalMargin = (function()
    local excessHeight = totalHeight * 0.2
    if excessHeight < 0 then
      excessHeight = 0
    end
    return math.floor(excessHeight / 2)
  end)()
  resizeMargin(handles.left, horizontalMargin)
  resizeMargin(handles.right, horizontalMargin)
  resizeMargin(handles.top, verticalMargin)
  resizeMargin(handles.bottom, verticalMargin)
end

function resizeMargin(handle, margin)
  -- Check for error?
  local win = vim.fn.bufwinnr(handle.buffer)

  pushWindow(win)

  -- TODO: Hide statusline on buffer leave

  --vim.api.nvim_set_current_line("resizing buffer " .. handle.buffer .. " by " .. tostring(margin) .. " pixels.")
  if handle.vertical then
    vim.api.nvim_command("vertical resize " .. tostring(margin))
  else
    vim.api.nvim_command("resize " .. tostring(margin))
  end
  popWindow()
end

function focus()
  local handles = {}

  handles.left = {
    buffer = createMargin("vertical topleft new"),
    vertical = true,
  }
  handles.right = {
    buffer = createMargin("vertical botright new"),
    vertical = true,
  }
  handles.top = {
    buffer = createMargin("topleft new"),
    vertical = false,
  }
  handles.bottom = {
    buffer = createMargin("botright new"),
    vertical = false,
  }

  resize(handles)
  colorize()
end

(function ()
  if vim.fn.executable('chris-nvim-client') == 1 then
    local client_job = vim.fn.jobstart(
      --'chris-nvim-client -debug',
      'chris-nvim-client',
      {rpc = true}
    )
    if client_job < 1 then
      error("Failed to jobstart chris-nvim-client")
    else
      local result = vim.fn.rpcrequest(client_job, 'init', {})
      if result ~= "Success from Go" then
        error("Unexpected output from `chris-nvim-client`: " .. result)
      end
      vim.fn.rpcrequest(client_job, 'die', {})
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

--focus()
