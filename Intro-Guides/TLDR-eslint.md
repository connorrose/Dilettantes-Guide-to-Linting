# ESLint > AirBnB > Prettier > VS Code: The TLDR version

If you already know your way around installing npm packages & setting up config files, and you just want a list of terminal commands to copy, this is the guide for you. However, _**it is still your responsibility to ensure the safety and correctness of the code contained herein!**_ I make no such promises or guarantees, so if you `CTRL+V+ENTER` and _h@ck3rm@n420_ starts dancing across your screen, I will take absolutely **no** responsibilty for paying the [DogeCoin](https://dogecoin.com/) ransom.

1. `npm init -y`
1. `npm install -D prettier`
1. `npm install -D eslint eslint-config-prettier eslint-plugin-prettier`
1. `npx install-peerdeps --dev eslint-config-airbnb`
1. Create **`.eslintrc.json`** and **`.prettierrc`**, then copy contents from the corresponding [dotfiles](../Dotfiles)
1. Install the [ESLint extension](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) in VS Code
1. Update the following VS Code settings:
```json
  "editor.defaultFormatter": "dbaeumer.vscode-eslint",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
```