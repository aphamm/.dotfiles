# install xcode
xcode-select --install 

# install rosetta
softwareupdate --install-rosetta

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# add Homebrew environment variables needed during shell login (via evaluating export statements)
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# generate ssh key
ssh-keygen -t ed25519 -C "austinpham77@gmail.com"

# start ssh-agent in background
eval "$(ssh-agent -s)"

# add key to ssh-agent
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# copy ssh public key to clipboard
pbcopy < ~/.ssh/id_ed25519.pub