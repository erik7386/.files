# ~/.files

This is my dotfiles repo inspired by this
[Hacker News](https://news.ycombinator.com/item?id=11071754) thread and
this [atlassian](https://www.atlassian.com/git/tutorials/dotfiles) blog post.

## Contents

- [General information](#general-information)
- [Creating a new .files git repository from scratch](#creating-a-new-.files-git-repository-from-scratch)
- [Clone to a new machine](#clone-to-a-new-machine)
- [Pull updates from remote repository](#pull-updates-from-remote-repository)
- [Push updates to remote repository](#push-updates-to-remote-repository)

## General information

In this setup the `.files` command is an alias for git with some extra
arguments pointing out `~/.local/share/dotfiles/.files.git` as if it was the
`.git` folder and `$HOME` as the work tree folder. The normal `git` command will
not see `$HOME` as a git repository.

## Creating a new .files git repository from scratch

It is assumed that the remote repository already exists at the favorite place
of the user and it is empty. Adjust the `remote` variable further below
accordingly.

Add the following alias to `.bashrc` and/or `.zshrc` after any lines that
changes the path to git.

```bash
alias .files="$(which git) --git-dir=${HOME}/.local/share/dotfiles/.files.git/ --work-tree=${HOME}"
```

Restart terminal, then run the following block of commands which creates an
initial commit (make sure `clone` matches `--git-dir` in the above alias):

```bash
clone=${HOME}/.local/share/dotfiles/.files.git
remote=github.com/erik7386/${clone##*/}
doc=${HOME}/README.md
attr=${HOME}/.gitattributes
ign=${HOME}/.gitignore

t=$(date +'%d%H%M%S')

[[ -d ${clone} ]] && mv ${clone} ${clone%.*}_${t}.${clone##*.}
git init --bare ${clone}
.files config --local status.showUntrackedFiles no
.files remote add origin https://${remote}
.files remote set-url --push origin ssh://git@${remote}

[[ -f ${doc} ]] && .files add ${doc}

[[ -f ${attr} ]] && mv ${attr} ${attr}_${t}
[[ -f ${ign} ]] && mv ${ign} ${ign}_${t}
echo "# This file is tracked in repo "${clone//${HOME}/'~'} >> ${attr}
echo '# Find the global attributes file in ~/.config/git/' >> ${attr}
echo '#' >> ${attr}
echo "# This file is tracked in repo "${clone//${HOME}/'~'} >> ${ign}
echo '# Find the global ignore file in ~/.config/git/' >> ${ign}
echo '#' >> ${ign}
echo ${clone//${HOME}/}/ >> ${ign}
echo '/.ssh/' >> ${ign}
echo '*.env' >> ${ign}
.files add ${attr} ${ign}
.files commit -m 'Initial commit'
```

Follow [Push updates to remote repository](#push-updates-to-remote-repository)
to add files and/or changes.

## Clone to a new machine

Run the following commands directly in a bash/zsh terminal. You may copy&paste
all in one go.

Basically the commands will clone the repo, backup existing files in `${HOME}`
that are to be overwritten by checkout operation and do the actual checkout.

```bash
clone=${HOME}/.local/share/dotfiles/.files.git
remote=github.com/erik7386/${clone##*/}
function .files { git --git-dir=${clone}/ --work-tree=${HOME} "$@"; }
git clone --bare https://${remote} ${clone}
#.files remote set-url --push origin ssh://git@${remote} # Only for maintainer
.files config --local status.showUntrackedFiles no
f=$(ls $(.files ls-tree --full-tree -r --name-only HEAD) 2>/dev/null) || true
[[ "${f}" != "" ]] && tar -czf ${clone}-backup-$(date +'%d%H%M%S').tar.gz ${f}
.files checkout --force HEAD -- .
```

Restart shell.

## Pull updates from remote repository

This is how to pull updates from the remote repository.

```bash
s=$(.files stash)
.files checkout $(.files rev-parse --verify HEAD)
.files fetch --prune origin +master:master
.files checkout master
[[ "No local changes to save" != "${s}" ]] && .files stash pop
```

Restart shell.

## Push updates to remote repository

Same as normal `git` commands, but use `.files` alias.

- update any file or set of files within `${HOME}` that should be tracked in
  repository `~/.local/share/dotfiles/.files.git`,
- stage the files (`.files add ...`),
- make a new commit (`.files commit ...`),
- push to remote (`.files push ...`),
- repeat.

