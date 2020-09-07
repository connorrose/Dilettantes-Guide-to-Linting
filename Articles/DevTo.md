This article is a step-by-step, ground-up look at how the most popular Javascript linting tools can be used together to professionalize any codebase. The target audience is a `beginner++` level; you've written some javascript code in your IDE and probably pushed it to GitHub, but you haven't necessarily worked with other developers or published any public projects. The coverage will focus on vanilla Javascript, but some [React](https://reactjs.org/) linting is included incidentally. A [TLDR version](https://github.com/connorrose/Dilettantes-Guide-to-Linting/blob/master/Articles/TLDR.md) is available for more experienced developers.

The specific commands used below are based on my personal development environment: MacOS 10.15 (Catalina) with Bash. If you're on Windows or Linux, the principles will remain the same but the exact commands may differ slightly.

With that out of the way, here are our goals:
1. Install [ESLint](https://eslint.org/) locally, allowing us to check our code for style and syntax errors.
1. Set the [AirBnB Style Guide](https://github.com/airbnb/javascript) as our default ruleset.
1. Install either [Prettier](https://prettier.io/) or [this fork of Prettier](https://github.com/btmills/prettier) to enable more powerful auto-formatting whenever we save a `.js` file.
1. Integrate ESLint and Prettier into VS Code so that all formatting work can be handled directly within the editor.

If I've made any mistakes, as I'm sure I have, please file an issue on the [associated GitHub repo](https://github.com/connorrose/Dilettantes-Guide-to-Linting).

## GETTING STARTED

**[This article](https://blog.echobind.com/integrating-prettier-eslint-airbnb-style-guide-in-vscode-47f07b5d7d6a) was my original inspiration.** After trying it out, I've made some changes to stay closer to AirBnB's style guide docs while adding some additional context and explanation.

_Please note:_ terminal commands will always be on their own line, pre-fixed with a **$** sign. Don't include the **$** when typing the command in the terminal; it's used here only to indicate _"this is a terminal command you should enter."_

This guide focuses exclusively on using ESLint & Prettier within VS Code, rather than via the [ESLint CLI](https://eslint.org/docs/user-guide/command-line-interface). You can stop the install process at a few different points, depending on how sophisticated you want to get:

- Following **Steps 0 through 2** will give you a working ESLint set-up within VS Code.
- Continuing with **Step 3** will add additional auto-formatting via Prettier.
- Finally, [**the addendum**](https://dev.to/connorrose/a-dilettante-s-guide-to-linting-addendum-6l9) provides more configuration options for tailoring ESLint to your particular needs and preferences.

### PREREQUISITES
- **Basic command line skills:** You can mostly copy-paste the commands in this guide, but knowing how to `cd / ls / etc`, as well as understanding _flags_ (like `<command> --help`), will be a plus.
- **VS Code basics:** I'm assuming that you're already using VS Code, and that you understand the basics of how to navigate around it.
- **_npm_ installed & up-to-date:** If you're not sure whether you have npm installed, type `npm --version` into your terminal and hit enter. If you see a number, it's already installed. If not, follow [this link](https://www.npmjs.com/get-npm) to install Node & npm. We'll need **v6.9.0**, so please [update](https://docs.npmjs.com/try-the-latest-stable-version-of-npm) before proceeding if you're at v6.8.x or lower.

    [A similar tool](https://medium.com/@maybekatz/introducing-npx-an-npm-package-runner-55f7d4bd282b) called **_npx_** should be installed automatically with npm. To confirm, enter `npx -v` and look for the version number. If you'd like a little background on what exactly npm _is_, see the [notes](https://dev.to/connorrose/a-dilettante-s-guide-to-linting-addendum-6l9#a-few-words-on-npm) in the addendum.
- **Terminology => _Linter_:** A _linter_ is a program that parses your source code to detect syntax errors or styling inconsistencies. Linters are useful for making sure multiple developers can work on a shared project in a consistent code style with as few errors as possible. ESLint is a powerful configurable linter. Prettier, by contrast, is a narrowly-focused _code formatter_ that auto-fixes many style issues. It works by taking an [AST representation](https://blog.buildo.io/a-tour-of-abstract-syntax-trees-906c0574a067) of your code and re-printing it according to predefined & opinionated style rules. (For a bit more info on Prettier's design principles & under-the-hood implementation, see [this blog post](https://jlongster.com/A-Prettier-Formatter)).

## STEP 0: Picking a folder

All of the commands below should be executed while in a single folder in your terminal, unless otherwise indicated. Whatever folder you pick will then contain your installed packages and configuration files. ESLint will be available to all files within that folder, as well as to files within any sub-folders.
For example, I've set up my main workspace along this path:

`~/Desktop/Coding/Personal/`

where **`~`** is my home folder (literally `/Users/connorrose`). ESLint & Prettier are installed in this **`Personal`** folder. The **`Personal`** folder, or _directory_, then contains multiple sub-folders, or _sub-directories_, each of which is a project I've created (or cloned from GitHub). Since these sub-folders are nested _inside_ the folder where I installed ESLint and Prettier, the linter will have access to them. The individual projects are each tracked as their own separate git repositories, while the **`Personal`** folder itself is **_not_** tracked via [git version control](https://lab.github.com/).

You don't have to copy my exact directory set-up; just make sure you pick an install folder that can contain all of the projects you want linted according to the same AirBnB style rules. Remember that _every_ sub-folder will be following this configuration, so don't pick a folder that contains outside projects already following their own style guides. Once you've chosen a folder for installation, you should navigate to that folder within your terminal and move on to the next step.

## STEP 1: ESLint 

### Initializing with npm
Before we get started, let's create a **`package.json`** file to keep track of what we install. You should already be in your terminal, within the folder you've chosen (_hint:_ `pwd`). To create **`package.json`** with default values, we'll _initialize via npm_:
```bash
$ npm init --yes
```
This command will:
1. Initialize our current folder as an _npm package_. To over-simplify, npm packages are just folders containing code files and a completed **`package.json`**. It isn't relevant to us, but with a few tweaks we could technically publish our current folder and all the code it contains with [npm](https://docs.npmjs.com/about-npm/).
1. Create a **`package.json`** file in the current directory. This file keeps track of the packages we'll be installing.
1. Set some default values within **`package.json`**, including a _name_, _version number_, and _license_. Since we're not publishing our folder on npm, we won't worry about any of these values. However, you can look through [the docs](https://docs.npmjs.com/files/package.json) for more information.

### Installing ESLint
Next, to install the core ESLint package, enter:
```bash
$ npm install eslint --save-dev
```
<small>You can safely ignore any **npm WARN** messages about missing descriptions or fields.<small/>

This command will:
  1. Create a folder called **`node_modules`**, inside which all our packages will be installed.
  1. Install the ESLint package within **`node_modules`**.
  1. Register ESLint as a _dev-dependency_ in **`package.json`**.
  1. Install all the other packages ESLint depends on, as shown in npm's terminal output.
  1. Create a **`package-lock.json`** file in the current directory. This file automatically keeps track of the version info of packages we install, as well as the required version numbers for any of _their_ dependencies.

<hr/>
####<em>What's a dependency?</em>
The <code>--save-dev</code> flag registers the package we just installed as a <em>development dependency</em> within <code><strong>package.json</strong></code>. Dev-dependencies are packages required only during the development phase, rather than in production. That is, they are packages that help us <em>write</em> our code, but they do not contribute any functionality to the code we deploy to users.
<hr/>

### Installing AirBnB
Without changing folders, install the AirBnB configuration for ESLint:
```bash
$ npx install-peerdeps --dev eslint-config-airbnb
```
The `eslint-config-airbnb` package adds AirBnB's style guide as a ruleset within ESLint. However, these rules are not enabled automatically. We first need to set up our ESLint configuration file. Create a new file, in the same folder we've been working in, called **`.eslintrc.json`**:
```bash
$ touch .eslintrc.json
```
The **leading dot** in front of the filename is _very important_! You can read more on dotfiles in the [notes](https://dev.to/connorrose/a-dilettante-s-guide-to-linting-addendum-6l9#what-the-heck-are-dotfiles). This configuration file is written in JSON format, which lets us store our ESLint settings as properties on a Javascript object. Using a standardized file format like JSON allows many different programs, including VS Code, to interact with our configured settings. The ESLint config file can also be written in Javascript or [YAML](https://rollout.io/blog/yaml-tutorial-everything-you-need-get-started/), but JSON is the simplest for now.

### Configuring ESLint
Open your new **`.eslintrc.json`** file in VS Code and copy in the following:

```json
{
  "env": {
    "browser": true,
    "es6": true
  },
  "extends": ["airbnb"]
}
```

- `env:` sets the environments in which we expect to run our code. We've enabled support for browser-based Javascript, as well as the modern Javascript features introduced by [ES6 / ECMAScript 2015](https://www.geeksforgeeks.org/introduction-to-es6/).  
- `extends:` specifies the ruleset(s) we want to follow. For us that's the AirBnB ruleset we added via `eslint-config-airbnb`. Our new ESLint configuration will be an _extension_ of the rules in the AirBnB package.  

ESLint is now installed with a working AirBnB ruleset. The next step will add our awesome new linting abilities to VS Code.

## STEP 2: VS Code

### Installing the extension
If you're not already in VS Code, open it up now. Open up the [Extensions pane](https://code.visualstudio.com/docs/editor/extension-gallery) and search for [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) by Dirk Baeumer. Click the _Install_ button.

### Updating VS Code settings
If you're not sure how to access Settings in VS Code, see [the official docs](https://code.visualstudio.com/docs/getstarted/settings) before continuing. (_Hint:_ `CTRL+SHFT+P` > "Open Settings")  
With the ESLint extension installed, update the two settings shown below. You can either search for these by name in the Settings GUI, or directly paste the code into your VS Code **`settings.JSON`** file:  

```json
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "editor.defaultFormatter": "dbaeumer.vscode-eslint",
```

- `editor.CodeActionsOnSave` lets VS Code use ESLint to automatically re-format many of our style issues whenever we save a file.  
- `editor.defaultFormatter` sets the ESLint extension as our default formatter for all files in VS Code.  
 
If you want to explore all of the VS Code settings available for ESLint, check out the [extension documentation](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint).

_**And that's it!**_ You should now see ESLint highlighting any errors in your Javascript files, and it should even fix a few simple style mistakes on save, such as single versus double quotes or missing semicolons. If you're not seeing any of this, check the [notes](https://dev.to/connorrose/a-dilettante-s-guide-to-linting-addendum-6l9#checking-if-your-install-worked) for some trouble-shooting tips.

If you're happy with what's been enabled so far, feel free to stop here. You'll still have a working linter in VS Code. However, if you want more powerful auto-formatting, including automatic line breaks for long lines (think lots of function parameters), then continue to Prettier in Step 3.

## STEP 3: Prettier

### Choosing a Prettier version
Before we continue, we have to decide _which_ Prettier we want to use. Let me explain.

_**Prettier works magic.**_ It takes long lines, breaks them up logically, and re-formats all sorts of other little consistencies that crop up in our code over time. To do this efficiently, Prettier has [very few user-configurable options](https://prettier.io/docs/en/option-philosophy.html); most formatting decisions are hard-coded in. Unfortunately, one of these hard-coded decisions presents a major conflict with our chosen style guide: [where you place your operators around linebreaks](https://github.com/airbnb/javascript#control-statements). Prettier will always move your operators to the end of a line, while AirBnB prefers operators at the start of a newline. People seem to have [strong opinions](https://github.com/prettier/prettier/issues/3806) about this issue, and I've ultimately sided with the start-of-line AirBnB camp (cleaner git diffs, easier to read, etc). Before you continue, I suggest doing a little research and following your heart on this one.

### Installing Prettier
_If you're fine with operators at the end of the line,_ continue with the normal Prettier install:  
 ```bash
$ npm install --save-dev prettier
```

_If you want your operators at the start of a newline,_ there's a [fork for that](https://github.com/btmills/prettier)! To install the forked version of Prettier with leading operators, use this command **instead**: 
```bash
$ npm install --save-dev prettier@npm:@btmills/prettier
```
By using the `<alias>@npm:<package>` syntax, we've installed the forked package under the name `prettier.` This will let the other packages we're about to add find the forked version when they look for Prettier by name.

### Installing integration packages
Prettier is a standalone program, so we'll need two more packages to integrate it with ESLint. To install both packages:
```bash
$ npm install --save-dev eslint-config-prettier eslint-plugin-prettier 
```
- `eslint-config-prettier` turns off all the ESLint rules covered by Prettier's auto-formatting.  
- `eslint-plugin-prettier` allows us to apply Prettier's fixes directly from within ESLint. More on this later.  

### Updating ESLint configuration
To add our new Prettier tools into our ESLint configuration, open the same **`.eslintrc.json`** file as before. You can copy/paste the below code exactly as-is, overwriting the current contents:

```json
{
  "env": {
    "browser": true,
    "es6": true
  },
  "extends": ["airbnb", "prettier"],
  "plugins": ["prettier"],
  "rules": {
    "prettier/prettier": ["error"]
  }
}
```

Here's what we just did:
- We've extended our configuration with Prettier (really `eslint-config-prettier`) in addition to AirBnB. Since Prettier is second in the array, its configuration will be applied _after_ AirBnB, overwriting any conflicting rules. If you add additional rulesets in the future, you'll almost _always_ want to keep Prettier last.
- The new `plugins` property connects our `eslint-plugin-prettier` package to ESLint. This allows ESLint to directly call Prettier for auto-formatting our code.
- The `"prettier/prettier": ["error"]` property within `rules` lets ESLint show Prettier's style warnings as normal ESLint errors. This works in connection with the `eslint-plugin-prettier` package.

### Configuring Prettier
Prettier has it's own configuration file called **`.prettierrc.json`**. Create it now:
```bash
$ touch .prettierrc.json
```
Take note of the leading dot! We need to override two of Prettier's default settings, so open your new **`.prettierrc.json`** file and paste in the following:

```json
{
  "printWidth": 100,
  "singleQuote": true
}
```

This sets our preferred line length to [100 characters](https://github.com/airbnb/javascript#whitespace--max-len) and our default string format to [single quotes](https://github.com/airbnb/javascript#strings--quotes) instead of double quotes. These updates bring us in line with AirBnB.

_And that's it!_ **You're done.** You should now see ESLint highlighting all of your errors in VS Code, and Prettier auto-formatting your style when you save. If you'd like to customize your set-up even further, head on over to the [addendum](https://dev.to/connorrose/a-dilettante-s-guide-to-linting-addendum-6l9).
<hr/>
_... but what about the Prettier VS Code extension?_ We don't need it. Because `eslint-plugin-prettier` already connects Prettier's formatter to ESLint, we can rely on the ESLint extension alone. Every time ESLint's formatter is called on save, it will automatically add Prettier's formatting on top. One less thing to worry about!
