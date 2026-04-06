# Neovim 0.12 compatibility note

This repo was adjusted to load cleanly on Neovim 0.12 without changing existing global keymaps.

## Unavoidable behavior difference

Java support now fails soft instead of failing hard during startup:

- If `jdtls` is not installed or not on `PATH`, the Java plugin setup is skipped for that session.
- If `LOMBOK`, `VSCODE_JAVA_DEBUG`, or `VSCODE_JAVA_TEST` are unset, the related optional Java extras are skipped instead of crashing startup.

Why this changed:

- Under the previous config, missing Java tooling or env vars aborted Neovim startup.
- On Neovim 0.12, keeping that behavior would mean the whole config remains broken even when you are not editing Java.

What did not change:

- Existing non-Java keymaps stay the same.
- When `jdtls` and the optional env vars are available, Java behavior is intended to stay the same as before.
