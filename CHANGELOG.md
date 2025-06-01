0.10.6
 * flags now have verbose versions
 * stax amend - gets short name 'a'

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
