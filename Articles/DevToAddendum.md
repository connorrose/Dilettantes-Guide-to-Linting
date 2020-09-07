If you made it to the end of [the previous article](https://dev.to/connorrose/a-dilettante-s-guide-to-linting-5685) with everything working, you're in great shape. You can safely call it a day and have a working set-up for many _.js_ files to come. If you want to tailor your environment a bit more, this addendum will walk you through common additional settings. You can enable some or all of these to personalize your environment and/or enforce stricter style adherence than the simple config detailed previously. If you're interested, you can view my complete ESLint config file [here](https://github.com/connorrose/Dilettantes-Guide-to-Linting/blob/master/.eslintrc.json).

### Reference Docs
If you want to explore the settings on your own, the following links are good places to start. For the packages, don't be afraid to dig around in the source code! It's a great way to understand more about how things function and interconnect under-the-hood. 
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

### .prettierrc options
As discussed, Prettier doesn't let us do a whole lot of configuration. We only needed to change two options to match AirBnB, but we can customize [a few more](https://prettier.io/docs/en/options.html) if we want. [My Prettier config file](https://github.com/connorrose/Dilettantes-Guide-to-Linting/blob/master/.prettierrc.json) specifies all the options I'm opinionated about, even though I'm just re-stating the default behavior for most of them.

### String Format Power-Ups
One set of rules that breaks during Prettier / ESLint integration is string templating. We want to avoid template literals unless necessary, but always prefer template literals over string concatenation. To re-enable this behavior, we need to add an explicit rule in our **`.eslintrc.json`** file:

```jsonc
{
  //env, preset, ...
  "rules": {
    //... other rules
    "quotes": [
      "error",
      "single",
      { "avoidEscape": true, "allowTemplateLiterals": false }
    ],
    //... more rules
  }
}
``` 

### Environment Globals: the latest and greatest
[Environments](https://eslint.org/docs/user-guide/configuring#specifying-environments) in ESLint are just sets of global variables. By specifying an environment, we tell ESLint to **not** mark these variables as errors when we use them in a file without having provided our own explicit definition. Globals can include keywords like _Set_, for ES6 code, or the _window_ object, for browser-based code. You can specify as many different or overlapping environments as you want, but you shouldn't start enabling everything without good reason. If we're working exclusively on browser-based code, leaving Node out of our environment list will ensure we don't sneak in any Node-specific globals by mistake. These are a few of the most common environments you might encounter:

- `browser`: Covers all the browser-specific globals, like _document_ or _window_, available to front-end code.
- `node`: Covers the globals available to back-end code within Node's runtime environment.
- `es2020`: This lets us use all the Javascript language features up through the most recent [ECMAScript spec](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Language_Resources), including features from earlier specs like ES6. If your code will be executed in a [runtime environment](https://medium.com/@olinations/the-javascript-runtime-environment-d58fa2e60dd0) that **doesn't** support these features yet (and you're not using a [transpiler](https://scotch.io/tutorials/javascript-transpilers-what-they-are-why-we-need-them)), you may want to specify `es6` instead.
- `jquery`: If you use jQuery, this will save you from `$`-operator warnings.
- `jest`: Eliminates errors for built-in [Jest](https://jestjs.io/en/) syntax like `describe()` and `test()`. 

### Additional ESLint Rules (or, why eslint-config-airbnb isn't enough)
ESLint supports three levels of warning for most rules. You can set rules to a specific warning level to group your errors in whatever way works for you:

- `0` or `"off"`: the rule will not be flagged whatsoever in your code. 
- `1` or `"warn"`: you'll see a yellow or orange squiggly, and the rule will be counted in the ⚠ status bar symbol within VS Code.
- `2` or `"error"`: normal error, red squiggly, counted with ⓧ in VS Code status bar.

If you've gotten this far, you may have noticed some rules from the AirBnB style guide aren't showing as warnings or errors. If you [dig into the package source code](https://github.com/airbnb/javascript/tree/master/packages/eslint-config-airbnb-base/rules), you'll see that not every rule specified in the style guide has actually been enabled! We can re-enable any of these omissions by adding them to the `"rules"` object in **`.eslintrc.json`**:

```jsonc
  "rules" {
    // Not all missing rules are listed here
    "default-case-last": "error",
    "default-param-last": ["error"],
    "no-useless-call": "error",
    "prefer-exponentiation-operator": "error",
    "prefer-regex-literals": "error",
    //...
  }

```

### Nested Config Files
Sometimes you'll clone a project that already contains ESLint configuration file(s) and packages. If you have multiple configuration files in a nested directory structure, ESLint will automatically try to combine _all_ those files until it hits your home directory. To prevent this behavior, add `"root": true` to the outermost **`.eslintrc*`** file you want included in the chain. Note that ESLint applies a hierarchy of filetypes when determining how to apply multiple config files within the same folder:

1. **.eslintrc.js**
1. **.eslintrc.yaml**
1. **.eslintrc.yml**
1. **.eslintrc.json**
1. **.eslintrc**
1. **package.json**

See [the ESLint docs](https://eslint.org/docs/2.0.0/user-guide/configuring#configuration-cascading-and-hierarchy) for more info. Additionally, be aware that Prettier uses a [different precedence](https://prettier.io/docs/en/configuration.html) for _it's_ config file extensions:  
1. **"prettier"** key in **`package.json`**
1. **.prettierrc** file (containing either JSON or YAML)
1. **.prettierrc.json**, **.prettierrc.yml**, or **.prettierrc.yaml**
1. **.prettierrc.js** or **prettier.config.js** using `module.exports`
1. **.prettierrc.toml**

### React!
Guess what - _you've already set up coverage for React._ The `eslint-config-airbnb` package we installed brought along [eslint-plugin-react](https://github.com/yannickcr/eslint-plugin-react) as a dependency, and the AirBnB ruleset we extended includes configuration for React. For maximum utility, we should still tweak a few settings:

#### Within `.eslintrc.json`
1. Add `"prettier/react"` as the _last_ item in the `"extends"` array.
    ```json
    "extends": ["airbnb", "prettier", "prettier/react"],
    ```
1. Update `"parserOptions"` to support JSX syntax:
    ```json
    "parserOptions": {
      "ecmaFeatures": {
        "jsx": true
      }
    }
    ```
1. Add any additional React-specific rules you may want:
    ```jsonc
      // just a few of the possible rules
      "react/prefer-stateless-function": ["warn"],
      "react/jsx-key": "warn",
      "react/no-direct-mutation-state": "error",
      "react/no-adjacent-inline-elements": "error"
    ```
_Note:_ We **don't** need to add `"react"` as a plug-in, since `eslint-config-airbnb` already took care of that for us.

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

## NOTES

#### Reminder
Prettier only fixes a narrow selection of style errors. It cannot fix most of the structural problems that ESLint catches. ESLint will still flag those additional errors, but you will need to manually review the warning-squigglies to address anything Prettier and ESLint couldn't fix automatically.

### A few words on npm
**_npm_** is a package manager. It lets you use bits of code that other people have written, known as _packages_ or _modules_, on your local machine (_ie_, your laptop / desktop / hotwired Motorola Razr / etc). These packages can either be installed _globally_, meaning they are accessible everywhere on your computer, or _locally_, meaning they are only available in a certain folder (or _directory_) and it's subfolders (or _sub-directories_). The folder that contains all of your project files & subfolders, including your npm modules, is sometimes called your project's _root_ directory. Additionally, npm uses a [package.json](https://docs.npmjs.com/files/package.json) file to store and manage information about your project and its associated packages. This is a file written in JSON that tracks lots of information about your project, including info on the various packages you've installed. We're not working directly with the `package.json` file in guide, but it's helpful to know what it is.

Many npm packages also have _dependencies_. These are other packages that the main package requires in order to run correctly. Often these dependencies will be installed automatically with whatever package you wanted, but sometimes they will need to be installed manually. A normal dependency is one that your project relies on at runtime, like jQuery for a live webpage. A _dev-dependency_ is one that is only required during the development process and is **not** necessary for your finished application to function. ESLint & Prettier are dev-dependencies. Less common, a _peer dependency_ is one required for another package to run, but which it expects you to already have installed. This is usually done to avoid installing multiple versions of the same package when using plugins.

### What the heck are dotfiles?!
_Dotfiles_ are hidden files used to set the configuration for many different types of programs, including ESLint, Prettier, VS Code, Bash, and Zsh. They're called dotfiles because the filenames start with a leading `.` that renders them hidden from normal file viewers, including the `ls` command. To view hidden files within the terminal, you can use:
```bash
$ ls -a -l
```
where `-a` shows hidden files and `-l` displays the results as a list.

### Checking if your install worked
Your ESLint squiggles should appear immediately on any files within your install directory and its sub-directories. However, if error highlighting or fixOnSave doesn't appear to be working, try the steps below before any additional troubleshooting:

1. Create a new file in your installation directory (or its sub-directories).
1. Save that file once, preferably with at least one line of content.
1. Edit the file in some way. You can paste in the test case provided below if you'd like. You should see errors being highlighted by ESLint.
1. Save the file again. At this point, many of the style errors (including line-length) should auto-fix.

Feel free to use this code example to check for a few different types of errors, but remember to edit it at least once if included in the initial save!

```javascript
let testFunc = function funcName (longArgNumberOne, longArgNumberTwo, longArgNumberFour, longArgNumberFive) {
  return "should be single quote and needs semicolon"
}
```