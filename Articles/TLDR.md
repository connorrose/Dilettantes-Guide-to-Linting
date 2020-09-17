If you already know your way around installing npm packages & setting up config files, and you just want a list of terminal commands to copy, this is the guide for you. However, it is still your responsibility to ensure the safety and correctness of the code contained herein.

1. `npm init -y`
1. `npm i -D prettier` **OR** `npm i -D prettier@npm:@btmills/prettier`
1. `npm i -D eslint eslint-config-prettier eslint-plugin-prettier`
1. `npx install-peerdeps --dev eslint-config-airbnb`
1. Create a file named **`.eslintrc.json`** and paste in the following:  
    ```json
    {
      "env": {
        "browser": true,
        "node": true,
        "jquery": true,
        "es2020": true
      },
      "extends": [
        "airbnb",
        "prettier",
        "prettier/react"
      ],
      "plugins": ["prettier"],
      "parserOptions": {
        "ecmaFeatures": {"jsx": true}
      },
      "rules": {
        "prettier/prettier": ["warn"],
        "quotes": [
          "error",
          "single",
          { "avoidEscape": true, "allowTemplateLiterals": false }
        ]
      }
    }
    ```
1. Create a file named **`.prettierrc.json`** and paste in the following:
    ```json
    {
      "printWidth": 100,
      "singleQuote": true
    }
    ```
1. Install the [ESLint extension](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) in VS Code
1. Update the following VS Code settings:
    ```jsonc
    {
      "editor.defaultFormatter": "dbaeumer.vscode-eslint",
      "editor.codeActionsOnSave": {
        "source.fixAll.eslint": true
      }
    }
    ```
