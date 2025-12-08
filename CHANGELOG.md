0.10.22
 * stax delete-stale - now gets short command name 'd' and is invokable with `stax d`

0.10.21
 * stax rebase - adds more details into 'Rebase is already in progress' error

0.10.20
 * stax log - fix overly aggressive single parent resolution

0.10.19
 * stax log - fix braking change from last update
 * stax log - will only output at most 100 lines (useful for stax log --all on repositories with a lot of remote branches)

0.10.18
 * stax log - will survive repository with big amounts of merge commits

0.10.17
 * stax log - will now detect cycles in the tree if they involve remote/HEAD

0.10.16
 * stax log - if repository has many "original" commits (the ones without parent) stax will make sure to select one which has access to the remote head, as stax would ensure that each node will only have one parent

0.10.15
 * stax log - now only requests 100k latest commits from git log to build tree, which improves performance on repositories with larger amount of commits

0.10.14
 * stax log - fixes a bug when new logic causes stack overflow for larger repositories 

0.10.13
 * stax get - fix case when stax get would not search for remote refs specifically, which will result in it not being able to "get" branches
 * stax log - making sure that merge commit resolution would not get rid of remote head tree

0.10.12
 * stax log - and other commands that rely on it would now handle merge commits better, also fixed couple of stack overflow cases

0.10.11
 * --loud -> --verbose - renaming global flag to conform with other commandline tools, adds -v shorthand
 * stax pull - will not attempt to switch back to a branch that was just deleted
 * stax log, stax move - now will see node tree in the same way, so stax move commands like stax move up 1, will select child commit with index 1, and not a random one based on stax move tree that wasn't sorted with the same method as stax log
 
0.10.10
 * stax delete -> stax delete-stale - renaming delete to delete-stale
 * --silent -> --quiet - renaming global flag to conform with other commandline tools, adds -q shorthand
 * stax delete-stale - fix case when remote and local branches have different names and stax delete-stale wouldn't recognize that branches as gone due to overly strict parsing

0.10.9
 * stax log - fix case when repo has more then one commit without parents and stax chooses the wrong one to build tree for

0.10.8
 * stax log - change paging logic, now it tries to read as much as it can and if there is more - try reading again, adds some logs which could be fun to read with --loud

0.10.7
 * stax log - will read git log in chunks to avoid hitting an edge case when git log would not fit into a single invocation
 * fix a bug when stax will fail on submodules/worktrees when trying to find appropriate .git directory to initialize its own repository specific settings 

0.10.6
 * flags now have verbose versions
 * stax amend - gets short name 'a'
 * stax move - fix case when move can't navigate to detached commits

0.10.5
 * stax pull - fix that stax will not return to a previous branch if there is no gone branches to delete

0.10.4
 * stax pull-request - will honor base branch replacement setting
 * stax commit - will come back to original branch even if user haven't used Pull Request creation flag
 * stax about - new command with brief information about stax, link to the website and basic license information
 * git checkout -> git switch - replaced all internal invocations of git checkout to git switch
 * stax help - now accepts optional argument to show help only for one command
 * --help is new global flag which you can call on any stax command you run
 * stax pull - now does git pull with prune so it doesn't need to run git fetch --prune to check gone branches

0.10.3
 * stax rebase - now creates folder structure for rebase file
 * stax rebase - fix for rebase file path on windows

0.10.2
 * technical release

0.10.1
 * stax rebase - assumes default branch when no argument supplied

0.10.0
 * stax delete-gone-branches - renamed to delete

0.9.52
 * stax settings - now public
 * stax settings - now supports repository specific settings

0.9.51
 * stax amend - fixing rebase

0.9.50
 * stax rebase - now supports resumable rebase
 * stax amend - now has working rebase

0.9.49
 * stax help - now shows command short names too 
 * stax commit - adds -i flag to ignore no staged changes

0.9.48
 * stax doctor - mark GitHub CLI installation as optional
