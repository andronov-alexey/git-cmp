#!/bin/sh

function print_usage {
    echo "usage: $0 [local_committish] remote_committish"
    echo "  local_committish      current tree state. HEAD by default"
    echo "  remote_committish     previous tree state"
    echo "  note: \"committish\" is a commit hash/branch name/tag"
}

if [ ! -z "$(git status --porcelain)" ];
then
  echo "Working directory is not clean. Please save uncommitted changes first"
  exit 1
fi

CurrentBranchName=`git rev-parse --abbrev-ref HEAD`
CurrentBranchHash=`git rev-parse --verify HEAD`

ArgsCount=$#
if [ $ArgsCount -lt 1 -o $ArgsCount -gt 2 ];
then
  echo "Illegal number of arguments (1-2 expected, $ArgsCount provided)"
  print_usage
  exit 2
elif [ $ArgsCount -eq 1 ]
then
  CurrentCommit=$CurrentBranchHash
  RemoteCommit=$1
elif [ $ArgsCount -eq 2 ]
then
  CurrentCommit=$1
  RemoteCommit=$2
fi


MergeBaseCommit=`git merge-base $RemoteCommit $CurrentCommit`
echo "common parent commit: $MergeBaseCommit"

BranchPostfix="GitCmpTempBranch"
LocalBranchAllChanges=""$RemoteCommit$BranchPostfix
git checkout -b $LocalBranchAllChanges $RemoteCommit --quiet
if [[ $? -ne 0 ]];
then
    exit 3
fi

git reset --soft $MergeBaseCommit
git commit -m "$(git log --format=%B --reverse HEAD..HEAD@{1})" --quiet

RemoteBranchAllChanges=""$CurrentCommit$BranchPostfix
git checkout -b $RemoteBranchAllChanges $CurrentCommit --quiet
if [[ $? -ne 0 ]];
then
    exit 4
fi

git reset --soft $MergeBaseCommit
git commit -m "$(git log --format=%B --reverse HEAD..HEAD@{1})" --quiet

git checkout $CurrentBranchName --quiet
git diff $LocalBranchAllChanges $RemoteBranchAllChanges
git branch -D $LocalBranchAllChanges $RemoteBranchAllChanges --quiet

# delete .orig files
echo "cleaning..."
git clean -f
echo "...done"

exit 0
