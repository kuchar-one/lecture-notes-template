local M = {}

-- Map of environments to their underlying box, colors, counters, and names
local env_map = {
  theorem = { box = "thmbox", color = "thmline!85!black", line_color = "thmline", back_color = "thmback", itshape = true, counter = "theoremctr", name = "theoremname" },
  lemma = { box = "thmbox", color = "thmline!85!black", line_color = "thmline", back_color = "thmback", itshape = true, counter = "lemmactr", name = "lemmaname" },
  proposition = { box = "thmbox", color = "thmline!85!black", line_color = "thmline", back_color = "thmback", itshape = true, counter = "propositionctr", name = "propositionname" },
  corollary = { box = "thmbox", color = "thmline!85!black", line_color = "thmline", back_color = "thmback", itshape = true, counter = "corollaryctr", name = "corollaryname" },
  result = { box = "thmbox", color = "thmline!85!black", line_color = "thmline", back_color = "thmback", itshape = true, counter = "resultctr", name = "resultname" },
  definition = { box = "defbox", color = "defline!90!black", line_color = "defline", back_color = "defback", itshape = false, counter = "definitionctr", name = "definitionname" },
  postulate = { box = "defbox", color = "defline!90!black", line_color = "defline", back_color = "defback", itshape = false, counter = "postulatectr", name = "postulatename" },
  note = { box = "notbox", color = "noteline!90!black", line_color = "noteline", back_color = "noteback", itshape = false, counter = "notectr", name = "notename" },
  problem = { box = "probbox", color = "probline!90!black", line_color = "probline", back_color = "probback", itshape = false, counter = "problemctr", name = "problemname" },
  example = { box = "probbox", color = "probline!90!black", line_color = "probline", back_color = "probback", itshape = false, counter = "problemctr", name = "Example" },
  objective = { box = "objbox", color = "objline!90!black", line_color = "objline", back_color = "objback", itshape = false, counter = "objectivectr", name = "objectivename" },
  intuition = { box = "intbox", color = "intline!90!black", line_color = "intline", back_color = "intback", itshape = false, counter = "intuitionctr", name = "intuitionname" },
  algo = { box = "algbox", color = "algline!90!black", line_color = "algline", back_color = "algback", itshape = false, counter = "algorithmctr", name = "algorithmname" },
  application = { box = "appbox", color = "appline!90!black", line_color = "appline", back_color = "appback", itshape = false, counter = "applicationctr", name = "applicationname" },
  history = { box = "histbox", color = "histline!90!black", line_color = "histline", back_color = "histback", itshape = false, counter = "historyctr", name = "historyname" },
  pitfall = { box = "pitbox", color = "pitfallline!90!black", line_color = "pitfallline", back_color = "pitfallback", itshape = false, counter = "pitfallctr", name = "pitfallname" },
  keyreference = { box = "refbox", color = "refline!90!black", line_color = "refline", back_color = "refback", itshape = false, counter = "referencectr", name = "referencename" },
  summary = { box = "sumbox", color = "sumline!90!black", line_color = "sumline", back_color = "sumback", itshape = false, counter = "summaryctr", name = "summaryname" },
  exam = { box = "exambox", color = "examline!90!black", line_color = "examline", back_color = "examback", itshape = false, counter = "examctr", name = "examname" },
}

local env_map_starred = {
  ["theorem*"] = { box = "thmbox", color = "thmline!85!black", line_color = "thmline", back_color = "thmback", itshape = true, name = "theoremname" },
  ["lemma*"] = { box = "thmbox", color = "thmline!85!black", line_color = "thmline", back_color = "thmback", itshape = true, name = "lemmaname" },
  ["definition*"] = { box = "defbox", color = "defline!90!black", line_color = "defline", back_color = "defback", itshape = false, name = "definitionname" },
  ["note*"] = { box = "notbox", color = "noteline!90!black", line_color = "noteline", back_color = "noteback", itshape = false, name = "notename" },
  ["problem*"] = { box = "probbox", color = "probline!90!black", line_color = "probline", back_color = "probback", itshape = false, name = "problemname" },
}

-- Helper to escape pattern characters
local function escape_pattern(s)
  return string.gsub(s, "%*", "%%*")
end

-- List of environments to search for and split on
local env_names = {
  "proof", "solution",
  "theorem", "lemma", "proposition", "corollary", "result",
  "definition", "postulate",
  "note", "problem", "example",
  "objective", "intuition", "algo", "application", "history", "pitfall",
  "keyreference", "summary", "exam",
  "theorem*", "lemma*", "definition*", "note*", "problem*"
}

-- Split the body into a list of blocks: normal text, nested environments
local function split_body(text)
  local blocks = {}
  local pos = 1
  while true do
    local first_start = nil
    local first_end = nil
    local env_type = nil
    local args = ""
    
    for _, name in ipairs(env_names) do
      local name_esc = escape_pattern(name)
      local b_start, b_end, b_args = string.find(text, "\\begin%s*{" .. name_esc .. "}%s*(%b[])", pos)
      local b_noargs_start, b_noargs_end = string.find(text, "\\begin%s*{" .. name_esc .. "}", pos)
      
      if b_start and (not first_start or b_start < first_start) then
        first_start = b_start
        first_end = b_end
        env_type = name
        args = b_args or ""
      end
      if b_noargs_start and (not first_start or b_noargs_start < first_start) then
        first_start = b_noargs_start
        first_end = b_noargs_end
        env_type = name
        args = ""
      end
    end
    
    if not first_start then
      -- No more nested environments
      local rest = string.sub(text, pos)
      table.insert(blocks, { type = "normal", content = rest })
      break
    end
    
    -- Insert normal block before
    if first_start > pos then
      table.insert(blocks, { type = "normal", content = string.sub(text, pos, first_start - 1) })
    end
    
    -- Find the matching end
    local end_pattern = "\\end%s*{" .. escape_pattern(env_type) .. "}"
    local e_start, e_end = string.find(text, end_pattern, first_end + 1)
    
    if not e_start then
      table.insert(blocks, { type = env_type, content = string.sub(text, first_end + 1), args = args })
      break
    end
    
    table.insert(blocks, { type = env_type, content = string.sub(text, first_end + 1, e_start - 1), args = args })
    pos = e_end + 1
  end
  return blocks
end

-- Normalise paragraph breaks.
-- The body reaches Lua already detokenised and is re-injected with tex.sprint,
-- which inserts no end-of-line characters -- so a blank line in the source would
-- otherwise vanish silently. Turn every run of blank lines into an explicit \par
-- token. (\par in vertical mode is a no-op, so this can never double-space.)
local function fix_pars(s)
  if not s then return s end
  s = string.gsub(s, "\r\n", "\n")
  s = string.gsub(s, "\n[ \t]*\n[ \t\n]*", " \\par ")
  return s
end

-- Process the nested environment and print LaTeX code back to TeX
function M.process_nested_env(env_name, is_starred, title_arg, body, is_nested_str)
  local blocks = split_body(body)
  local suffix = is_starred and "*" or ""
  local env_internal_name = env_name .. suffix .. "_internal"
  
  -- Get environment mapping details
  local mapping = is_starred and env_map_starred[env_name .. "*"] or env_map[env_name]
  
  -- If there's only one block and it's a normal block, render it normally
  if #blocks == 1 and blocks[1].type == "normal" then
    -- Just render the environment directly
    local shape_cmd = mapping.itshape and "\\itshape " or ""
    local out_str = string.format("\\begin{%s}[title={%s}]\\applyenvcolor{%s}%s%s\\end{%s}\\relax ", mapping.box, title_arg, mapping.color, shape_cmd, fix_pars(blocks[1].content), mapping.box)
    


    tex.sprint(out_str)
    return
  end
  
  if not mapping then
    -- Fallback in case of unmatched environment name
    tex.sprint(body)
    return
  end
  
  -- Global parent colors: set them globally only if this is NOT a nested call itself.
  -- This ensures nested environments do not overwrite the parent's base colors.
  local is_nested = (is_nested_str == "true")
  if not is_nested then
    tex.sprint(string.format(
      "\\xglobal\\colorlet{parentlinecolor}{%s}\\xglobal\\colorlet{parentbackcolor}{%s}",
      mapping.line_color, mapping.back_color
    ))
  end
  
  -- Filter blocks: keep all nested ones, and keep non-empty normal blocks
  local active_blocks = {}
  for _, block in ipairs(blocks) do
    if block.type == "normal" then
      -- Strip whitespace and \par
      local trimmed = string.gsub(block.content, "^[%s\\]*(.-)[%s\\]*$", "%1")
      trimmed = string.gsub(trimmed, "^par$", "")
      trimmed = string.gsub(trimmed, "^%s*(.-)%s*$", "%1")
      
      if trimmed ~= "" then
        table.insert(active_blocks, block)
      end
    else
      table.insert(active_blocks, block)
    end
  end
  
  local is_first_normal = true
  
  for i, block in ipairs(active_blocks) do
    -- Lookahead: check if the next active block is a nested environment
    local next_block = active_blocks[i+1]
    local next_is_nested_val = "false"
    if next_block and next_block.type ~= "normal" then
      next_is_nested_val = "true"
    end
    
    if block.type == "normal" then
      if is_first_normal then
        -- Render primary box
        local opt_arg = ""
        if title_arg ~= "" then
          opt_arg = "[" .. title_arg .. "]"
        end
        tex.sprint(string.format("\\gdef\\nextisnested{%s}", next_is_nested_val))
        tex.sprint(string.format("\\begin{%s}%s%s\\end{%s}", env_internal_name, opt_arg, fix_pars(block.content), env_internal_name))
        is_first_normal = false
      else
        -- Render reopened box (flat structure, title={}, before skip=-\dimexpr\parskip\relax, and spacing)
        local shape_cmd = mapping.itshape and "\\itshape" or ""
        tex.sprint(string.format(
          "\\gdef\\nextisnested{%s}\\begin{%s}[title={}, before skip=-\\dimexpr\\parskip\\relax]\\applyenvcolor{%s}%s\\vspace{0.8em}%s\\end{%s}\\xglobal\\colorlet{lastclosedboxline}{%s}\\xglobal\\colorlet{lastclosedboxback}{%s}\\gdef\\afternestedbox{false}\\relax ",
          next_is_nested_val, mapping.box, mapping.color, shape_cmd, fix_pars(block.content), mapping.box,
          mapping.line_color, mapping.back_color
        ))
      end
    else
      -- If we haven't opened the primary parent box yet, open an empty one first
      if is_first_normal then
        local opt_arg = ""
        if title_arg ~= "" then
          opt_arg = "[" .. title_arg .. "]"
        end
        tex.sprint(string.format("\\gdef\\nextisnested{%s}", next_is_nested_val))
        tex.sprint(string.format("\\begin{%s}%s\\end{%s}", env_internal_name, opt_arg, env_internal_name))
        is_first_normal = false
      end
      
      -- Render nested environment
      local consecutive = "false"
      if i > 1 and active_blocks[i-1].type ~= "normal" then
        consecutive = "true"
      end
      local opt_arg = ""
      if block.args ~= "" then
        opt_arg = block.args
      end
      tex.sprint(string.format(
        "\\gdef\\consecutivenested{%s}\\gdef\\nextisnested{%s}\\gdef\\isnestedbox{true}\\begin{%s}%s%s\\end{%s}\\gdef\\isnestedbox{false}\\xglobal\\colorlet{lastclosedboxline}{%s}\\xglobal\\colorlet{lastclosedboxback}{%s}\\gdef\\afternestedbox{true}\\gdef\\consecutivenested{false}\\relax ",
        consecutive, next_is_nested_val, block.type, opt_arg, fix_pars(block.content), block.type, mapping.line_color, mapping.back_color
      ))
    end
  end
end

nested_parser = M
return M
