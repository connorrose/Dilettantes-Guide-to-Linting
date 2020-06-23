# ESLINT > AIRBNB > PRETTIER > VS CODE

This guide will attempt to walk you through every step of setting up your linting tools for the Codesmith Immersive. I'm working exclusively on MacOS (10.15 Catalina), so your mileage vary on Linux and Windows. I have NOT tested the React portion of the configuration, but it so far does not interfere with any non-React work. Additionally, you may need to tweak the VS Code settings to avoid interfering with HTML / CSS files (dicussed in #Notes section below).
Following these steps will:

1. Install [ESLint](https://eslint.org/) to check your coding for errors.
2. Use the [AirBnB Style Guide](https://github.com/airbnb/javascript) as the default ruleset.
3. Install [Prettier](https://prettier.io/) to auto-format common styling mistakes every time you save a JS file.
4. Integrate ESLint and Prettier into VS Code so that all linting and formatting can be done within the editor.

Feel free to skip Step 0 if you're otherwise confident in navigating your developer ecosystem. If I've made any mistakes, as I'm sure I have, please feel free to submit a pull request or raise an issue. If you follow everything listed in here and it still won't work (and you're on Mac), just shoot me a slack and I can try to help you troubleshoot over Zoom.

## STEP 0: Getting Started

**[This article](https://blog.echobind.com/integrating-prettier-eslint-airbnb-style-guide-in-vscode-47f07b5d7d6a) forms the basis of my guide. If you want short-and-sweet version, just give that a read first.**

[This one](https://scotch.io/tutorials/linting-and-formatting-with-eslint-in-vs-code) also might help and has lots of images. Additionally, [Sey's VS-Code write-up](https://github.com/seyitaintkim/VS-Code) covers a lot more ground than what I've written. My goal here is simply to make the ESLint / Prettier / VS Code install as straightforward as possible with a detailed walkthrough.

**PREREQUISITES**

- _Basic command line skills._ You can mostly copy-paste the commands in this guide, but knowing how to cd / ls / etc, as well as how to use _flags_ (like `< command > --help`) will help.
- _VS Code basics._ I'm assuming that you're already using VS Code, and that you understand the basics of how to navigate around it. If not, read [Sey's guide](https://github.com/seyitaintkim/VS-Code) first.
- _Have NPM installed._ If you're not sure if you have NPM, type `npm --version` into your terminal (and hit enter). If you see a number, you have NPM installed already. If not, follow [this link](https://www.npmjs.com/get-npm) to install Node & NPM. NPX (a similar tool) should automatically be installed alongside NPM. You can confirm this by running `npx -v` and looking for the version number.
- _Terminology: Linter._ A linter is a program that can parse your source code to detect errors or styling inconsistencies. Linters are useful for making sure multiple developers can work on a project in a consistent code style with as few errors as possible. ESLint is a powerful linter with lots of built-in functionality and extensibility. Prettier is a more narrowly focused linter that can auto-fix many style errors.

###### A few words on NPM:

NPM is a package manager. It lets you install _modules_ (bits of code) that other people have written to work on your local machine (ie, your laptop / desktop / hotwired Motorola Razr / etc). Node modules can either be installed _globally_, meaning they are accessible everywhere on your computer, or _locally_, meaning they are only available in a certain folder (or _directory_) and it's subfolders (or _sub-directories_). The folder that contains all of your project files & subfolders is sometimes called your _root_ folder, or the root of your project. The root folder is where we'll install all of our files for this setup. Additionally, NPM uses a [package.json](https://docs.npmjs.com/files/package.json) file to store and manage information about your project and its associated packages. This is a file written in json that tracks lots of information about your project, including info on the various helper modules you've installed. We don't need to work directly with `package.json` here, but it's helpful to know what it is.

Many NPM packages have _dependencies_. These are other packages that they require in order to run correctly. Often these dependencies will be installed automatically with whatever package you wanted, but sometimes they will need to be installed manually. This will be the source of many ESLint&friends headaches. A normal dependency is one that your project relies on at runtime, like jQuery for a live webpage. A _dev-dependency_ is one that is only required during the development process and is **not** necessary for your finished application to function. ESLint & Prettier are dev-dependencies.

## STEP 1: Install ESLint + Prettier

First we need to install our core ESLint & Prettier packages. Start by navigating to whatever folder contains _all_ of the work you expect to complete during the immersive (or at least all non-project challenge work). I've set up my worksace along this path:  
`~/Desktop/Coding/Codesmith/Immersive`  
where `~` is my home folder (literally `/Users/connorrosedelisle`). ESLint & Prettier are installed in this **Immersive** folder. The **Immersive** folder then contains multiple sub-folders, or sub-directories, each of which is an assignment we've cloned. Because these assignment sub-directories are _inside_ the folder where I've installed ESLint and Prettier, the linter will still have access to them. You don't have to copy my exact directory path set-up, but just make sure you pick an install folder that can contain all your Codesmith projects. Remember that _every_ sub-directory will be following this ESLint&friends configuration, so don't pick a folder that contains outside projects that follow other (non-AirBnB) style guides.

Once you've set up your install folder and navigated to it within the command line, you can complete your installs in the terminal with:  
`npm install -D eslint prettier` | **WARNING:** This command _must_ be run while within the folder you've chosen. Use `pwd` to confirm your current directory if needed.  
Sidenote: the `-D` is short for `--save-dev`, or "save these packages as a dev-dependency."

Next, without changing folders, install the AirBnB configuration for ESLint:
`npx install-peerdeps --dev eslint-config-airbnb`

Lastly, install two more packages that integrate Prettier into ESLint:  
`npm install -D eslint-config-prettier eslint-plugin-prettier`  
`eslint-config-prettier` will disable the ESLint rules now being handled by Prettier, and `eslint-plugin-prettier` "allows ESLint to show formatting errors as we type."

_Important note:_ Prettier can only handle a small subset of the rules that ESLint checks for. ESLint alone can detect everything detecable from the AirBnB style guide, but it provides very few _automatic_ fixes. Prettier does not detect any new errors; instead it adds powerful _automatic error fixing_ on top of ESLint (for a select set of errors). Using ESLint alone is enough to ensure your code style is correct, but adding Prettier on top will drastically speed up the time it takes to get there.

## STEP 2: Configure Dotfiles

_Dotfiles_ are hidden files used to set the configuration for many different types of programs, including Bash, Zsh, Vim, VS Code, ESLint and Prettier. Examples of my current dotfiles can be found [here](../Dotfiles). They're called dotfiles because the file names start with a `.` that renders them hidden from normal file viewers. To view hidden files within the terminal, you can use:  
`ls -a -l`  
where `-a` shows hidden files and `-l` displays the results as a list. For today, we're concerned with two specific dotfiles:

`.eslintrc.json` for ESLint
&
`.prettierrc` for Prettier

Start by checking if either of these files already exist in the directory where you just installed the ESLint and Prettier NPM packages. If they don't, you can create them either using `touch < filename >` in the terminal or directly in VS Code's File Explorer. **Make sure you include the leading dot for both, and the .json extension only for ESLint.**

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

## STEP 3: VS Code Integration

If you're not already in VS Code, open it up now. Open up the Extensions pane and search for [Prettier - Code formatter](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) by Esben Petersen. Click install.  
Now find [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) by Dirk Baeumer and click install. You're almost done. The next and last step ensures that when you save a file, Prettier will automatically run and make stylistic changes to your code as needed.

The very last step needed is to edit your VS Code settings. If you're not sure how to do this, review [Sey's guide](https://github.com/seyitaintkim/VS-Code) one more time. (Hint: CTRL+SHFT+P > "Open Settings") Once you're VS Code settings file, change `editor.formatOnSave` to `true`, and you're done! Give it a go, and see the **Notes** below for some trouble-shooting tips.

[If you're using the JSON Settings editor and not the GUI, just past `"editor.formatOnSave": true` on a new line.]

## STEP 4 (Optional): More Dotfile Configuration

TBD

## Notes

**Reminder:** Prettier only fixes a narrow selection of style errors. It cannot fix most of the syntactical problems that ESLint catches. ESLint will still work for those additional errors, but you will need to review the warning squigglies manually to address anything Prettier couldn't fix on its own.

**HTML / CSS:** If you have issues with auto-formatting or error messages on your non-Javascript code, try updating your VS Code Settings file with the following:

```
["javascript"]: {
  "editor.defaultFormatter": "esbenp.prettier-vscode"
}
```

You can also try adding `"editor.defaultFormatter": "esbenp.prettier-vscode"` if Prettier does _not_ appear to be working yet.

**Checking if your install worked:** Prettier will not format a new file on the first save. Additionally, Prettier will only format a file in VS Code if it has been modified in some way since the last save. This means that to test the auto-formatting, you may need to:

1. Create a new file in your installation directory (or its sub-directories).
2. Save that file once.
3. Edit the file in some way, such as changing a variable name or adding/deleting an extra blank line.
4. Save the file again. At this point, you should see many of the errors disappear upon saving.

Feel free to use this code example to check for a few types of fixable errors, but remember to edit it at least once after the initial save!

```
const testFunc = function funcName (longArgNumberOne, longArgNumberTwo, longArgNumberFour, longArgNumberFive) {
  return "should be single quote and needs semicolon"
}



```
