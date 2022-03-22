#!/bin/sh
DATE="$(date +%Y-%m-%d-%H-%M-%S)"
borg create ssh://z/srv/backup-borg::backup-$DATE \
    $HOME \
    --progress \
    --exclude-caches \
    --exclude $HOME/.cache \
    --exclude $HOME/.local/share/keybase/kbfs_block_cache \
    --exclude $HOME/keybase \
    --exclude $HOME/.cargo/registry \
    --exclude $HOME/.cargo/bin \
    --exclude $HOME/.cargo/git \
    --exclude $HOME/.cabal \
    --exclude $HOME/.rustup \
    --exclude $HOME/.stack \
    --exclude $HOME/.npm \
    --exclude $HOME/go/pkg \
    --exclude $HOME/.local/share/NuGet/v3-cache \
    --exclude $HOME/src \
    --exclude $HOME/tmp \
    --exclude $HOME/.isabelle/Isabelle*/heaps \
    --exclude $HOME/Downloads
