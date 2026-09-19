# Technology

I currently own an iPhone 17 and a macbook air M4 2025.

## Run commands 👨‍💻

First, run the following in your terminal.

```shell
# install Command Line Tools
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
CLT=$(softwareupdate -l | sed -n 's/.*Label: \(Command Line Tools.*\)/\1/p' | tail -1)
softwareupdate -i "$CLT" --verbose
rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

# verify before cloning
xcode-select -p && git --version

# generate ssh key, start ssh-agent, add key to agent, copy to clipboard
ssh-keygen -t ed25519 -C "austinpham77@gmail.com" && \
  eval "$(ssh-agent -s)" && \
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519 && \
  pbcopy < ~/.ssh/id_ed25519.pub
```

Save ssh key to [GitHub](https://github.com/settings/keys) then...

```shell
git clone --recurse-submodules git@github.com:aphamm/.dotfiles.git ~/Documents/.dotfiles && \
  cd ~/Documents/.dotfiles/technology && ./init.sh
```

## Computer use 🥳

Download [ChatGPT](https://chatgpt.com/download/).

In a new Codex session, paste this prompt:

> I have run `~/Documents/.dotfiles/technology/init.sh`. Read `~/Documents/.dotfiles/technology/configs/computer-use.md` and use Computer Use to complete the setup it describes. The configuration files and dated Tinycast backup are in `~/Documents/.dotfiles/technology/configs/`. Work through the checklist in order, skip settings that already match, and verify each change. Leave unrelated settings and repository files unchanged. Ask me to take over when authentication or a required confirmation needs my input. If a step is blocked, continue with independent steps and report what remains. Finish with a concise list of completed and outstanding items.

## Privacy

Inspired by the following [post](https://karpathy.bearblog.dev/digital-hygiene/).

- Password Manager: [Apple Passwords](https://apps.apple.com/us/app/passwords/id6473799789)
- Search Engine: Google
  - [My Google Activity](https://myactivity.google.com/myactivity?hl=en) >
    - Web & App Activity > Turn Off & Delete
    - Timeline > Turn Off & Delete
    - YouTube History > Auto-delete 3 Months
