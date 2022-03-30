-- forceRequire()
-- Force the reload of a module
-- Kudos: https://stackoverflow.com/a/2812556/197789

function forceRequire(module)
  package.loaded[module] = nil
  return require(module)
end
