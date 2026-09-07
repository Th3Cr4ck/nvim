local M = {}

M.opts = {
  dark  = "carbonfox",  -- tema oscuro
  light = "dayfox",  -- tema claro

  -- Fallback si falla la detección de GNOME (hora en formato 24h)
  day_start   = 7,
  night_start = 20,
}

-- Consulta el estado real de Night Light via D-Bus
local function gnome_night_light_active()
  local cmd = table.concat({
    "gdbus call --session",
    "--dest org.gnome.SettingsDaemon.Color",
    "--object-path /org/gnome/SettingsDaemon/Color",
    "--method org.freedesktop.DBus.Properties.Get",
    "org.gnome.SettingsDaemon.Color NightLightActive",
    "2>/dev/null",
  }, " ")

  local out = vim.fn.system(cmd)
  -- La salida es algo como: (<true>,) o (<false>,)
  return out:match("true") ~= nil
end

-- Fallback: decidir por hora del sistema
local function night_by_time()
  local h = tonumber(os.date("%H"))
  return h >= M.opts.night_start or h < M.opts.day_start
end

-- Decide si usar tema oscuro
local function use_dark()
  local ok, result = pcall(gnome_night_light_active)
  if ok then return result end
  -- Si gdbus falla (Wayland edge case, etc.) usamos hora
  vim.notify("[theme] gdbus falló, usando hora del sistema", vim.log.levels.DEBUG)
  return night_by_time()
end

-- Aplica el colorscheme correspondiente
function M.apply()
  local dark = use_dark()
  local scheme = dark and M.opts.dark or M.opts.light

  -- Evita re-aplicar si ya está puesto el mismo scheme
  if vim.g.colors_name == scheme then return end

  vim.o.background = dark and "dark" or "light"
  vim.cmd.colorscheme(scheme)

  -- Espera a que ColorScheme termine y fuerza refresh de lualine
  vim.schedule(function()
    local ok, lualine = pcall(require, "lualine")
    if ok then
      lualine.setup()
    end
  end)
end

-- Inicia un timer que re-evalúa cada N minutos
function M.start_timer(minutes)
  minutes = minutes or 5
  local ms = minutes * 60 * 1000

  -- vim.uv en Neovim ≥0.10, vim.loop en versiones anteriores
  local uv = vim.uv or vim.loop
  local timer = uv.new_timer()

  timer:start(ms, ms, vim.schedule_wrap(function()
    M.apply()
  end))

  return timer
end

return M
