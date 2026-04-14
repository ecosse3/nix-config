# Neovim runtime dependencies
#
# All LSPs, formatters, linters, and DAPs are installed here via nix
# so Mason doesn't need to download anything. Mason-lspconfig will
# detect these on $PATH and use them directly.
#
# To add a new LSP: add the nixpkgs package here, then add the server
# name to ensure_installed in your neovim config.

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # ── LSPs ──────────────────────────────────────────────────────────
    bash-language-server
    biome
    clang-tools # provides clangd
    deno
    dockerfile-language-server
    emmet-ls
    graphql-language-service-cli
    lua-language-server
    marksman # markdown
    nil # nix (alternative to nixd)
    nixd # nix
    typescript-language-server # ts_ls fallback
    oxlint
    prisma-language-server
    pyright # python
    sqls # SQL
    tailwindcss-language-server
    terraform-ls
    tflint
    vscode-langservers-extracted # html, css, json, eslint LSPs
    vue-language-server
    yaml-language-server

    # ── Formatters ────────────────────────────────────────────────────
    prettierd
    stylua

    # ── Tree-sitter ───────────────────────────────────────────────────
    tree-sitter

    # ── DAP ───────────────────────────────────────────────────────────
    vscode-js-debug

    # ── Build tools (treesitter parser compilation) ───────────────────
    gcc
  ];
}
