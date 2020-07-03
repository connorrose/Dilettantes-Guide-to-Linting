# ESLint > AirBnB > Prettier > VS Code: The TLDR version

If you already know your way around installing npm packages & setting up config files, and you just want a list of terminal commands to copy, this is the guide for you. However, it is still your responsibility to ensure the safety and correctness of the code contained herein! I make no such promises or guarantees, so if you CTRL+V+ENTER and h@ck3rm@n420 starts dancing across your screen, I will take absolutely no responsibilty for paying the dogecoin ransom.

1. `npm init -y`
1. `npm install -D prettier` (or `npm install -D @btmills/prettier` => see [main guide](./ESLint-Prettier#step-3-install-prettier-plugins))
1. `npm install -D eslint eslint-config-prettier eslint-plugin-prettier`
1. `npx install-peerdeps --dev eslint-config-airbnb`
1. Create and copy **`.eslintrc.json`** and **`.prettierrc`** from [Dotfiles](./Dotfiles)
1. Install the ESLint extension in VS Code
1. Update the following VS Code settings:
```json
{
  "[javascript]": {
    "editor.defaultFormatter": "dbaeumer.vscode-eslint"
  },
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  }
}
```