```lua
(function ()
  if vim.fn.executable('chris-nvim-client') == 1 then
    local client_job = vim.fn.jobstart(
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
```
