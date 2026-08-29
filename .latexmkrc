# Latexmk configuration for LuaLaTeX
$pdf_mode = 4;  # Use lualatex
$out_dir = 'build';
$aux_dir = 'build';
$synctex = 1;

# Ignore lua_debug.log to prevent infinite latexmk loops
push @file_ignore_pattern, '^lua_debug\\.log$';