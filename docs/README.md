# Git compare tool

Simple command-line tool for fast comparison between two branches

## How it's useful
- you performed rebase with commit fixups/reordering/conflict resolutions  
and want to make sure new version didn't introduce any unintended code lines or dropped useful ones
- you want to see the differences between the current branch (`HEAD`) and other branch (`git cmp other_branch`)
- you want to see the differences between any two branches (`git cmp branch1 branch2`)

## Important: The same functionality is provided out-of-the-box by [git-diff](https://git-scm.com/docs/git-diff) tool

## Usage Example
1. Suppose you started with the following repository state:  
![initial_state](https://github.com/andronov-alexey/git-cmp/blob/master/docs/screenshots/Initial%20state.PNG)
2. Now suppose you want to switch order for second and third commits and edit the contents of the first commit.  
You do that with the following git command: `git rebase -i HEAD~3`  
The repository reflects the changes:  
![post-rebase_state](https://github.com/andronov-alexey/git-cmp/blob/master/docs/screenshots/Post-rebase%20state.PNG)
3. To see all the differences between `master` and `masterBackup` branches  
you can execute the following git command: `git cmp master masterBackup` (or shorter: `git cmp masterBackup`)  
Now there's two possible outputs:  
a) You didn't introduce any changes:  
![comparison_output_empty](https://github.com/andronov-alexey/git-cmp/blob/master/docs/screenshots/Example%20comparison%20empty%20output.PNG)  
b) You did introduce some changes (which may be intended or not):  
![comparison_output](https://github.com/andronov-alexey/git-cmp/blob/master/docs/screenshots/Example%20comparison%20output.PNG)  
4. Now you know exactly what changed after rebase.  
It's up to you to decide what to do next (delete `masterBackup` branch or discard rebase, for example)

## Getting Started

### Prerequisites

Installed [git](https://git-scm.com/downloads)

### Setup (with Windows examples)

1. Download and save [cmp.sh](https://github.com/andronov-alexey/git-cmp/blob/master/cmp.sh) in a folder of your preference (for example: `"C:/scripts"`)
2. Add alias to global `.gitconfig` file (default path: `"C:/users/%username%/.gitconfig"`):  
`git config --global alias.cmp '!sh C:/scripts/cmp.sh'`  
3. Check whether it works by typing in bash shell: `git cmp`  
The output should look something like this:  
```
$ git cmp
Illegal number of arguments (1-2 expected, 0 provided)
usage: C:/scripts/cmp.sh [local_committish] remote_committish
  local_committish      current tree state. HEAD by default
  remote_committish     previous tree state
  note: "committish" is a commit hash/branch name/tag
```
4. You are awesome! From now on you have a tool relieving you from anxiety after any non-trivial rebase

## Platforms
Windows & Unix

## Authors

* **Andronov Alexey** - *Idea & Implementation* - [git-cmp](https://github.com/andronov-alexey/git-cmp)
