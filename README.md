# vim-eval-expression

Evaluate a selection or text object and replace it with its result.

## Usage

- `<leader>=` in visual mode will evaluate the current selection
- `<leader>=` followed by a text object will evaluate the text object
- `<leader>==` will evaluate the current line

## Why?

This is particularly useful to evaluate mathematical expressions:

![Demo](/demo.gif)

But you can use it to evaluate anything that can be evaluated by vim. You can think of it as a shortcut to the expression (`=`) register.

## Installation

If you are using [`vim-plug`](https://github.com/junegunn/vim-plug):

```
Plug 'fvictorio/vim-eval-expression'
```

## Acknowledgements

I used the implementation of [`vim-exchange`](https://github.com/tommcdo/vim-exchange) as the basis of this plugin, and took some functions verbatim from it.
