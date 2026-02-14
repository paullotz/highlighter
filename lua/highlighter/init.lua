local M = {}

M.enabled = true

function M.define_highlights()
  vim.api.nvim_set_hl(0, 'TodoTodo', {
    bg = '#f1fa8c',
    fg = '#181825',
    ctermbg = 226,
    ctermfg = 235,
  })

  vim.api.nvim_set_hl(0, 'TodoFixme', {
    bg = '#fab387',
    fg = '#181825',
    ctermbg = 215,
    ctermfg = 235,
  })

  vim.api.nvim_set_hl(0, 'TodoNote', {
    bg = '#f9e2af',
    fg = '#181825',
    ctermbg = 229,
    ctermfg = 235,
  })
end

function M.clear_matches()
  if vim.w.todo_matches then
    for _, match_id in ipairs(vim.w.todo_matches) do
      pcall(vim.fn.matchdelete, match_id)
    end
    vim.w.todo_matches = nil
  end
end

function M.add_matches()
  M.clear_matches()
  
  if not M.enabled then
    return
  end

  local patterns = {
    { pattern = '\\C\\%(//\\|#\\|%\\|--\\|/\\*\\|\\*/\\|/\\|"\\)\\s*TODO\\(:\\|\\s\\)', highlight = 'TodoTodo', priority = 10 },
    { pattern = '\\C\\%(//\\|#\\|%\\|--\\|/\\*\\|\\*/\\|/\\|"\\)\\s*FIXME\\(:\\|\\s\\)', highlight = 'TodoFixme', priority = 10 },
    { pattern = '\\C\\%(//\\|#\\|%\\|--\\|/\\*\\|\\*/\\|/\\|"\\)\\s*NOTE\\(:\\|\\s\\)', highlight = 'TodoNote', priority = 10 },
  }

  local new_matches = {}
  for _, item in ipairs(patterns) do
    local match_id = vim.fn.matchadd(item.highlight, item.pattern, item.priority)
    table.insert(new_matches, match_id)
  end
  vim.w.todo_matches = new_matches
end

function M.toggle()
  M.enabled = not M.enabled
  if M.enabled then
    M.add_matches()
    print('Todo highlighter enabled')
  else
    M.clear_matches()
    print('Todo highlighter disabled')
  end
end

function M.setup()
  M.define_highlights()

  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile', 'BufEnter', 'WinEnter' }, {
    group = vim.api.nvim_create_augroup('TodoHighlighter', { clear = true }),
    callback = function()
      M.add_matches()
    end,
  })

  vim.api.nvim_create_user_command('TodoHighlightToggle', function()
    M.toggle()
  end, { desc = 'Toggle TODO highlighter' })

  vim.api.nvim_create_user_command('TodoHighlightSetColors', function(opts)
    local args = opts.fargs
    if #args < 3 then
      print('Usage: :TodoHighlightSetColors <todo_color> <fixme_color> <note_color>')
      return
    end

    vim.api.nvim_set_hl(0, 'TodoTodo', { bg = args[1], fg = '#181825', ctermbg = 226, ctermfg = 235 })
    vim.api.nvim_set_hl(0, 'TodoFixme', { bg = args[2], fg = '#181825', ctermbg = 215, ctermfg = 235 })
    vim.api.nvim_set_hl(0, 'TodoNote', { bg = args[3], fg = '#181825', ctermbg = 229, ctermfg = 235 })

    M.add_matches()
    print('Colors updated')
  end, { desc = 'Set custom highlight colors', nargs = '*' })

  M.add_matches()
end

return M

