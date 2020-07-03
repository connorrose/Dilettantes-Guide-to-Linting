# ESLINT > AIRBNB > PRETTIER > VS CODE

This guide will attempt to walk you through every step of setting up a linting workflow for your Javascript files. I'm working exclusively on MacOS (10.15 Catalina), so your mileage vary on Linux and Windows. The focus is on vanilla browser-based Javascript, but we'll include incidental coverage for some React and jQuery syntax along the way. Following these steps will:

1. Install [ESLint](https://eslint.org/) locally to check your code for style and structural errors.
1. Set the [AirBnB Style Guide](https://github.com/airbnb/javascript) as your default ruleset.
1. Install either [Prettier](https://prettier.io/docs/en/index.html) or [this fork](https://github.com/btmills/prettier) of Prettier to auto-format common styling mistakes whenever you save a Javascript file.
1. Integrate ESLint and Prettier into VS Code so that all formatting work can be done live within the editor.

If I've made any mistakes, as I'm sure I have, please feel free to [submit a pull request](https://www.freecodecamp.org/news/how-to-make-your-first-pull-request-on-github-3/) or [raise an issue](https://docs.github.com/en/enterprise/2.15/user/articles/creating-an-issue). If you follow everything listed in here and it still won't work (and you're on Mac), just get in touch and I'll do my best to help you troubleshoot.

## GETTING STARTED

**[This article](https://blog.echobind.com/integrating-prettier-eslint-airbnb-style-guide-in-vscode-47f07b5d7d6a) was the original inspiration for this guide.** After spending some time in VS Code with that setup, I've made some changes that stay closer to AirBnB's style guide docs while adding context and simplifying configuration slightly. If just want a list of my install commands without the explanation, see the [TLDR version](./TLDR-eslint.md). 

This guide is specifically focused on using ESLint & Prettier within VS Code, rather than directly through the [ESLint CLI](https://eslint.org/docs/user-guide/command-line-interface). If you're not yet comfortable using VS Code as your primary editor, [@seyitaintkim's VS-Code write-up](https://github.com/seyitaintkim/VS-Code) covers a lot more ground than what I've written here. Again, my goal is simply to make the ESLint / Prettier / VS Code install as straightforward as possible with a detailed walkthrough.

**PREREQUISITES**

- **Basic command line skills:** You can mostly copy-paste the commands in this guide, but knowing how to `cd / ls / etc`, as well as how to use _flags_ (like `<command> --help`) will help.
- **VS Code basics:** I'm assuming that you're already using VS Code, and that you understand the basics of how to navigate around it. If not, read [Sey's guide](https://github.com/seyitaintkim/VS-Code) first.
- **_npm_ already installed:** If you're not sure if you have npm, type `npm --version` into your terminal (and hit enter). If you see a number, you have npm installed already. If not, follow [this link](https://www.npmjs.com/get-npm) to install Node & npm. __**npx**__ ([a similar tool](https://medium.com/@maybekatz/introducing-npx-an-npm-package-runner-55f7d4bd282b)) should be installed automatically alongside npm. You can confirm this by running `npx -v` and looking for the version number. If you'd like a little background on what exactly npm _is_, see the [notes](#a-few-words-on-npm) below.
- **Terminology => Linter:** A linter is a program that can parse your source code to detect errors or styling inconsistencies. Linters are useful for making sure multiple developers can work on a project in a consistent code style with as few errors as possible. ESLint is a powerful linter with lots of built-in functionality and extensibility. Prettier is a more narrowly focused _code formatter_ that can auto-fix many style errors. It works by taking an [AST representation](https://blog.buildo.io/a-tour-of-abstract-syntax-trees-906c0574a067) of your code and re-printing it according to predefined & opinionated style rules. (For a bit more info on Prettier's design principles & under-the-hood implementation, see [this blog post](https://jlongster.com/A-Prettier-Formatter)).

## STEP 0: Picking a folder

All of the installation commands below should be entered while in a single folder in your terminal. Whatever folder you pick for this installation will then contain your installed packages and configuration files. ESLint will be available to other files within that folder, as well as to files within any sub-folders.
For example, I've set up my _Software Immersive_ workspace along this path:

`~/Desktop/Coding/Course-Name/Immersive`

where `~` is my home folder (literally `/Users/connorrosedelisle`). ESLint & Prettier are installed in this **`Immersive`** folder. The **`Immersive`** folder, or _directory_, then contains multiple sub-folders, or _sub-directories_, each of which is an assignment or project I've cloned from GitHub. Because these assignment sub-directories are _inside_ the folder where I've installed ESLint and Prettier, the linter will still have access to them. The cloned projects are each tracked as their own separate git repositories, while the **`Immersive`** folder itself is **_not_** tracked via [git](./Git-Github.md) / version control.

You don't have to copy my exact directory path set-up; just make sure you pick an install folder that can contain all of the projects you want linted and fixed (with the same AirBnB style rules). Remember that _every_ sub-directory will be following this configuration, so don't pick a folder that contains outside projects already following their own style guides. Once you've decided on a folder for installation, you should navigate to that folder within your terminal and move on to the next step.

## STEP 1: Install ESLint 

Before we get started, we will create a **`package.json`** file to keep track of what we've installed. First, make sure you're on the command line (_ie_, in Terminal) within the folder you've chosen (_hint:_ `pwd`). To create **`package.json`** using automatic default values, we will _initialize via npm_:

`npm init --yes`

This do will do a few things:
1. Initialize our current folder as an _npm package_. This isn't relevant to our current task, but with a few tweaks we could technically register our current folder and all the code it contains with [npm](https://docs.npmjs.com/about-npm/). To over-simplify, npm packages are just directories containing code files and a completed `**package.json**`. Which brings us to:
1. Create a **`package.json`** file in the current directory. As discussed, this file will now keep track of many of the additional packages we'll be installing.
1. Set some default values within **`package.json`** including a _name_, _version number_, and _license_. Since we don't plan to directly publish our folder on npm, we won't worry about any of these values. However, you can look through [the docs](https://docs.npmjs.com/files/package.json) for more information.

Once we've initialized our folder, we can install the core ESLint package:

`npm install eslint --save-dev`

###### (You can safely ignore any `npm WARN` messages about missing descriptions or fields.)

This will:
1. Create a folder called **`node_modules`** where all the packages we install will be stored.
1. Install ESLint within **`node_modules`**.
1. Register ESLint as a `dev-dependency` in **`package.json`**.
1. Install all the other packages ESLint depends on, as shown in **`npm`**'s terminal output.
1. Create a **`package-lock.json`** file in the current directory. This file will automatically keep track of the version information of the packages we install, as well as the required version numbers for any of their dependencies.

<details>
<summary><i>technical aside</i></summary>
The <code>--save-dev</code> flag will register the package we just installed as a <i>Development Dependency</i> within <code>package.json</code>. Dev-dependencies are packages required only during the development phase, rather than in production. That is, they are packages that help us <i>write</i> our code, but they do not contribute any functionality to the code we deploy to users.
</details>

Next, without changing folders, install the AirBnB configuration for ESLint:

`npx install-peerdeps --dev eslint-config-airbnb`

The `eslint-config-airbnb` package adds AirBnB's style guide as a ruleset within ESLint. However, this ruleset is not enabled automatically. To force ESLint to follow the AirBnB rules, we need to set up our ESLint configuration file. To start, create a new file (in the same folder we've been working in) called **`.eslintrc.json`**:

`touch .eslintrc.json`

The leading dot in front of the filename is very important! (Read more on _dotfiles_ in the [notes](#what-the-heck-are-dotfiles).) This file will be in the **JSON** format, which lets us store our ESLint settings as properties on an object. Using a standardized file format like JSON allows many different programs, including VS Code, to interact with our settings configuration. The ESLint _config_ file can also be written in Javascript or [YAML](https://rollout.io/blog/yaml-tutorial-everything-you-need-get-started/), but JSON will be the simplest for our purposes.

Now, open up **`.eslintrc.json`** in VS Code or another file editor, and copy in the below:

```json
{
  "env": {
    "browser": true,
    "es6": true
  },
  "extends": [
    "airbnb"
  ]
}
```
`env:` sets the environments in which we expect to run our code. We've enabled support for browser-based Javascript, as well as the modern Javascript features introduced by [ES6 / ECMAScript 2015](https://www.geeksforgeeks.org/introduction-to-es6/).  
`extends:` is where we set the AirBnB ruleset we installed with `eslint-config-airbnb`. Our current environment will be an _extension_ of the rules in the AirBnB package.  

**YAY!!** We've finished installing ESLint with a basic working configuration. One more step before we have our awesome new linting abilities enabled in VS Code.

## STEP 2: VS Code Integration

If you're not already in VS Code, open it up now. Open up the [Extensions pane](https://code.visualstudio.com/docs/editor/extension-gallery) and search for [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) by Dirk Baeumer. Click the _Install_ button.

Now that the ESLint extension is installed, we just need to update our VS Code settings to use ESlint as our default formatter and to format our code autmatically when saving. If you're not sure how to access your VS Code settings, review [Sey's guide](https://github.com/seyitaintkim/VS-Code) one more time. (_Hint:_ CTRL+SHFT+P > "Open Settings")

Once you've found your VS Code settings, update the following:

```json
{
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "editor.defaultFormatter": "dbaeumer.vscode-eslint",
  "eslint.alwaysShowStatus": true
}
```

You can either search for these setting by name in the VS Code Settings GUI, or directly paste the above code (without the outermost set of curly braces) into your VS Code `**settings.JSON**` file.
`editor.CodeActionsOnSave` will allows VS Code to use ESLint to re-format many of our code errors whenever we save a file.  
`editor.defaultFormatter` sets the ESLint extension as our default formatter for all files in VS Code.
`eslint.alwaysShowStatus` just adds the little ESLint menu item to the status bar along the bottom of VS Code. If you want to explore all of the VS Code settings available for ESLint, check out the extension [documentation](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint).

`**You're finally done!**` You should now see ESLint highlighting any errors in your Javascript code files, and it should even fix a few simple style mistakes on save, such as single-quote vs. double-quote for strings. If you're not seeing any results, see the [Notes](#checking-if-your-install-worked) below for some trouble-shooting tips.

_...but wait._ What about Prettier? Well, that's where things get complicated. If you're happy with the error messages and auto-fixing we've enabled so far, feel free to stop here. However, if you want more powerful auto-formatting, including automatic line breaks for long lines (think lots of function parameters), then continue on to Step 3 below.

## STEP 3: Install Prettier & Plugins

// PENDING UPDATE //

Open your `.eslintrc.json` file for editing. For the simplest configuration, copy and place the below code exactly as-is, overwriting any existing code:

.prettierrc

Start by checking if either of these files already exist in the directory where you just installed the ESLint and Prettier npm packages. If they don't, you can create them either using `touch < filename >` in the terminal or directly in VS Code's File Explorer. **Make sure you include the leading dot for both, and the .json extension only for ESLint.**

```
{
  "extends": ["airbnb", "prettier"],
  "plugins": ["prettier"],
  "rules": {
    "prettier/prettier": ["error"]
  },
}
```

```
{
  "printWidth": 100,
  "singleQuote": true
}
```

Next, open your `.prettierrc` file and paste in the following:

This modifies two of the default Prettier rules to bring them in line with AirBnB. You've now finished installing the basic ESLint / Prettier configuration! One more step before you see results in VS Code.

## STEP 4: More Configuration Options

// PENDING UPDATE//

`parserOptions: ` sets the [ECMA language spec](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Language_Resources) for the parser to the most recent 2020 edition, and it sets our cross-file code-sharing to use [_module_ syntax](https://medium.com/@thejasonfile/a-simple-intro-to-javascript-imports-and-exports-389dd53c3fac).


## NOTES

##### Reminder
Prettier only fixes a narrow selection of style errors. It cannot fix most of the structural problems that ESLint catches. ESLint will still flag those additional errors, but you will need to manually review the warning-squigglies to address anything Prettier couldn't fix automatically.

##### A few words on npm
**_npm_** is a package manager. It lets you use bits of code that other people, known as _modules_, on your local machine (ie, your laptop / desktop / hotwired Motorola Razr / etc). These modules can either be installed _globally_, meaning they are accessible everywhere on your computer, or _locally_, meaning they are only available in a certain folder (or _directory_) and it's subfolders (or _sub-directories_). The folder that contains all of your project files & subfolders, including your npm modules, is sometimes called your project's _root_ directory. Additionally, npm uses a [package.json](https://docs.npmjs.com/files/package.json) file to store and manage information about your project and its associated packages. This is a file written in JSON that tracks lots of information about your project, including info on the various helper modules you've installed. We're not working directly in `package.json` file for this guide, but it's helpful to know what it is.

Many npm packages also have _dependencies_. These are other packages that the main requires in order to run correctly. Often these dependencies will be installed automatically with whatever package you wanted, but sometimes they will need to be installed manually. This can be the source of many set-up headaches!

A normal dependency is one that your project relies on at runtime, like jQuery for a live webpage. A _dev-dependency_ is one that is only required during the development process and is **not** necessary for your finished application to function. ESLint & Prettier are dev-dependencies.

##### What the heck are dotfiles?!
_Dotfiles_ are hidden files used to set the configuration for many different types of programs, including Bash, Zsh, Vim, VS Code, ESLint and Prettier. They're called dotfiles because the filenames start with a leading `.` that renders them hidden from normal file viewers, including the `ls` command. To view hidden files within the terminal, you can use:

`ls -a -l`

where `-a` shows hidden files and `-l` displays the results as a list. Examples of my current dotfiles can be found [here](../Dotfiles).

##### Checking if your install worked
Your ESLint highlighting should appear immediately on any files within your install directory and its sub-directories. However, if error-highlighting or fixOnSave don't appear to be working, try the steps below before any additional troubleshooting:

1. Create a new file in your installation directory (or its sub-directories).
1. Save that file once, preferably with at least a one line comment as content.
1. Edit the file in some way. You can paste in the test case provided below if you'd like. You should see errors being highlighted by ESLint.
1. Save the file again. At this point, many of the style errors (including line-length) should auto-fix.

Feel free to use this code example to check for a few different types of errors, but remember to edit it at least once if included in the initial save!

```
let testFunc = function funcName (longArgNumberOne, longArgNumberTwo, longArgNumberFour, longArgNumberFive) {
  return "should be single quote and needs semicolon"
}
```
