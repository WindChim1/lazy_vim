---@diagnostic disable: undefined-field, inject-field
local ffi = require("ffi")
local bit = require("bit")

ffi.cdef([[
  void *GetForegroundWindow(void);
  int IsWindow(void *hwnd);
  unsigned long GetWindowThreadProcessId(void *hwnd, unsigned long *process_id);
  typedef struct {
    unsigned long cbSize;
    unsigned long flags;
    void *hwndActive;
    void *hwndFocus;
    void *hwndCapture;
    void *hwndMenuOwner;
    void *hwndMoveSize;
    void *hwndCaret;
    long left, top, right, bottom;
  } NvimIMEThreadInfo;
  int GetGUIThreadInfo(unsigned long thread_id, NvimIMEThreadInfo *info);
  void *ImmGetDefaultIMEWnd(void *hwnd);
  intptr_t SendMessageTimeoutW(void *hwnd, unsigned int msg, uintptr_t wparam,
    intptr_t lparam, unsigned int flags, unsigned int timeout, uintptr_t *result);
]])

local user32 = ffi.load("user32")
local imm32 = ffi.load("imm32")
local M = {}
local window

function M.attach()
  window = user32.GetForegroundWindow()
end

function M.active()
  return window ~= nil and window ~= ffi.NULL and user32.GetForegroundWindow() == window
end

local function ime_window(force)
  if not (force or M.active()) then
    return
  end
  local info = ffi.new("NvimIMEThreadInfo")
  info.cbSize = ffi.sizeof(info)
  local thread = user32.GetWindowThreadProcessId(window, nil)
  local target = window
  if user32.GetGUIThreadInfo(thread, info) ~= 0 and info.hwndFocus ~= ffi.NULL then
    target = info.hwndFocus
  end
  local hwnd = imm32.ImmGetDefaultIMEWnd(target)
  if hwnd ~= ffi.NULL then
    return hwnd
  end
end

local function control(hwnd, command, value)
  local result = ffi.new("uintptr_t[1]")
  -- WM_IME_CONTROL; abort rather than hanging on an unresponsive terminal.
  if user32.SendMessageTimeoutW(hwnd, 0x0283, command, value or 0, 0x0002, 30, result) == 0 then
    return nil
  end
  return tonumber(result[0])
end

function M.get(force)
  local hwnd = ime_window(force)
  if not hwnd then
    return
  end
  local open = control(hwnd, 0x0005)
  if open == nil then
    return
  end
  local conversion = control(hwnd, 0x0001)
  if conversion == nil then
    return
  end
  return { open = open ~= 0, conversion = conversion }
end

function M.set(state, force)
  local hwnd = ime_window(force)
  if not hwnd then
    return
  end
  if state.open then
    if control(hwnd, 0x0006, 1) ~= 0 then
      return false
    end
    if control(hwnd, 0x0002, state.conversion) ~= 0 then
      return false
    end
  else
    if control(hwnd, 0x0002, state.conversion) ~= 0 then
      return false
    end
    if control(hwnd, 0x0006, 0) ~= 0 then
      return false
    end
  end
  local actual = M.get(force)
  return actual ~= nil and M.equal(state, actual)
end

function M.english(state)
  return { open = false, conversion = bit.band(state.conversion, bit.bnot(1)) }
end

function M.toggle(state)
  if state.open and bit.band(state.conversion, 1) ~= 0 then
    return M.english(state)
  end
  return { open = true, conversion = bit.bor(state.conversion, 1) }
end

function M.equal(a, b)
  return a.open == b.open and a.conversion == b.conversion
end

return M
