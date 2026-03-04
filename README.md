mark.nvim
===============================================================================
_by Kahido_
_(original version by Ingo Karkat and Yuheng Xie)_

DESCRIPTION
------------------------------------------------------------------------------

This is my own implementation of _mark_ plugin. It was written in Lua to better suitable with NeoVim. It adds mappings and a :Make command to highlight multiple words in different colors simultaneously.

USAGE
------------------------------------------------------------------------------

### HIGHLIGHTING

    <Leader>m               Mark the word under the cursor, similar to the star
                            command. The next free highlight group is used.
                            If already on a mark: Clear the mark.
    <Leader>gm              [TODO] Variant of <Leader>m that marks the word under the
                            cursor, but doesn't put "\<" and "\>" around the word,
                            similar to the gstar command.
    {Visual}<Leader>m       Mark or unmark the visual selection.
    {N}<Leader>m            [TODO] With {N}, mark the word under the cursor with the
    {N}<Leader>gm           [TODO] named highlight group {N}. When that group is not
                            empty, the word is added as an alternative match, so
                            you can highlight multiple words with the same color.
                            When the word is already contained in the list of
                            alternatives, it is removed.

                            When {N} is greater than the number of defined mark
                            groups, a summary of marks is printed. Active mark
                            groups are prefixed with "*" (or "M*" when there are
                            M pattern alternatives), the default next group with
                            ">", the last used search with "/" (like :Marks
                            does). Input the mark group, accept the default with
                            <CR>, or abort with <Esc> or any other key.
                            This way, when unsure about which number represents
                            which color, just use 99<Leader>n and pick the color
                            interactively!

    {Visual}[N]<Leader>m    [TODO] Ditto, based on the visual selection.

    [N]<Leader>r            [TODO] Manually input a regular expression to mark.
    {Visual}[N]<Leader>r    [TODO] Ditto, based on the visual selection.

                            In accordance with the built-in star command,
                            all these mappings use 'ignorecase', but not
                            'smartcase'.

    :{N}Mark                [TODO] Clear the marks represented by highlight group {N}.
    :[N]Mark[!] [/]{pattern}[/]
                            [TODO] Mark or unmark {pattern}. Unless [N] is given, the
                            next free highlight group is used for marking.
                            With [N], mark {pattern} with the named highlight
                            group [N]. When that group is not empty, the word is
                            added as an alternative match, so you can highlight
                            multiple words with the same color, unless [!] is
                            given; then, {pattern} overrides the existing mark.
                            When the word is already contained in the list of
                            alternatives, it is removed.
                            For implementation reasons, {pattern} cannot use the
                            'smartcase' setting, only 'ignorecase'.
                            Without [/], only literal whole words are matched.
                            :search-args
    :Mark                   [TODO] Disable all marks, similar to :nohlsearch. Marks
                            will automatically re-enable when a mark is added or
                            removed, or a search for marks is performed.

    :MarkClear              Clear all marks. In contrast to disabling marks, the
                            actual mark information is cleared, the next mark will
                            use the first highlight group. This cannot be undone.

### MARK HIGHLIGHTING PALETTES

    The plugin comes with predefined palette. You can dynamically toggle between them, e.g. when you need more marks or a different set of colors.

    :MarkPalette {palette}  [TODO] Highlight existing and future marks with the colors
                            defined in {palette}. If the new palette contains less
                            mark groups than the current one, the additional marks
                            are lost.
                            You can use :command-completion for {palette}.

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your Lazy.nvim configuration.

```
return {
  "kahido/mark.nvim",
  lazy = false,
  config = function()
    require("mark").setup()
  end
}
```

LIMITATIONS
------------------------------------------------------------------------------

- If {pattern} in a :Mark command contains atoms that change the semantics of
  the entire (/\\c, /\\C) regular expression, there may be discrepancies
  between the highlighted marks and subsequent jumps to marks.
