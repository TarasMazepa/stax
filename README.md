# Stax

Stax is a tool that will help you a bit with day-to-day stax-like git workflow.

Main purpose is to make it easier to create smaller PRs. And reduce amount of energy other people need to review them.

## Installation

### MacOS/Linux/WSL on Windows/ChromeOS

Homebrew is a package manager that works on MacOS and Linux systems.

#### Install brew

##### MacOS

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

##### Linux/WSL on Windows/ChromeOS

See https://docs.brew.sh/Homebrew-on-Linux

#### Install stax

```
brew install TarasMazepa/stax/stax
```

### Windows

Clone this repo and put the path to the repo into your PATH variable.

Let me know if you need some help. Create a ticket on the repo.

## stax doctor

Will help you to set up everything that stax needs to start working
```
stax doctor
```
```
[V] git config --get user.name # TarasMazepa
[V] git config --get user.email # 6552358+TarasMazepa@users.noreply.github.com
[V] git config --get push.autoSetupRemote # true
```
Stax will give you advice on how to configure everything.
```
stax doctor
```
```
[X] git config --get user.name # null
    X Set your git user name using:
      git config --global user.name "<your preferred name>"
[X] git config --get user.email # null
    X Set your git user email using:
      git config --global user.email "<your preferred email>"
[X] git config --get push.autoSetupRemote # false
    X Set git push.autoSetupRemote using:
      git config --global push.autoSetupRemote true
```


## v1 Roadmap

| Feature                                            | Status |
|----------------------------------------------------|--------|
| [commit](#stax-commit)                             | ✅      |
| [amend](#stax-amend)                               | ✅      |
| [delete-gone-branches](#stax-delete-gone-branches) | ✅      |
| [pull](#stax-pull)                                 | ✅      |
| [log](#stax-log)                                   | 🚧     |
| rebase                                             | 🔲     |
| squash                                             | 🔲     |

## v2 Roadmap

Would be an UI tool that will implement all features from v1.

## What is stax-like git workflow?

It is a way to reduce the burden of creating commits, branches, and PRs, so it doesn't consume much of your time. As a result, you can start creating more PRs with smaller changes in them and have them reviewed easier and faster at the same time catching more bugs.

## Commands

To see full list of commands, run:
```
stax help
```

Here is the list of commands currently available:

### stax commit
Creates branch, commits current changes with the same name as a branch, and pushes.

![stax commit diagram](https://private-user-images.githubusercontent.com/6552358/346191698-013c5848-1697-49b2-a1b2-17f17eeea9cb.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MjAyMDA3MjMsIm5iZiI6MTcyMDIwMDQyMywicGF0aCI6Ii82NTUyMzU4LzM0NjE5MTY5OC0wMTNjNTg0OC0xNjk3LTQ5YjItYTFiMi0xN2YxN2VlZWE5Y2IucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI0MDcwNSUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNDA3MDVUMTcyNzAzWiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9YTNmNzIzN2NlNGJjYjg1ZWJmYmM5NjIwYzFkY2MyMTg4ODRlMmU0YWYzNmY1ZmE4OWM3NTk3ZjU2OGY3NTQ0MyZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmYWN0b3JfaWQ9MCZrZXlfaWQ9MCZyZXBvX2lkPTAifQ.wnOKubzfGHjdn-Gj3VNDD7AWbW6SHqGda3iRkfyqlk8)

```
stax commit "two-in-one-commit-name-and-branch-name"
```
Result:
```
commit 8161c952fbed66672aff80cd3d1233589cdc3c0c (HEAD -> two-in-one-commit-name-and-branch-name, origin/two-in-one-commit-name-and-branch-name)
Author: Taras Mazepa <taras.mazepa@example.com>
Date:   Fri Sep 8 14:58:04 2023 -0700

    two-in-one-commit-name-and-branch-name

```
You can see that a branch with `two-in-one-commit-name-and-branch-name` name was created as well as a commit with the same name `two-in-one-commit-name-and-branch-name`.

#### -a flag
Adds all the files to staging area

#### --pr flag
Redirects you to a create PR page

### stax amend
Amends to the current commit and force pushes branch

![stax amend diagram](https://private-user-images.githubusercontent.com/6552358/346192379-c3025256-2e4f-4c8f-95c1-095ab9b8b514.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MjAyMDA5MDQsIm5iZiI6MTcyMDIwMDYwNCwicGF0aCI6Ii82NTUyMzU4LzM0NjE5MjM3OS1jMzAyNTI1Ni0yZTRmLTRjOGYtOTVjMS0wOTVhYjliOGI1MTQucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI0MDcwNSUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNDA3MDVUMTczMDA0WiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9NzY4MDgyZTlhYzdjMWU5NWRhNjBkMTAwMzVlZmNlMzE5MDI1NGNiNDA2NDYyM2NiZmQzN2NmYWE1ZWE0ZTNlNiZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmYWN0b3JfaWQ9MCZrZXlfaWQ9MCZyZXBvX2lkPTAifQ.fy6tvwSFABXzAhI6XMNh7RGNWR03WCxvtHSzPshsK7Y)

```
stax amend
```

### stax delete-gone-branches
Deletes local branches with gone remotes. Useful when you are using `stax-commit` which pushes all the branches. So once they are merged and deleted from the remote you can clean up local branches.

![stax delete-gone-branches diagram](https://private-user-images.githubusercontent.com/6552358/346191719-55be3cf5-3667-4568-a8b0-785f623ec680.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MjAyMDA5MDQsIm5iZiI6MTcyMDIwMDYwNCwicGF0aCI6Ii82NTUyMzU4LzM0NjE5MTcxOS01NWJlM2NmNS0zNjY3LTQ1NjgtYThiMC03ODVmNjIzZWM2ODAucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI0MDcwNSUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNDA3MDVUMTczMDA0WiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9NmJjZDRlNzgxMjdkYmJkMTYzNGQxYzk1ZWUzNTUxNmNjNWU3MjQ4N2NiMTM2YmJhZjI0NDQ5NmFjYjMyZDU3ZSZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmYWN0b3JfaWQ9MCZrZXlfaWQ9MCZyZXBvX2lkPTAifQ.8rRja0TTz6V0e5HjtQY0cxJkEGwKW0U5sW8XdKPJtC0)

### stax pull
Switching to main branch, pull all the changes, deleting gone branches and switching to original branch.

![stax pull diagram](https://private-user-images.githubusercontent.com/6552358/346191746-581b2384-2cce-4e78-9be2-76241e0f6c8e.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MjAyMDA5MDQsIm5iZiI6MTcyMDIwMDYwNCwicGF0aCI6Ii82NTUyMzU4LzM0NjE5MTc0Ni01ODFiMjM4NC0yY2NlLTRlNzgtOWJlMi03NjI0MWUwZjZjOGUucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI0MDcwNSUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNDA3MDVUMTczMDA0WiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9ZDQwYzM2MDM2ZDYyMTM5N2I3MWVjMzY5NWJhNTY1MzY4MTZhMmQwMzdkYTVkMTQ3Y2UwYTBkM2U3MzQyZWI4MSZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmYWN0b3JfaWQ9MCZrZXlfaWQ9MCZyZXBvX2lkPTAifQ.GwJgj_-hx6XAFWfIJ9Q7387udbNOkGxD7z3z8Y4VS7Q)

### stax log
Outputs tree like structure of your branches
