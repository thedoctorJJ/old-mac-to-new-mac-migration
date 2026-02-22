# How to unblock the Cursor agent (git / .git writes)

When the agent runs terminal commands, Cursor uses a **sandbox** that blocks writes to `.git` (e.g. `git init`, `git commit`, `git push`). To let the agent run those commands on your machine:

---

## Option 1: Cursor Settings (recommended)

1. Open **Cursor Settings**: **`Cmd+Shift+J`** (Mac) or **`Ctrl+Shift+J`** (Windows/Linux).
2. Go to the **Agent** (or **Features → Agent**) section.
3. Find the terminal / sandbox behavior control. It may be named:
   - **"Auto-Run in Sandbox"** — turn this **off** so the agent can run outside the sandbox (or so you get approval prompts and can choose "Run").
   - **"Run in Sandbox"** — disable to allow full terminal access.
   - Or a mode like **"Ask Every Time"** / **"Run Everything"** — **"Run Everything"** skips the sandbox (use only if you accept the risk; Cursor warns against it).
4. If you see **"Allow git writes without approval"** or similar, enable it so git commands can run without being blocked.
5. Reload Cursor or start a new chat so the agent uses the new setting.

---

## Option 2: When a command fails

If the agent runs a command and it fails with "Operation not permitted" on `.git`:

- Check the **agent’s terminal output** for a **"Run"**, **"Run without sandbox"**, or **"Add to allowlist"** button.
- Click it to run the same command **outside the sandbox** (or add it to the allowlist for future runs).

---

## Option 3: Run the command yourself

The sandbox only affects **agent-run** commands. Anything you run in **your** terminal (Cursor’s integrated terminal: **View → Terminal** or **\`**) runs with full permissions. So you can always paste and run the command yourself there.

---

## Summary

| Goal                         | Action |
|-----------------------------|--------|
| Let agent run git commands  | Cursor Settings → Agent → disable "Auto-Run in Sandbox" or enable "Allow git writes" (exact names may vary). |
| One-off unblock             | When a command fails, use "Run without sandbox" / "Add to allowlist" if shown. |
| No setting change           | Run the command in your own terminal (View → Terminal). |
