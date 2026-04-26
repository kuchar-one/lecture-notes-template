# Premium Lecture Notes Template

This is a reusable, modular LaTeX template for creating beautifully styled lecture notes. It uses LuaLaTeX and a custom geometric design with tailored `tcolorbox` environments for definitions, theorems, problems, and notes.

## Usage

1. Open `main.tex`.
2. Update the `\maketitlepage` arguments with your specific title, subject, and author information.
3. Add your content using the provided environments:
   - `definition`
   - `theorem`
   - `proof`
   - `lemma`
   - `proposition`
   - `note`
   - `problem`
   - `solution`
   - `overviewbox`
   - `termsbox`

### Language Switching

By default, the template supports Czech and English keywords. You can switch this in `resources/style.sty` by toggling `\langcztrue` or `\langczfalse` at the top of the file.

### Compilation

This template requires `lualatex` due to the custom font support (`Oswald` and `STIX Two`). It is pre-configured via the `.latexmkrc` file. 

Simply run:
```bash
latexmk
```
Or use your editor's built-in `latexmk` build system.

## File Structure

- `main.tex` - Your entry point for writing.
- `resources/style.sty` - All the preamble, styling, colors, and macros.
- `fonts/` - Contains the required `Oswald` fonts.
- `.latexmkrc` - Ensures proper LuaLaTeX compilation.
