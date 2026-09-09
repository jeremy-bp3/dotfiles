# Dotfiles

Chezmoi-managed macOS configuration with `personal` and `work` machine
profiles. The selected profile controls the rendered Homebrew and Zsh
configuration.

## 1. Install Apple Command Line Tools

Homebrew requires either the Xcode Command Line Tools or full Xcode. The
Command Line Tools are sufficient for this setup:

```sh
xcode-select --install
```

Complete the graphical installer, then verify the installation:

```sh
xcode-select -p
git --version
```

## 2. Install Homebrew

Run the official installer:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

At the end, Homebrew prints commands that add `brew` to the current shell.
Run those commands before continuing. They differ between Apple Silicon and
Intel Macs.

Verify Homebrew and check its environment:

```sh
brew --version
brew doctor
```

Review any actionable warnings from `brew doctor`.

## 3. Install Chezmoi

```sh
brew install chezmoi
chezmoi --version
```

## 4. Initialize The Dotfiles

Clone the source state without applying it yet:

```sh
chezmoi init https://github.com/jeremy-bp3/dotfiles.git
```

When prompted, select the machine profile:

- `personal` installs the shared personal toolset.
- `work` also includes work-specific tools and shell configuration.

If the repository requires authentication, authenticate with GitHub first or
use an SSH URL after configuring an SSH key.

Confirm the selected profile:

```sh
chezmoi execute-template '{{ .profile }}'
```

Inspect what chezmoi will install:

```sh
chezmoi cat ~/.config/homebrew/Brewfile
chezmoi ignored
chezmoi diff
```

Do not use `chezmoi init --apply` for the initial setup. The TPM bootstrap
script requires `tmux`, which is installed later by the Brewfile.

## 5. Apply Files Without Scripts

Install the rendered dotfiles while withholding bootstrap scripts:

```sh
chezmoi apply --exclude=scripts --verbose
```

This creates `~/.config/homebrew/Brewfile` for the selected profile.

## 6. Install Packages And Applications

```sh
brew bundle --file="$HOME/.config/homebrew/Brewfile"
```

Homebrew Bundle installs only missing dependencies, so it is safe to run
again after resolving a failed or interrupted installation.

Verify the bundle:

```sh
brew bundle check --file="$HOME/.config/homebrew/Brewfile"
```

Some applications may require their own first-run setup, sign-in, macOS
privacy permissions, or work credentials.

## 7. Run Bootstrap Scripts

Now that the Brewfile has installed `tmux`, run the chezmoi scripts:

```sh
chezmoi apply --include=scripts --verbose
```

This runs the one-time TPM bootstrap and installs the configured tmux plugins.

## 8. Start A Fresh Shell

```sh
exec zsh -l
```

Verify the resulting setup:

```sh
chezmoi status
brew bundle check --file="$HOME/.config/homebrew/Brewfile"
tmux
nvim
```

`chezmoi status` should normally produce no output.

## 9. Complete Machine-Specific Setup

- Sign in to installed applications and grant only the macOS permissions they
  require.
- On a work machine, configure required VPN, cloud, GitHub, and company
  credentials.
- Configure any runtimes managed by `mise` that are needed on this machine.
- Confirm the Git identity before creating commits:

```sh
git config --global user.name
git config --global user.email
```

## Current Repository Caveats

- `.gitconfig` currently contains the work email address for every profile.
  Template it before using this repository on a personal machine if that
  identity is not appropriate. A manual edit to `~/.gitconfig` will be
  overwritten by a future `chezmoi apply`.
- `.config/zsh/aliases.work.zsh` is ignored by chezmoi and must be provisioned
  separately if it is required on a work machine.

## Routine Updates

Pull source changes, review them, and apply them:

```sh
chezmoi update --dry-run
chezmoi update
```

Reconcile Homebrew after Brewfile changes:

```sh
brew bundle --file="$HOME/.config/homebrew/Brewfile"
```

## References

- [chezmoi documentation](https://www.chezmoi.io/)
- [Homebrew installation](https://docs.brew.sh/Installation)
- [Homebrew Bundle](https://docs.brew.sh/Brew-Bundle-and-Brewfile)
- [Update macOS](https://support.apple.com/en-us/108382)
