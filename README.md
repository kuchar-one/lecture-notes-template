# Premium Lecture Notes Template

This is a reusable, modular LaTeX template for creating beautifully styled lecture notes. It uses LuaLaTeX and a custom geometric design with tailored `tcolorbox` environments for definitions, theorems, problems, and notes.

## Usage

1. Open `main.tex`.
2. Update the `\maketitlepage` arguments with your specific title, subject, and author information.
3. Add your content using the provided environments:
   - `objective` (Learning Objectives)
   - `overviewbox`
   - `termsbox`
   - `definition`
   - `theorem`
   - `lemma`
   - `proposition`
   - `intuition` (Proof Intuition)
   - `proof`
   - `algo` (Algorithm/Pseudocode)
   - `application` (Real-World Application)
   - `history` (Historical Note)
   - `pitfall` (Common Mistake)
   - `note`
   - `keyreference` (Key Reference/Citation)
   - `problem`
   - `solution`

### Figures and Tables Guidelines
To maintain the Prism Clarity minimalist aesthetic:
- **Figures**: Use minimal line work (like TikZ geometric shapes) and a restricted color palette derived from the template's accent colors.
- **Tables**: Avoid vertical lines and heavy grids. Use `booktabs` (`\toprule`, `\midrule`, `\bottomrule`) and subtle alternating row shading (`\rowcolors{2}{gray!10}{white}`) for better readability.

### Language Switching

By default, the template supports Czech and English keywords. You can switch the language directly in `main.tex` by passing the `[czech]` or `[english]` option when importing the style package:
```latex
\usepackage[czech]{resources/style}
```

### Compilation

This template requires `lualatex` due to the custom font support (`Overpass` and `STIX Two`). It is pre-configured via the `.latexmkrc` file. 

Simply run:
```bash
latexmk
```
Or use your editor's built-in `latexmk` build system.

## File Structure

- `main.tex` - Your entry point for writing.
- `resources/style.sty` - All the preamble, styling, colors, and macros.
- `fonts/` - Contains the required `Overpass` fonts.
- `.latexmkrc` - Ensures proper LuaLaTeX compilation.
