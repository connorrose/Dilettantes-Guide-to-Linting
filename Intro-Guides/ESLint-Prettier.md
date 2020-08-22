This guide is a step-by-step walkthrough for setting up a Javascript linting workflow. I work exclusively on MacOS (10.15 Catalina), so your mileage may vary on Linux and Windows. The focus is on vanilla, browser-based Javascript, but includes incidental coverage for [React](https://reactjs.org/) as well.

**The goal:**
1. Install [ESLint](https://eslint.org/) locally, which will check our code for style and structural errors.
1. Set the [AirBnB Style Guide](https://github.com/airbnb/javascript) as our default ruleset.
1. Install either [Prettier](https://prettier.io/) or [this fork of Prettier](https://github.com/btmills/prettier) to enable powerful auto-formatting whenever we save a JS file.
1. Integrate ESLint and Prettier into VS Code so that all formatting work can be handled directly within the editor.

If I've made any mistakes, as I'm sure I have, please feel free to [submit a pull request](https://www.freecodecamp.org/news/how-to-make-your-first-pull-request-on-github-3/) or [raise an issue](https://github.com/connorrose/Web-Dev-Workflow-Guide-For-Beginners/issues). If you follow everything listed here and it still won't work (and you're on Mac), just get in touch and I'll do my best to help you troubleshoot.

## GETTING STARTED

**[This article](https://blog.echobind.com/integrating-prettier-eslint-airbnb-style-guide-in-vscode-47f07b5d7d6a) was my original inspiration.** After spending time in VS Code with that setup, I've made some changes to stay closer to AirBnB's [style guide docs](https://github.com/airbnb/javascript) while adding additional context. If you just want a list of the install commands without any explanation, see the **[TLDR version](./TLDR-eslint.md)**.

_**Please note:**_ terminal commands will always be on their own line, pre-fixed with a $ sign. Don't include the **$** when typing the command in the terminal; it's used here only to indicate _"this is a terminal command you should enter"_.

This guide focuses exclusively on using ESLint & Prettier within VS Code, rather than via the [ESLint CLI](https://eslint.org/docs/user-guide/command-line-interface). You can stop the install process at a few different points, depending on how sophisicated you want your set-up to be:

- **Steps 0 to 2** will give you a working ESLint set-up within VS Code.
- Continuing with **Step 3** will add additional auto-formatting via Prettier.
- Finally, **Step 4** provides more configuration options for tailoring ESLint to your particular needs and preferences.

**PREREQUISITES**

- **Basic command line skills:** You can mostly copy-paste the commands in this guide, but knowing how to `cd / ls / etc`, as well as understanding _flags_ (like `<command> --help`), will be a plus.
- **VS Code basics:** I'm assuming that you're already using VS Code, and that you understand the basics of how to navigate around it. If you're not yet comfortable using VS Code, [@seyitaintkim's VS Code write-up](https://github.com/seyitaintkim/VS-Code) is a good primer; check that out before continuing here. 
- **_npm_ installed & up-to-date:** If you're not sure if you have npm installed, type `npm --version` into your terminal and hit enter. If you see a number, it's already installed. If not, follow [this link](https://www.npmjs.com/get-npm) to install Node & npm. [A similar tool](https://medium.com/@maybekatz/introducing-npx-an-npm-package-runner-55f7d4bd282b) called **_npx_** should be installed automatically with npm. To confirm, enter `npx -v` and look for the version number. If you'd like a little background on what exactly npm _is_, see the [notes](#a-few-words-on-npm) below.
- **Terminology => _Linter_:** A _linter_ is a program that parses your source code to detect syntax errors or styling inconsistencies. Linters are useful for making sure multiple developers can work on a shared project in a consistent code style with as few errors as possible. ESLint is a powerful configurable linter. Prettier, by contrast, is a narrowly-focused _code formatter_ that auto-fixes many style issues. It works by taking an [AST representation](https://blog.buildo.io/a-tour-of-abstract-syntax-trees-906c0574a067) of your code and re-printing it according to predefined & opinionated style rules. (For a bit more info on Prettier's design principles & under-the-hood implementation, see [this blog post](https://jlongster.com/A-Prettier-Formatter)).

## STEP 0: Picking a folder

All of the commands below should be executed while in a single folder in your terminal, unless otherwise indicated. Whatever folder you pick for this installation will then contain your installed packages and configuration files. ESLint will be available to other files within that folder, as well as to files within any sub-folders.
For example, I've set up my _Software Immersive_ workspace along this path:

`~/Desktop/Coding/Course-Name/Immersive`

where `~` is my home folder (literally `/Users/connorrosedelisle`). ESLint & Prettier are installed in this **`Immersive`** folder. The **`Immersive`** folder, or _directory_, then contains multiple sub-folders, or _sub-directories_, each of which is an assignment or project I've cloned from GitHub. Since these assignment sub-folders are _inside_ the folder where I installed ESLint and Prettier, the linter will still have access to them. The cloned projects are each tracked as their own separate git repositories, while the **`Immersive`** folder itself is **_not_** tracked via [git](./Git-Github.md) / version control.

You don't have to copy my exact directory path set-up; just make sure you pick an install folder that can contain all of the projects you want linted and fixed with the same AirBnB style rules. Remember that _every_ sub-folder will be following this configuration, so don't pick a folder that contains outside projects already following their own style guides. Once you've chosen a folder for installation, you should navigate to that folder within your terminal and move on to the next step.

## STEP 1: ESLint 

### Initializing with npm
Before we get started, let's create a **`package.json`** file to keep track of what we installed. You should already be in your terminal within the folder you've chosen (_hint:_ `pwd`). To create **`package.json`** with default values, we'll _initialize via npm_:

**$** `npm init --yes`

This will:
1. Initialize our current folder as an _npm package_. To over-simplify, npm packages are just folders containing code files and a completed **`package.json`**. It isn't relevant to us, but with a few tweaks we could technically register our current folder and all the code it contains with [npm](https://docs.npmjs.com/about-npm/).
1. Create a **`package.json`** file in the current directory. This file keeps track of the packages we'll be installing.
1. Set some default values within **`package.json`**, including a _name_, _version number_, and _license_. Since we're not publishing our folder on npm, we won't worry about any of these values. However, you can look through [the docs](https://docs.npmjs.com/files/package.json) for more information.
<br>

### Installing ESLint
Next, to install the core ESLint package, enter:

**$** `npm install eslint --save-dev`

###### (You can safely ignore any `npm WARN` messages about missing descriptions or fields.)

This command will:
1. Create a folder called **`node_modules`**, inside which all our packages will be installed.
1. Install the ESLint package within **`node_modules`**.
1. Register ESLint as a _dev-dependency_ in **`package.json`**.
1. Install all the other packages ESLint depends on, as shown in npm's terminal output.
1. Create a **`package-lock.json`** file in the current directory. This file automatically keeps track of the version info of packages we install, as well as the required version numbers for any of their _dependencies_.

<details>
<summary><i>Technical Aside</i></summary>
The <code>--save-dev</code> flag registers the package we just installed as a <i>development dependency</i> within <code><b>package.json</b></code>. Dev-dependencies are packages required only during the development phase, rather than in production. That is, they are packages that help us <i>write</i> our code, but they do not contribute any functionality to the code we deploy to users.
</details>

<br />

### Installing AirBnB
Without changing folders, install the AirBnB configuration for ESLint:

**$** `npx install-peerdeps --dev eslint-config-airbnb`

The `eslint-config-airbnb` package adds AirBnB's style guide as a ruleset within ESLint. However, these rules are not enabled automatically. First we need to set up our ESLint configuration file. Create a new file, in the same folder we've been working in, called **`.eslintrc.json`**:

**$** `touch .eslintrc.json`

The **leading dot** in front of the filename is _very important_! You can read more on _dotfiles_ in the [notes](#what-the-heck-are-dotfiles). This configuration file is written in the JSON format, which lets us store our ESLint settings as properties on a Javascript object. Using a standardized file format like JSON allows many different programs, including VS Code, to interact with our configured settings. The ESLint config file can also be written in Javascript or [YAML](https://rollout.io/blog/yaml-tutorial-everything-you-need-get-started/), but JSON is the simplest for now.

### Configuring ESLint
Open your new **`.eslintrc.json`** file in VS Code and copy in the following:

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
`extends:` specifies the ruleset(s) we want to follow. For us that's the AirBnB ruleset we added via `eslint-config-airbnb`. Our new ESLint configuration will be an _extension_ of the rules in the AirBnB package.  

**YAY!!** ESLint is now installed with a working AirBnB ruleset. The next step will add our awesome new linting abilities to VS Code.

## STEP 2: VS Code

### Installing the extension
If you're not already in VS Code, open it up now. Open up the [Extensions pane](https://code.visualstudio.com/docs/editor/extension-gallery) and search for [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) by Dirk Baeumer. Click the _Install_ button.

### Updating VS Code settings
 If you're not sure how to access Settings in VS Code, see [the official docs](https://code.visualstudio.com/docs/getstarted/settings) before continuing. (_Hint:_ `CTRL+SHFT+P` > "Open Settings")  
With the ESLint extension installed, update the two settings shown below. You can either search for these by name in the Settings GUI, or directly paste them code into your VS Code **`settings.JSON`** file:  

```jsonc
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "editor.defaultFormatter": "dbaeumer.vscode-eslint",
```

- `editor.CodeActionsOnSave` lets VS Code use ESLint to automatically re-format many of our style issues whenever we save a file.  
- `editor.defaultFormatter` sets the ESLint extension as our default formatter for all files in VS Code.  
 
If you want to explore all of the VS Code settings available for ESLint, check out the extension [documentation](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint).

**_You're finally done!_** You should now see ESLint highlighting errors in your JS files, and it should even fix a few simple style mistakes on save, such as single v. double quote or missing semi-colons. If you're not seeing any of this, check the [notes](#checking-if-your-install-worked) below for some trouble-shooting tips.

_...but wait._ What about Prettier? This is where it can get a little more complicated. If you're happy with what we've enabled so far, feel free to stop here. You'll still have a working linter in VS Code. However, if you want more powerful auto-formatting, including automatic line breaks for long lines (think lots of function parameters), then continue to Step 3.

## STEP 3: Prettier

### Choosing a Prettier version
Before we continue, we have to decide _which_ Prettier we want to use. Let me explain:

_**Prettier works magic.**_ It takes long lines, breaks them up logically, and re-formats all sorts of other little consistencies that crop up in our code over time. To do this efficiently, Prettier has [very few user-configurable options](https://prettier.io/docs/en/option-philosophy.html); most formatting decisions are hard-coded in. Unfortunately, one of these hard-coded decisions conflicts significantly with our chosen style guide: [where you place your operators around linebreaks](https://github.com/airbnb/javascript#control-statements). Prettier will always move your operators to the end of a line, while AirBnB prefers operators at the start of a newline. People seem to have [strong opinions](https://github.com/prettier/prettier/issues/3806) about this issue, and I've ultimately sided with the start-of-line AirBnB camp (cleaner git diffs, easier to read, etc). Before you continue, I suggest doing a little research and following your heart on this one.

### Installing Prettier
_If you're fine with operators at the end of the line,_ continue with the normal Prettier install:  
**$** `npm install --save-dev prettier`

_If you want your operators at the start of a newline,_ there's a [fork for that](https://github.com/btmills/prettier)! Choosing the fork will require **one additional step** not needed for the normal version. To install the forked version of Prettier with leading operators, _**use this command instead:**_  
**$** `npm install --save-dev @btmills/prettier`

All the commands that follow will now be the same for both versions, with the additional step for the _@btmills_ fork clearly labeled just below.

### Installing integration packages
Prettier is a standalone program, so we'll need two more packages to integrate it with ESLint. To install both packages:

**$** `npm install --save-dev eslint-config-prettier eslint-plugin-prettier`

- `eslint-config-prettier` turns off all the ESLint rules covered by Prettier's auto-formatting.  
- `eslint-plugin-prettier` allows us to apply Prettier's fixes directly from within ESLint. More on this later.  

<details>
<summary><em><b>IMPORTANT! If you chose @btmills/prettier...</b></em></summary>
This is the "additional step." Since the forked package has a different name than the normal package, we need to make one edit to the contents of <code>eslint-plugin-prettier</code>. Follow these instructions step-by-step:
<br>
<ol>
  <li>
    Open the <code><b>node_modules</b></code> folder found in your current directory.
  </li>
  <li>
    Inside <code><b>node_modules</b></code>, find the folder named <code><b>eslint-plugin-prettier</b></code> and open it.
  </li>
  <li>
    Open the file named <code><b>eslint-plugin-prettier.js</b></code>.
  </li>
  <li>
    On (or near) line 168, find this code: <code>prettier = require('prettier');</code>. If you have trouble locating it, search for the phrase "expensive to load" which appears in the comment above our desired line.
  </li>
  <li>
    Edit the file by changing the string '<i>prettier</i>' inside <code>require('prettier')</code> to '<i>@btmills/prettier</i>'. When you're done, lines 166 to 169 should look like this:<br>
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

<br />

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
- We've extended our configuration with Prettier (really `eslint-config-prettier`) in addition to AirBnB. Since Prettier is second in the array, it's configuration will be applied _after_ AirBnB, overwriting any conflicting rules. If you add additional rulesets in the future, you'll almost _always_ want to keep Prettier last.
- The new `plugins` property connects our `eslint-plugin-prettier` package to ESLint. This allows ESLint to directly call Prettier for auto-formatting our code.
- The `"prettier/prettier": ["error"]` property within `rules` lets ESLint show Prettier's style warnings as normal ESLint errors. This works in connection with the `eslint-plugin-prettier` package.

### Configuring Prettier
Prettier has it's own configuration file called **`.prettierrc.json`**. Create it now:

**$** `touch .prettierrc.json`

Take note of the leading dot! We need to override two of Prettier's default settings, so open the new **`.prettierrc.json`** file and paste in the following:

```json
{
  "printWidth": 100,
  "singleQuote": true
}
```

This sets our preferred line length to [100 characters](https://github.com/airbnb/javascript#whitespace--max-len) and our default string format to [single quotes](https://github.com/airbnb/javascript#strings--quotes) instead of double quotes. These updates bring us in line with AirBnB.

_And that's it!_ **You're done.** You should now see ESLint highlighting all of your errors in VS Code, and Prettier auto-formatting your style when you save.

_... but what about the Prettier extension?_ We don't need it. Because `eslint-plugin-prettier` already connects Prettier's formatter to ESLint, we can just rely on the ESLint plugin alone. Every time the ESLint formatter is called on save, it will automatically add Prettier's formatting on top. One less thing to worry about!

## STEP 4: More Configuration (Optional)

If you made it to the end of Step 3 with everything working, you're in great shape. You can safely call it a day and have a working set-up for many JS files to come. If you want to tailor your environment a bit more, this step will walk you through common additional settings. You can enable some or all of these to personalize your environment and/or enforce stricter style adherence than the simple config detailed above. If you're interested, you can view my complete ESLint config file [here](../Dotfiles/.eslintrc.json).

### Reference Docs
If you want to explore the settings on your own, the following links are good places to start. For the packages, don't be afraid to dig around into the source code! It's a great way to understand more about how things function and interconnect under-the-hood. 
- [Configuring ESLint](https://eslint.org/docs/user-guide/configuring)
- [Prettier Docs](https://prettier.io/docs/en/index.html)
- [eslint-config-airbnb](https://github.com/airbnb/javascript/tree/master/packages/eslint-config-airbnb)
- [eslint-config-prettier](https://github.com/prettier/eslint-config-prettier)
- [eslint-plugin-prettier](https://github.com/prettier/eslint-plugin-prettier)

### VS Code setting specificity
When we updated our VS Code settings in Step 2, we enabled ESLint for _all_ file types, not just Javascript. This shouldn't cause any issues, as ESLint won't parse non-Javascript files. However, if you decide to set up other formatters for non-Javascript files, you'll want change your VS Code settings to target the ESLint extension more narrowly. You can do this with [language specific editor settings](https://code.visualstudio.com/docs/getstarted/settings#_language-specific-editor-settings):
```jsonc
  "[javascript]": {
    "editor.defaultFormatter": "dbaeumer.vscode-eslint",
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": true
    }
  },
```

You'll also want to add `"[javascriptreact]"`, if applicable. For reference, my complete & annotated VS Code settings can be found [here](../Dotfiles/VSCODE-settings.jsonc).

### .prettierrc options
As discussed, Prettier doesn't let us do a whole lot of configuration. We only needed to change two options to match AirBnB, but we can customize [a few more](https://prettier.io/docs/en/options.html) if we want. [My Prettier config file](../Dotfiles/.prettierrc.json) specifies all of the options I'm opiniated about, even though I'm just re-stating the default behavior for most of them.

### String Format Power-Ups
One set of rules that breaks during Prettier / ESLint integration is string templating. We want to avoid template literals unless necessary, but always prefer template literals over string concatenation. To re-enable this behavior, we need to add an explicit rule in our **`.eslintrc.json`** file:

```jsonc
  "rules": {
    //... other rules
    "quotes": [
      "error",
      "single",
      { "avoidEscape": true, "allowTemplateLiterals": false }
    ],
    //... more rules
  }
``` 

### Environment Globals: the latest and greatest (including jQuery)
[Environments](https://eslint.org/docs/user-guide/configuring#specifying-environments) in ESLint are really just sets of global variables. By specifying an environment, we tell ESLint to **not** mark these variables as errors when we use them in a file without having provided our own explicit definition. Global variables can include keywords like _Set_, for ES6 code, or the _window_ object, for browser-based code. You can specify as many different or overlapping environments as you want, but you shouldn't start enabling everything without good reason. If we're working exclusively on browser-based code, leaving Node out of our environment list will ensure we don't sneak in any Node-specific globals by mistake. I've specified only the following environments for now:

- `browser`: Since much of my code is front-end Web Dev work, this covers most of what I need.
- `node`: If I _am_ working on server code, I want to make sure I don't get unnecessary errors.
- `es2020`: This lets me use all the Javascript language features up through the most recent [ECMAScript spec](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Language_Resources), including features from earlier specs like ES6. If you're using a [transpiler](https://scotch.io/tutorials/javascript-transpilers-what-they-are-why-we-need-them) or [runtime](https://medium.com/@olinations/the-javascript-runtime-environment-d58fa2e60dd0) that **doesn't** support these features yet, you may want to specify `es6` instead.
- `jquery`: I don't use a lot of jQuery, but this saves me from `$`-operator warnings when I do.

### ESLint Parser Options
You don't need to get too deep into [parserOptions](https://eslint.org/docs/user-guide/configuring#specifying-parser-options). They just let you get a bit more specific on what syntax and language features you want supported. Two settings you may want to be aware of:

- `"ecmaVersion": 2020` It's probably best to leave this out, as the `es2020` environment setting will enable this automatically. If you haven't specified an ES version in your environments, you can enable syntax (_but not the global variables!_) through this setting.
- `"sourceType": "module"` This tells the parser to expect [module _import / export_ syntax](https://medium.com/@thejasonfile/a-simple-intro-to-javascript-imports-and-exports-389dd53c3fac). Can safely be skipped until you know you need it.

### Additional ESLint Rules (or, why eslint-config-airbnb isn't enough)
ESLint supports three levels of warning for most rules. You can set rules to a specific warning level to group your errors in whatever way works for you:

0. `"off"`: the rule will not be flagged whatsoever in your code. 
0. `"warn"`: you'll see a yellow or orange squiggly, and the rule will be counted in the ⚠ status bar symbol within VS Code.
0. `"error"`: normal error, red squiggly, counted with ⓧ in VS Code status bar.

If you've gotten this far, you may have noticed some rules from the AirBnB style guide aren't showing as warnings or errors. If you [dig into the package source code](https://github.com/airbnb/javascript/tree/master/packages/eslint-config-airbnb-base/rules), you'll see that not every rule specified in the style guide has actually been enabled! We can re-enable any of these ommissions by adding them to the `"rules"` object in **`.eslintrc.json`**:

```jsonc
  // Not all missing rules are listed here

  "default-case-last": "error",
  "default-param-last": ["error"],
  "func-style": ["warn", "expression"],
  "no-useless-call": "error",
  "prefer-exponentiation-operator": "error",
  "prefer-regex-literals": "error",

```

Most of these are pretty straightforward, and you can always [check the ESLint rules doc](https://eslint.org/docs/rules/) for more info. **`func-style`**, though, is worth explaining. This rule will raise an error when you use a function declaration instead of a [named function expression](https://github.com/airbnb/javascript#functions--declarations):

```javascript
  // via AirBnB

  // bad
  function foo() {
    // ...
  }

  // good
  // lexical name distinguished from the variable-referenced invocation(s)
  const short = function longUniqueMoreDescriptiveLexicalFoo() {
    // ...
  };
```

If you _do_ need to use a standard function declaration for some reason, the warnings squiggly will underline _**the entire function definition**_, which can get very distracting, very quickly. Only enable this rule if you're willing to stick _very strictly_ to function expressions.

### Nested Config Files
Sometimes you'll clone a project that already contains ESLint configuration file(s) and packages. If you have multiple configuration files in a nested directory structure, ESLint will automatically try to combine _all_ those files until it hits your home directory. To prevent this behavior, add `"root": true` to the outermost **`.eslintrc*`** file you want included in the chain. Note that ESLint applies a hierachy of filetypes when determing how to apply multiple config files within the same folder:

1. `.eslintrc.js`
1. `.eslintrc.yaml`
1. `.eslintrc.yml`
1. `.eslintrc.json`
1. `.eslintrc`
1. `package.json`

See [the ESLint docs](https://eslint.org/docs/2.0.0/user-guide/configuring#configuration-cascading-and-hierarchy) for more info. Additionally, be aware that Prettier uses a [different precedence](https://prettier.io/docs/en/configuration.html) for _it's_ config file extensions:  
1. `"prettier"` key in **`package.json`**
1. `.prettierrc` file (containing either JSON or YAML)
1. `.prettierrc.json`, `.prettierrc.yml`, or `.prettierrc.yaml`
1. `.prettierrc.js` or `prettier.config.js` using `module.exports`
1. `.prettierrc.toml`

### REACT!
Guess what - _you've already set up coverage for React._ The `eslint-config-airbnb` package we installed brought along [eslint-plugin-react](https://github.com/yannickcr/eslint-plugin-react) as a dependency, and the AirBnB ruleset we extended includes configuration for React! Still, for maximum utility, we should tweak a few settings:

#### Within `.eslintrc.json`
1. Add `"prettier/react"` as the _last_ item in the `"extends"` array.
1. Update `"parserOptions"` to support JSX syntax:
    ```json
    "parserOptions": {
      "ecmaFeatures": {
        "jsx": true
      }
    }
    ```
1. Add any additional React-specific rules you may want:
    ```json
      "react/prefer-stateless-function": ["warn"],
      "react/jsx-key": "warn",
      "react/no-direct-mutation-state": "error",
      "react/no-adjacent-inline-elements": "error"
    ```
1. _Note:_ We **don't** need to add `"react"` as a plug-in, since `eslint-config-airbnb` already took care of that for us.

#### Within VS Code
If ESLint is enabled for _all_ filetypes in VS Code, you can skip this step. If you added a Javascript selector to your ESLint settings, as described above, you'll want to target _.jsx_ files as well:
```json
  "[javascriptreact]": {
    "editor.defaultFormatter": "dbaeumer.vscode-eslint",
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": true
    }
  },
```

And that's it! You should be all set to lint and auto-fix all your JS & JSX files within VS Code.

###### Thanks for reading 😊

## NOTES

#### Reminder
Prettier only fixes a narrow selection of style errors. It cannot fix most of the structural problems that ESLint catches. ESLint will still flag those additional errors, but you will need to manually review the warning-squigglies to address anything Prettier couldn't fix automatically.
<br>

### A few words on npm
**_npm_** is a package manager. It lets you use bits of code that other people have written, known as _packages_, on your local machine (_ie_, your laptop / desktop / hotwired Motorola Razr / etc). These modules can either be installed _globally_, meaning they are accessible everywhere on your computer, or _locally_, meaning they are only available in a certain folder (or _directory_) and it's subfolders (or _sub-directories_). The folder that contains all of your project files & subfolders, including your npm modules, is sometimes called your project's _root_ directory. Additionally, npm uses a [package.json](https://docs.npmjs.com/files/package.json) file to store and manage information about your project and its associated packages. This is a file written in JSON that tracks lots of information about your project, including info on the various helper modules you've installed. We're not working directly in `package.json` file for this guide, but it's helpful to know what it is.

Many npm packages also have _dependencies_. These are other packages that the main package requires in order to run correctly. Often these dependencies will be installed automatically with whatever package you wanted, but sometimes they will need to be installed manually. This can be the source of many set-up headaches! A normal dependency is one that your project relies on at runtime, like jQuery for a live webpage. A _dev-dependency_ is one that is only required during the development process and is **not** necessary for your finished application to function. ESLint & Prettier are dev-dependencies.
<br>

### What the heck are dotfiles?!
_Dotfiles_ are hidden files used to set the configuration for many different types of programs, including Bash, Zsh, Vim, VS Code, ESLint and Prettier. They're called dotfiles because the filenames start with a leading `.` that renders them hidden from normal file viewers, including the `ls` command. To view hidden files within the terminal, you can use:

`ls -a -l`

where `-a` shows hidden files and `-l` displays the results as a list. Examples of all my current dotfiles can be found [here](../Dotfiles).
<br>

### Checking if your install worked
Your ESLint squigglies should appear immediately on any files within your install directory and its sub-directories. However, if error-highlighting or fixOnSave doesn't appear to be working, try the steps below before any additional troubleshooting:

1. Create a new file in your installation directory (or its sub-directories).
1. Save that file once, preferably with at least a one line comment as content.
1. Edit the file in some way. You can paste in the test case provided below if you'd like. You should see errors being highlighted by ESLint.
1. Save the file again. At this point, many of the style errors (including line-length) should auto-fix.

Feel free to use this code example to check for a few different types of errors, but remember to edit it at least once if included in the initial save!

```javascript
let testFunc = function funcName (longArgNumberOne, longArgNumberTwo, longArgNumberFour, longArgNumberFive) {
  return "should be single quote and needs semicolon"
}
```
