# ESLINT > AIRBNB > PRETTIER > VS CODE

This guide will attempt to walk you through every step of setting up a linting workflow for your Javascript files. I'm working exclusively on MacOS (10.15 Catalina), so your mileage vary on Linux and Windows. There are no React- or Typescript-specific configurations included here (yet).  
Following these steps will:

1. Install [ESLint](https://eslint.org/) locally to check your code for style and structural errors.
2. Set the [AirBnB Style Guide](https://github.com/airbnb/javascript) as your default ruleset.
3. Install either [Prettier](https://prettier.io/) or [this fork](https://github.com/btmills/prettier) of Prettier to auto-format common styling mistakes whenever you save a Javascript file.
4. Integrate ESLint and Prettier into VS Code so that all formatting work can be done live within the editor.

If I've made any mistakes, as I'm sure I have, please feel free to submit a pull request or raise an issue. If you follow everything listed in here and it still won't work (and you're on Mac), just get in touch and I'll do my best to help you troubleshoot.

## GETTING STARTED

**[This article](https://blog.echobind.com/integrating-prettier-eslint-airbnb-style-guide-in-vscode-47f07b5d7d6a) was the original inspiration for this guide.** After some time spent with that setup in VS Code, I've modified the instructions a bit to stick closer to AirBnB's style guide while removing redundant configuration steps and plugins. 

This guide is specifically focused on using ESLint & Prettier within VS Code, rather than directly through the [ESLint CLI](https://eslint.org/docs/user-guide/command-line-interface). If you're not yet comfortable using VS Code as your primary editor, [Sey's VS-Code write-up](https://github.com/seyitaintkim/VS-Code) covers a lot more ground than what I've written here. Again, my goal is simply to make the ESLint / Prettier / VS Code install as straightforward as possible with a detailed walkthrough.

**PREREQUISITES**

- _Basic command line skills._ You can mostly copy-paste the commands in this guide, but knowing how to cd / ls / etc, as well as how to use _flags_ (like `< command > --help`) will help.
- _VS Code basics._ I'm assuming that you're already using VS Code, and that you understand the basics of how to navigate around it. If not, read [Sey's guide](https://github.com/seyitaintkim/VS-Code) first.
- _npm already installed._ If you're not sure if you have npm, type `npm --version` into your terminal (and hit enter). If you see a number, you have npm installed already. If not, follow [this link](https://www.npmjs.com/get-npm) to install Node & npm. NPX (a similar tool) should automatically be installed alongside npm. You can confirm this by running `npx -v` and looking for the version number. If you'd like a little background on what exactly npm _is_, see the [notes](#notes) below.
- _Terminology: Linter._ A linter is a program that can parse your source code to detect errors or styling inconsistencies. Linters are useful for making sure multiple developers can work on a project in a consistent code style with as few errors as possible. ESLint is a powerful linter with lots of built-in functionality and extensibility. Prettier is a more narrowly focused linter that can auto-fix many style errors. (For a bit more info on how Prettier functions under-the-hood, see [this blog post](https://jlongster.com/A-Prettier-Formatter)).

## STEP 0: Picking a folder

All of the installation commands below should be entered while in the same folder in your terminal. Whatever folder you pick for this installation will then contain your installed packages and configuration files. ESLint will be available to other files within that folder, as well as to files within any sub-folders.
For example, I've set up my Software Immersive workspace along this path:

`~/Desktop/Coding/Course-Name/Immersive`

where `~` is my home folder (literally `/Users/connorrosedelisle`). ESLint & Prettier are installed in this **`Immersive`** folder. The **`Immersive`** folder then contains multiple sub-folders, or sub-directories, each of which is an assignment or project I've cloned. Because these assignment sub-directories are _inside_ the folder where I've installed ESLint and Prettier, the linter will still have access to them. The cloned projects are each tracked as their own separate git repositories, while the **`Immersive`** folder itself is **_not_** tracked via git / version control.

You don't have to copy my exact directory path set-up; just make sure you pick an install folder that can contain all of the projects you want linted and fixed (with the same AirBnB style rules). Remember that _every_ sub-directory will be following this configuration, so don't pick a folder that contains outside projects that follow their style guides. Once you've decided on a folder for installation, you should navigate to that folder within your terminal and move on to the next step.

## STEP 2: Install ESLint

Before we get started, we will create a **`package.json`** file to keep track of what we've installed. First, make sure you're on the command line (ie, in Terminal) within the folder you've chosen (_hint:_ `pwd`). To create **`package.json`** using the default values, we will _initialize via npm_:

`npm init --yes`

This does a few things:
  0. Initializes our current folder as an _npm package_. This isn't really relevant to our current goals, but with a few tweaks we would technically be able to register our current folder and all the code it contains with [npm](https://docs.npmjs.com/about-npm/).
  0. Creates a **`package.json`** file in the current directory. As discussed, this file will now keep track of many of the additional packages we'll be installing.
  0. Set some default values within **`package.json`**, including a name, version number, and license. Since we don't plan to publish our folder on npm, we won't worry about any of these values. However, you can look through [the docs](https://docs.npmjs.com/files/package.json) for more information.


Once we've initialized our folder, we can install the core ESLint package:

`npm install eslint --save-dev`

###### (You can safely ignore any `npm WARN` messages about missing descriptions or fields.)
<details open>
<summary>_Technical Aside_:<summary>
<br>
The `--save-dev` flag will register the package we just installed as a _Development Dependency_ within **`package.json`**. Dev-dependencies are packages required only during the development phase, rather than in production. That is, they are packages that help us _write_ our code, but they do not contribute any functionality to the code we deploy to users.
</details>

This will:
  0. Create a folder called **`node_modules`** where all the packages we install will be stored.
  0. Install ESLint within **`node_modules`**.
  0. Register ESLint as a `dev-dependency` in **`package.json`**.
  0. Install all the other packages that ESLint depends on, as shown in **`npm`**'s terminal output.
  0. Create a **`package-lock.json`** file in the current directory. This file will automatically keep track of the version information of the packages we install, as well as the required version numbers for any of their dependencies.

Next, without changing folders, install the AirBnB configuration for ESLint:

`npx install-peerdeps --dev eslint-config-airbnb`

The `eslint-config-airbnb` package adds AirBnB's style guide as a ruleset within ESLint. However, it is not enabled automatically. To force ESLint to follow the AirBnB rules, we need to set up our ESLint configuration file. To start, create a new file (in the same folder we've been working in) called **`.eslintrc.json`**:

`touch .eslintrc.json`

The leading dot in front of the filename is very important! A leading dot marks a file or folder as _hidden_ from most file viewers, including the `ls` command. To view our new file in the terminal, we'll need to use `ls -a`, where the `-a` flag displays all hidden files. (Read more on _dotfiles_ in the [notes](#notes).) This file will be in the **JSON** format, so the our ESLint settings can be stored as properties on an object. Using JSON allows many different programs, including VS Code, to interact with our settings. The ESLint configuration file can also be written in JS or YAML, but JSON will be the simplest for our purposes.

Now, open up **`.eslintrc.json`** in VS Code or another file editor, and copy in the below:

```json
{
  "env": {
    "browser": true,
    "node": true,
    "es2020": true
  },
  "extends": [
    "airbnb"
  ],
  "parserOptions": {
    "ecmaVersion": 2020,
    "sourceType": "module"
  }
}
```
`env: ` sets the environments in which we expect to run our code. We've enabled support for browsers, Node.js, and the most recent Javascript language standards and features.  
`extends: ` is where we set the AirBnB ruleset we installed with `eslint-config-airbnb`.
`parserOptions: ` sets the [ECMA language spec](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Language_Resources) for the parser to the most recent 2020 edition, and it sets our cross-file code-sharing to use [_module_ syntax](https://medium.com/@thejasonfile/a-simple-intro-to-javascript-imports-and-exports-389dd53c3fac).

**YAY!!** We've finished installing and configuring ESLint. One more step before we have our awesome new linting abilities enabled in VS Code.

## STEP 3: VS Code Integration

// PENDING UPDATE //

If you're not already in VS Code, open it up now. Open up the Extensions pane and search for [Prettier - Code formatter](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) by Esben Petersen. Click install.  
Now find [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) by Dirk Baeumer and click install. You're almost done. The next and last step ensures that when you save a file, Prettier will automatically run and make stylistic changes to your code as needed.

The very last step needed is to edit your VS Code settings. If you're not sure how to do this, review [Sey's guide](https://github.com/seyitaintkim/VS-Code) one more time. (Hint: CTRL+SHFT+P > "Open Settings") Once you're VS Code settings file, change `editor.formatOnSave` to `true`, and you're done! Give it a go, and see the **Notes** below for some trouble-shooting tips.

[If you're using the JSON Settings editor and not the GUI, just past `"editor.formatOnSave": true` on a new line.]

## STEP 4: Install Prettier & Plugins

// PENDING UPDATE //

## STEP 5: More Configuration Options

// PENDING UPDATE//

For today, we're concerned with two specific dotfiles:

`.eslintrc.json` for ESLint
&
`.prettierrc` for Prettier

Start by checking if either of these files already exist in the directory where you just installed the ESLint and Prettier npm packages. If they don't, you can create them either using `touch < filename >` in the terminal or directly in VS Code's File Explorer. **Make sure you include the leading dot for both, and the .json extension only for ESLint.**

Open your `.eslintrc.json` file for editing. For the simplest configuration, copy and place the below code exactly as-is, overwriting any existing code:

```
{
  "extends": ["airbnb", "prettier"],
  "plugins": ["prettier"],
  "rules": {
    "prettier/prettier": ["error"]
  },
}
```

This will give you ESLint configured with AirBnB rules and Prettier ready to auto-format on top.
Next, open your `.prettierrc` file and paste in the following:

```
{
  "printWidth": 100,
  "singleQuote": true
}
```

This modifies two of the default Prettier rules to bring them in line with AirBnB. You've now finished installing the basic ESLint / Prettier configuration! One more step before you see results in VS Code.

## NOTES

**Reminder:** Prettier only fixes a narrow selection of style errors. It cannot fix most of the structural problems that ESLint catches. ESLint will still flag those additional errors, but you will need to manually review the warning-squigglies to address anything Prettier couldn't fix automatically.

**Files other any _xyz.js_:** If you experience issues with auto-formatting or error messages on your non-Javascript code, try moving the VS Code `"editor.codeActionsOnSave"` setting from earlier into the `"[javascrip]": {}` setting selector we created.

**A few words on npm:**
npm is a package manager. It lets you install _modules_ (bits of code) that other people have written to work on your local machine (ie, your laptop / desktop / hotwired Motorola Razr / etc). Node modules can either be installed _globally_, meaning they are accessible everywhere on your computer, or _locally_, meaning they are only available in a certain folder (or _directory_) and it's subfolders (or _sub-directories_). The folder that contains all of your project files & subfolders is sometimes called your _root_ folder, or the root of your project. The root folder is where we'll install all of our files for this setup. Additionally, npm uses a [package.json](https://docs.npmjs.com/files/package.json) file to store and manage information about your project and its associated packages. This is a file written in json that tracks lots of information about your project, including info on the various helper modules you've installed. We don't need to work directly with `package.json` here, but it's helpful to know what it is.

Many npm packages have _dependencies_. These are other packages that they require in order to run correctly. Often these dependencies will be installed automatically with whatever package you wanted, but sometimes they will need to be installed manually. This will be the source of many ESLint&friends headaches. A normal dependency is one that your project relies on at runtime, like jQuery for a live webpage. A _dev-dependency_ is one that is only required during the development process and is **not** necessary for your finished application to function. ESLint & Prettier are dev-dependencies.

**What the heck are dotfiles?!** 
_Dotfiles_ are hidden files used to set the configuration for many different types of programs, including Bash, Zsh, Vim, VS Code, ESLint and Prettier. Examples of my current dotfiles can be found [here](../Dotfiles). They're called dotfiles because the file names start with a `.` that renders them hidden from normal file viewers. To view hidden files within the terminal, you can use:

`ls -a -l`

where `-a` shows hidden files and `-l` displays the results as a list. 

**Checking if your install worked:** Your ESLint highlighting should appear immediately on any files within your install directory and its sub-directories. However, if error-highlighting or fixOnSave don't appear to be working, try the steps below before any additional troubleshooting:

0. Create a new file in your installation directory (or its sub-directories).
0. Save that file once, preferably with at least a one line comment as content.
0. Edit the file in some way. You can paste in the test case provided below if you'd like. You should see errors being highlighted by ESLint.
0. Save the file again. At this point, many of the style errors (including line-length) should auto-fix.

Feel free to use this code example to check for a few types of fixable errors, but remember to edit it at least once after the initial save!

```
const testFunc = function funcName (longArgNumberOne, longArgNumberTwo, longArgNumberFour, longArgNumberFive) {
  return "should be single quote and needs semicolon"
}
```
