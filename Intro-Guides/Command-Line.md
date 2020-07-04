# COMMAND LINE

This guide is an introduction to working on the command line. I'm working exclusively on MacOS (10.15 Catalina), so your mileage may vary on Linux. If you're on Windows, *very little* of this guide will carry over.

If you want to dive deeper after going through everything below, **[MIT's Missing Semester](https://missing.csail.mit.edu/)** is an excellent next step. Most of what I will explain below I learned in whole or in part from those lectures.

If I've made any mistakes, as I'm sure I have, please feel free to submit a pull request or raise an issue.

## STEP 0: Getting Started

**PREREQUISITES**

- _Basic familiarity with programming concepts_: You know your code fundamentals (loops, variables, etc) and can solve basic challenge questions via an online sandbox. You know the difference between *writing* and *running* a program, and you have some idea of what *source code* means and how to save your source code files.
- _Computer basics_: You should know the difference between files and folders (*directories*) and how file endings work (*.txt, .js, etc.*). You understand the relationships between nested directories and files.
- _Homebrew_: Also referred to as `brew`, [Homebrew](https://brew.sh/) is the "missing package manager for macOS." It lets you install tons of different programs from and/or for the command line. If you don't already have Homebrew installed, I'd suggest doing so now. [Installing Homebrew](https://brew.sh) will make it easier to copy-paste many install commands found in this guide and on the web. 

**TERMINOLOGY** . 
* Command Line: The **command line** typically refers to the logical interface that lets you enter text commands for the operating system (OS) to directly execute. It operates as a REPL, or [read-evaluate-print loop](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop). On modern computers, it is usually accessible through a customizable, text-based GUI (ie, the window with a prompt where you enter your commands).
* CLI: Stands for *command line interface*. It can be used somewhat synonymously with *command line*, or to refer to the applications that let you interact with the command line, like Terminal. It can also be used colloquially to refer to the features of a program that can be accessed directly through the command line (like the *ESLint CLI*).
* Terminal: The **terminal** is really a *terminal emulator*. It refers to the application you use to access your command line, particularly the GUI (or _graphical user interface_) aspects. Confusingly, the default Mac terminal app is just called Terminal. A popular 3rd-party terminal alternative is [iTerm2](https://www.iterm2.com/).
* Shell: The shell is the logical program that exchanges commands and return values between the terminal and command line. It runs inside the terminal and is, in essence, a command processor. Two of the most popular shells are [Bash and Zsh](https://stackabuse.com/zsh-vs-bash/) (commonly pronounced "Zee-shell"). **_Everything in this guide has been tested using the default macOS Terminal and Bash._** If you are using a different terminal emulator or shell, there may be some parts of this guide that do not directly translate. Most of the concepts should remain the same. The most recent macOS version (10.15 Catalina) includes Zsh as a default option, so you may find [this walkthrough](https://scriptingosx.com/2019/06/moving-to-zsh/) helpful for translating Bash-specific info to Zsh.  
Note: *bash* can also refer to the simple programming language that is understood by Bash and other shells. The *bash* language can be used to write [shell scripts](https://flaviocopes.com/bash-scripting/).

**_Please see the notes in my [ESLint-Prettier guide](./ESLint-Prettier.md#a-few-words-on-npm) if you are not familiar with the very basics of NPM as well._** 

## STEP 1: Navigating the Filesystem
- What is the filesystem & location within the terminal
- < pwd > < cd > < ls >
- relative and absolute navigation
- Root vs Home
- User, Root, and Sudo
- Hidden files & folders
- files as text / file extensions (with a note on Vim)

## STEP 2: Structure Of A Command
- < command > < flags > < arguments &or files >
- flags, --help, --version, man pages, tldr
- stdin & stdout, writing to file, piping, & tee

## STEP 3: Common Commands and Flags
- table of commands, optional flags, and meaning / action

## STEP 4: Customizing Your Terminal
- .bash_profile
- aliases
- modifying $PATH
- customizing the prompt
- < source >

## Notes
- Updating Bash on new Macs
