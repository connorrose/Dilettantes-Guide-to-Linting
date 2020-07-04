# ESLINT > AIRBNB > PRETTIER > VS CODE

This guide will attempt to walk you through every step of setting up a linting workflow for your Javascript files. I'm working exclusively on MacOS (10.15 Catalina), so your mileage vary on Linux and Windows. The focus is on vanilla browser-based Javascript, but we'll include incidental coverage for some [React](#react) and jQuery syntax along the way. Following these steps will:

1. Install [ESLint](https://eslint.org/) locally to check your code for style and structural errors.
1. Set the [AirBnB Style Guide](https://github.com/airbnb/javascript) as your default ruleset.
1. Install either [Prettier](https://prettier.io/docs/en/index.html) or [this fork](https://github.com/btmills/prettier) of Prettier to auto-format common styling mistakes whenever you save a Javascript file.
1. Integrate ESLint and Prettier into VS Code so that all formatting work can be done live within the editor.

If I've made any mistakes, as I'm sure I have, please feel free to [submit a pull request](https://www.freecodecamp.org/news/how-to-make-your-first-pull-request-on-github-3/) or [raise an issue](https://docs.github.com/en/enterprise/2.15/user/articles/creating-an-issue). If you follow everything listed in here and it still won't work (and you're on Mac), just get in touch and I'll do my best to help you troubleshoot.

## GETTING STARTED

**[This article](https://blog.echobind.com/integrating-prettier-eslint-airbnb-style-guide-in-vscode-47f07b5d7d6a) was the original inspiration for this guide.** After spending time in VS Code with that setup, I've made some changes to stay closer to [AirBnB's style guide docs](https://github.com/airbnb/javascript) while adding context and simplifying configuration slightly. If you just want a list of my install commands without the explanation, see the **[TLDR version](./TLDR-eslint.md)**. 

This guide is specifically focused on using ESLint & Prettier within VS Code, rather than directly through the [ESLint CLI](https://eslint.org/docs/user-guide/command-line-interface). If you're not yet comfortable using VS Code as your primary editor, [@seyitaintkim's VS-Code write-up](https://github.com/seyitaintkim/VS-Code) covers a lot more ground than what I've written here. Again, my goal is simply to make the ESLint / Prettier / VS Code install as straightforward as possible with a detailed walkthrough.

**PREREQUISITES**

- **Basic command line skills:** You can mostly copy-paste the commands in this guide, but knowing how to `cd / ls / etc`, as well as how to use _flags_ (like `<command> --help`) will help. See [this guide](./Command-Line.md) for more info.
- **VS Code basics:** I'm assuming that you're already using VS Code, and that you understand the basics of how to navigate around it. If not, read [Sey's guide](https://github.com/seyitaintkim/VS-Code) first.
- **_npm_ already installed:** If you're not sure if you have npm, type `npm --version` into your terminal (and hit enter). If you see a number, you have npm installed already. If not, follow [this link](https://www.npmjs.com/get-npm) to install Node & npm. __**npx**__ ([a similar tool](https://medium.com/@maybekatz/introducing-npx-an-npm-package-runner-55f7d4bd282b)) should be installed automatically alongside npm. You can confirm this by running `npx -v` and looking for the version number. If you'd like a little background on what exactly npm _is_, see the [notes](#a-few-words-on-npm) below.
- **Terminology => Linter:** A linter is a program that can parse your source code to detect errors or styling inconsistencies. Linters are useful for making sure multiple developers can work on a project in a consistent code style with as few errors as possible. ESLint is a powerful linter with lots of built-in functionality and extensibility. Prettier is a more narrowly focused _code formatter_ that can auto-fix many style errors. It works by taking an [AST representation](https://blog.buildo.io/a-tour-of-abstract-syntax-trees-906c0574a067) of your code and re-printing it according to predefined & opinionated style rules. (For a bit more info on Prettier's design principles & under-the-hood implementation, see [this blog post](https://jlongster.com/A-Prettier-Formatter)).

## STEP 0: Picking a folder

All of the installation commands below should be entered while in a single folder in your terminal. Whatever folder you pick for this installation will then contain your installed packages and configuration files. ESLint will be available to other files within that folder, as well as to files within any sub-folders.
For example, I've set up my _Software Immersive_ workspace along this path:

`~/Desktop/Coding/Course-Name/Immersive`

where `~` is my home folder (literally `/Users/connorrosedelisle`). ESLint & Prettier are installed in this **`Immersive`** folder. The **`Immersive`** folder, or _directory_, then contains multiple sub-folders, or _sub-directories_, each of which is an assignment or project I've cloned from GitHub. Because these assignment sub-directories are _inside_ the folder where I installed ESLint and Prettier, the linter will still have access to them. The cloned projects are each tracked as their own separate git repositories, while the **`Immersive`** folder itself is **_not_** tracked via [git](./Git-Github.md) / version control.

You don't have to copy my exact directory path set-up; just make sure you pick an install folder that can contain all of the projects you want linted and fixed (with the same AirBnB style rules). Remember that _every_ sub-directory will be following this configuration, so don't pick a folder that contains outside projects already following their own style guides. Once you've decided on a folder for installation, you should navigate to that folder within your terminal and move on to the next step.

## STEP 1: Install ESLint 

Before we get started, we'll create a **`package.json`** file to keep track of what we've installed. First, make sure you're in your terminal within the folder you've chosen (_hint:_ `pwd`). To create **`package.json`** using automatic default values, we will _initialize via npm_:

`npm init --yes`

This do will do a few things:
1. Initialize our current folder as an _npm package_. This isn't relevant to our current task, but with a few tweaks we could technically register our current folder and all the code it contains with [npm](https://docs.npmjs.com/about-npm/). To over-simplify, npm packages are just directories containing code files and a completed **`package.json`**. Which brings us to:
1. Create a **`package.json`** file in the current directory. As discussed, this file will now keep track of many of the additional packages we'll be installing.
1. Set some default values within **`package.json`** including a _name_, _version number_, and _license_. Since we don't plan to directly publish our folder on npm, we won't worry about any of these values. However, you can look through [the docs](https://docs.npmjs.com/files/package.json) for more information.
<br>

Once we've initialized our folder, we can install the core ESLint package:

`npm install eslint --save-dev`

###### (You can safely ignore any `npm WARN` messages about missing descriptions or fields.)

This will:
1. Create a folder called **`node_modules`**, inside which all our packages will be installed.
1. Install the ESLint package within **`node_modules`**.
1. Register ESLint as a `dev-dependency` in **`package.json`**.
1. Install all the other packages ESLint depends on, as shown in **`npm`**'s terminal output.
1. Create a **`package-lock.json`** file in the current directory. This file will automatically keep track of the version information of the packages we install, as well as the required version numbers for any of their dependencies.

<details>
<summary><i>Technical Aside</i></summary>
The <code>--save-dev</code> flag will register the package we just installed as a <i>Development Dependency</i> within <code>package.json</code>. Dev-dependencies are packages required only during the development phase, rather than in production. That is, they are packages that help us <i>write</i> our code, but they do not contribute any functionality to the code we deploy to users.
</details>
<br>

Next, without changing folders, install the AirBnB configuration for ESLint:

`npx install-peerdeps --dev eslint-config-airbnb`

This package adds AirBnB's style guide as a ruleset within ESLint. However, this ruleset is not enabled automatically. To force ESLint to follow the AirBnB rules, we need to set up our ESLint configuration file. To start, create a new file - in the same folder we've been working in - called **`.eslintrc.json`**:

`touch .eslintrc.json`

The leading dot in front of the filename is very important! (Read more on _dotfiles_ in the [notes](#what-the-heck-are-dotfiles).) This file will be in the **JSON** format, which lets us store our ESLint settings as properties on a Javascript object. Using a standardized file format like JSON allows many different programs, including VS Code, to interact with our settings configuration. The ESLint _config_ file can also be written in Javascript or [YAML](https://rollout.io/blog/yaml-tutorial-everything-you-need-get-started/), but JSON is the simplest for our purposes.

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

Once the ESLint extension is installed, we just need to update our VS Code settings. If you're not sure how to access your VS Code settings, review [Sey's guide](https://github.com/seyitaintkim/VS-Code) one more time.  
(_Hint:_ CTRL+SHFT+P > "Open Settings")  
We have two goals: to use ESlint as our default formatter and to format our code autmatically when saving. To achieve this, update the following settings:

```json
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "editor.defaultFormatter": "dbaeumer.vscode-eslint",
```

You can either search for these setting by name in the VS Code Settings GUI, or directly paste the above code into your VS Code `**settings.JSON**` file.  
`editor.CodeActionsOnSave` will allows VS Code to use ESLint to re-format many of our code errors whenever we save a file.  
`editor.defaultFormatter` sets the ESLint extension as our default formatter for all files in VS Code.  
 
If you want to explore all of the VS Code settings available for ESLint, check out the extension [documentation](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint).

**_You're finally done!_** You should now see ESLint highlighting any errors in your Javascript code files, and it should even fix a few simple style mistakes on save, such as single-quote vs. double-quote for strings. If you're not seeing any results, see the [notes](#checking-if-your-install-worked) below for some trouble-shooting tips.

_...but wait._ What about Prettier? Well, that's where things get complicated. If you're happy with the error messages and auto-fixing we've enabled so far, feel free to stop here. However, if you want more powerful auto-formatting, including automatic line breaks for long lines (think lots of function parameters), then continue on to Step 3 below.

## STEP 3: Install Prettier & Plugins

Before we continue with our Prettier install, we have to decide _which_ Prettier we want to use. Let me explain:  
_**Prettier works magic.**_ It takes long lines, breaks them up logically, and re-formats all sorts of other little consistencies that crop up in our code over time. To do this efficiently, Prettier has [very few user-configurable options](https://prettier.io/docs/en/option-philosophy.html); most formatting decisions are hard-coded in. Unfortunately, one of these hard-coded decisions presents a major conflict with our chosen style guide: [where you place your operators around linebreaks](https://github.com/airbnb/javascript#control-statements). Prettier will always move your operators to the end of a line, while AirBnB prefers operators at the start of a newline. People seem to have [strong opinions](https://github.com/prettier/prettier/issues/3806) about this issue, and I've ultimately sided with the start-of-line AirBnB camp (cleaner git diffs, easier to read, etc). However, you can follow your own heart on this one.

If you're fine with operators at the end of lines, continue with the normal Prettier install:

`npm install --save-dev prettier`

If you want your operators at the start of a newline, there's a [fork](https://github.com/btmills/prettier) for that! Choosing this route will require **one additional step** not needed for the normal version. To install the forked version of Prettier with leading operators, use this command _**instead**_:

`npm install --save-dev @btmills/prettier`

Once you've installed your chosen version of Prettier, you can move on. All the commands that follow will be the same for either version, with the addition of one extra step (clearly marked below) if you chose the _@btmills_ fork.

In order to integrate Prettier with our ESLint workflow, we need two more packages:  
`eslint-config-prettier` turns off all the ESLint rules covered by Prettier's auto-formatting.  
`eslint-plugin-prettier` allows us to apply Prettier's fixes directly from within ESLint. More on this later.  
To install both packages:

`npm install --save-dev eslint-config-prettier eslint-plugin-prettier`

<details>
<summary><em><b>IMPORTANT! If you chose @btmills/prettier...</b></em></summary>
This is the "small additional step." We're going to make one edit to the contents of the <code>eslint-plugin-prettier</code> package we just installed. Follow these instructions step-by-step:
<br>
<ol>
  <li>
    Open the <code>node_modules</code> folder in your current directory.
  </li>
  <li>
    Inside <code>node_modules</code>, find the folder named <code>eslint-plugin-prettier</code> and open it.
  </li>
  <li>
    Open the file named <code>eslint-plugin-prettier.js</code>.
  </li>
  <li>
    On (or near) line 168, find this code: <code>prettier = require('prettier');</code>. If you have trouble locating it, search for the phrase "expensive to load" which appears in the comment above our desired line.
  </li>
  <li>
    Edit the file by changing the string 'prettier' inside <code>require('prettier')</code> to '@btmills/prettier'. When you're done, lines 166 to 169 should look like this:<br>
    <pre><code>
      if (!prettier) {
        // Prettier is expensive to load, so only load it if needed.
        prettier = require('@btmills/prettier');
      }
    </code></pre>
  </li>
  <li>
    Now save your changes, and return to the main folder you've been working in. The hard part is done!
  </li>
</ol>
</details>

Our last step for Prettier is to update our configuration files. Open the same **`.eslintrc.json`** file as before. You can copy/paste the below code exactly as-is, overwriting our existing code:

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

- We've now extended our configuration with Prettier (really `eslint-config-prettier`) in addition to AirBnB. Because Prettier is second in the array, it's configuration will be applied _after_ AirBnB, overwriting any conflicting rules. When adding additional plugins down the line, you will almost _always_ want to keep Prettier last.
- The new `plugins` property connects our `eslint-plugin-prettier` package to ESLint. This allows ESLint to use Prettier for auto-formatting our code.
- The `"prettier/prettier": ["error"]` property within `rules` allows ESLint to show us Prettier's style warnings as normal ESLint errors. This functionality is part of the `eslint-plugin-prettier` package.

Lastly, we need to tweak two settings in Prettier to match the AirBnB style guide. Start by creating a Prettier configuration file called **`.prettierrc`**:

`touch .prettierrc`

Take note of the leading dot! You may also notice that this file doesn't have a file extension - that's a-okay. Prettier is expecting to find a file with this exact name, we want to leave it as-is. Open the new **`.prettierrc`** file and paste in the following:

```
{
  "printWidth": 100,
  "singleQuote": true
}
```

This sets our preferred max line width to [100 characters](https://github.com/airbnb/javascript#whitespace--max-len) and our default string format to [single quotes](https://github.com/airbnb/javascript#strings--quotes) instead of double.

_And that's it! **You're done.**_ You should now see ESLint highlighting all of your errors in VS Code, and Prettier auto-formatting your style when you save.

_... but what about the Prettier extension?_ We don't need it. Because `eslint-plugin-prettier` already connects the Prettier formatter to ESLint, we can just rely on the ESLint plugin itself. Every time the ESLint formatter is called on save, it will automatically add Prettier's formatting on top. It's one less plugin to potentially break or cause conflicts, and one fewer group of settings to manage.

## STEP 4: More Configuration (Optional)

If you made it to the end of Step 3 with everything working, you're in great shape. You can safely call it a day and have a working linter/formatter set-up many Javascript files to come. However, if you want to tailor you're environment a bit more, this step will walk you through common additional settings you can enable to personalize your environment and/or enforce stricter style adherence than the simple config detailed above.

[My complete ESLint config file](../Dotfiles/.eslintrc.json)  
DETAILS TODO

### VS Code setting specificity
// how to enable settings for specific file types only  
// [My current VS Code settings](../Dotfiles/VSCODE-settings.jsonc)

### .prettierrc options
// other available options  
// [My config file](../Dotfiles/.prettierrc)

### String Format Power-Ups
// re-enabling ESLint to enforce string literal rules

### Environment Globals: the lastest and greatest (including jQuery)
// additional environment options and avoiding bling errors

### ESLint Parser Options
// setting [ECMA language spec](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Language_Resources) to the parser to the most recent 2020 edition  
&  
// enabling [_module_ syntax](https://medium.com/@thejasonfile/a-simple-intro-to-javascript-imports-and-exports-389dd53c3fac).

### Additional ESLint Rules (or, why eslint-config-airbnb isn't enough)
// Some good rules to explicitly enable that are not encluded in eslint-config-airbnb (despite appearing in the AirBnB style guide)

### React!
// Info on React coverage  
// Targeting jsx files

## NOTES

#### Reminder
Prettier only fixes a narrow selection of style errors. It cannot fix most of the structural problems that ESLint catches. ESLint will still flag those additional errors, but you will need to manually review the warning-squigglies to address anything Prettier couldn't fix automatically.
<br>

### A few words on npm
**_npm_** is a package manager. It lets you use bits of code that other people, known as _modules_, on your local machine (ie, your laptop / desktop / hotwired Motorola Razr / etc). These modules can either be installed _globally_, meaning they are accessible everywhere on your computer, or _locally_, meaning they are only available in a certain folder (or _directory_) and it's subfolders (or _sub-directories_). The folder that contains all of your project files & subfolders, including your npm modules, is sometimes called your project's _root_ directory. Additionally, npm uses a [package.json](https://docs.npmjs.com/files/package.json) file to store and manage information about your project and its associated packages. This is a file written in JSON that tracks lots of information about your project, including info on the various helper modules you've installed. We're not working directly in `package.json` file for this guide, but it's helpful to know what it is.

Many npm packages also have _dependencies_. These are other packages that the main requires in order to run correctly. Often these dependencies will be installed automatically with whatever package you wanted, but sometimes they will need to be installed manually. This can be the source of many set-up headaches!

A normal dependency is one that your project relies on at runtime, like jQuery for a live webpage. A _dev-dependency_ is one that is only required during the development process and is **not** necessary for your finished application to function. ESLint & Prettier are dev-dependencies.
<br>

### What the heck are dotfiles?!
_Dotfiles_ are hidden files used to set the configuration for many different types of programs, including Bash, Zsh, Vim, VS Code, ESLint and Prettier. They're called dotfiles because the filenames start with a leading `.` that renders them hidden from normal file viewers, including the `ls` command. To view hidden files within the terminal, you can use:

`ls -a -l`

where `-a` shows hidden files and `-l` displays the results as a list. Examples of my current dotfiles can be found [here](../Dotfiles).
<br>

### Checking if your install worked
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
