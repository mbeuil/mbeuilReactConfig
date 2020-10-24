#!/bin/bash

# ---------------
# Color Variables
# ---------------

RED="\033[0;31m"
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
LCYAN='\033[1;36m'
NC='\033[0m'

# --------------
# Pause function
# --------------

function pause(){
   read -p "$*"
}

# ------------
# Introduction
# ------------

echo
echo -e "${LCYAN}/* ************************************************************************** */"
echo -e "/*                                                                           ${LCYAN} */"
echo -e "/*   ${NC}By: ${LCYAN}mbeuil${NC}                                      :::      :::  ::::::::${LCYAN}   */"
echo -e "/*   ${NC}                                               :+::    ::+:  :+:     :+: ${LCYAN}*/"
echo -e "/*   ${NC}Git: @mbeuil                                  +:+ :  : +:+  +:+     +:+  ${LCYAN}*/"
echo -e "/*   ${NC}                                             +#+  +#+ +#+  +#++#++#+   ${LCYAN}  */"
echo -e "/*   ${NC}Created: 2020/10/01                         +#+      +#+  +#+      +#+  ${LCYAN} */"
echo -e "/*   ${NC}                                           #+#      #+#  #+#     #+# ${LCYAN}    */"
echo -e "/*   ${NC}Press ${LCYAN}[Enter]${NC} key to continue             ###      ###  ##########  ${LCYAN}     */"
echo -e "/*                                                                            */"
echo -e "/* ************************************************************************** */${LCYAN}"${NC}
echo

echo
echo -e "${GREEN}Starting a new React APP ... ${NC}"
echo

# ---------------------
# REACT APP CONFIG TOOL 
# ---------------------

# App name selection

echo -e "Name your new React App :"
echo -e "${RED}* name can no longer contain capital letters${NC}"
read app_name

# Framework Manager prompt

echo
echo "Which framework are you using ?"
select framework_choices in "create-react-app" "Cancel"; do
  case $framework_choices in
    create-react-app ) framework_init="npx create-react-app ${app_name}"; break;;
    skip ) framework_init="skip"; break;;
    Cancel ) exit;;
  esac
done

if [ "$framework_init" != "skip" ]; then
  echo
  echo -e "${LCYAN}Creating your repo and installing your ${app_name} react app... ${NC}"
  echo
  $framework_init 
  echo
  echo "Switch to ${app_name} directory."
  cd ${app_name}
fi





# --------------------------------------
# Prompts for configuration preferences
# --------------------------------------

# Package Manager Prompt

echo
echo "Which package manager are you using ?"
select package_command_choices in "Yarn" "npm" "Cancel"; do
  case $package_command_choices in
    Yarn ) pkg_cmd='yarn add'; break;;
    npm ) pkg_cmd='npm install'; break;;
    Cancel ) exit;;
  esac
done
echo

# File Format Prompt

echo "Which ESLint and Prettier configuration format do you prefer ?"
select config_extension in ".js" ".json" "Cancel"; do
  case $config_extension in
    .js ) config_opening='module.exports = {'; break;;
    .json ) config_opening='{'; break;;
    Cancel ) exit;;
  esac
done
echo

# Checks for existing eslintrc files

if [ -f ".eslintrc.js" -o -f ".eslintrc.yaml" -o -f ".eslintrc.yml" -o -f ".eslintrc.json" -o -f ".eslintrc" ]; then
  echo -e "${RED}Existing ESLint config file(s) found:${NC}"
  ls -a .eslint* | xargs -n 1 basename
  echo
  echo -e "${RED}CAUTION:${NC} there is loading priority when more than one config file is present: https://eslint.org/docs/user-guide/configuring#configuration-file-formats"
  echo
  read -p  "Write .eslintrc${config_extension} (Y/n)? "
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}>>>>> Skipping ESLint config${NC}"
    skip_eslint_setup="true"
  fi
fi

# Checks for existing prettierrc files

if [ -f ".prettierrc.js" -o -f "prettier.config.js" -o -f ".prettierrc.yaml" -o -f ".prettierrc.yml" -o -f ".prettierrc.json" -o -f ".prettierrc.toml" -o -f ".prettierrc" ]; then
  echo -e "${RED}Existing Prettier config file(s) found${NC}"
  ls -a | grep "prettier*" | xargs -n 1 basename
  echo
  echo -e "${RED}CAUTION:${NC} The configuration file will be resolved starting from the location of the file being formatted, and searching up the file tree until a config file is (or isn't) found. https://prettier.io/docs/en/configuration.html"
  echo
  read -p  "Write .prettierrc${config_extension} (Y/n)? "
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}>>>>> Skipping Prettier config${NC}"
    skip_prettier_setup="true"
  fi
  echo
fi

# ----------------------
# Perform Configuration
# ----------------------

echo
echo -e "${GREEN}Configuring your development environment... ${NC}"



echo
echo -e "1/6 ${LCYAN}Prettier installation ... ${NC}"
echo
$pkg_cmd -D prettier

echo
echo -e "2/6 ${LCYAN}Eslint's plugins with airbnb's config installation ... ${NC}"
echo
npm install --save-dev eslint-config-kentcdodds

echo
echo -e "3/6 ${LCYAN}Making ESlint and Prettier play nice with each other ... ${NC}"
echo "See https://github.com/prettier/eslint-config-prettier for more details."
echo
$pkg_cmd -D eslint-config-prettier eslint-plugin-prettier


if [ "$skip_eslint_setup" == "true" ]; then
  break
else
  echo
  echo -e "4/6 ${YELLOW}Config file for Eslintrc builded !${NC}"
  > ".eslintrc${config_extension}" # truncates existing file (or creates empty)

  echo
  echo ${config_opening}'
  "extends": [
    "kentcdodds",
    "kentcdodds/react",
    "kentcdodds/jest",
    "kentcdodds/webpack",
    "plugin:prettier/recommended",
    "prettier/react"
  ],
  "rules": {
    // react v17 rules for new JSX transformation
    "react/react-in-jsx-scope": "off",

    "no-process-exit": "off",
    "import/no-dynamic-require": "off",
    "import/no-unassigned-import": "off",
    "no-console": "off",
    "no-nested-ternary": "off",
    "no-useless-catch": "off",
    "react/prop-types": "off"
  }
}' >> .eslintrc${config_extension}

echo  SKIP_PREFLIGHT_CHECK=true >> .env

echo  node_modules
      coverage
      build 

      /src/index.js
      >> .eslintignore

fi


if [ "$skip_prettier_setup" == "true" ]; then
  break
else
  echo -e "5/6 ${YELLOW}Config file for Prettier builded !${NC}"
  > .prettierrc${config_extension} # truncates existing file (or creates empty)

  echo ${config_opening}'
  "arrowParens": "avoid",
  "bracketSpacing": false,
  "endOfLine": "lf",
  "htmlWhitespaceSensitivity": "css",
  "insertPragma": false,
  "jsxBracketSameLine": false,
  "jsxSingleQuote": false,
  "printWidth": 80,
  "proseWrap": "always",
  "quoteProps": "as-needed",
  "requirePragma": false,
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "all",
  "useTabs": false
}' >> .prettierrc${config_extension}
fi

# Vscode config

echo
echo "Are you using vscode ?"
select editor_choices in "yes" "no" "Cancel"; do
  case $editor_choices in
    yes ) skip_vscode='false'; break;;
    no ) skip_vscode='true'; break;;
    Cancel ) exit;;
  esac
done
echo

if [ "$skip_vscode" == "true" ]; then
  break
else
  echo -e "6/6 ${YELLOW}Config file for .vscode builded !${NC}"

  mkdir .vscode

  echo '
  {
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true,
  "editor.detectIndentation": true,
  "editor.fontFamily": "Fira Code",
  "editor.rulers": [80],
  "editor.snippetSuggestions": "top",
  "editor.wordBasedSuggestions": false,
  "editor.suggest.localityBonus": true,
  "editor.acceptSuggestionOnCommitCharacter": false,
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.suggestSelection": "recentlyUsed",
    "editor.suggest.showKeywords": false
  },
  "editor.renderWhitespace": "boundary",
  "files.exclude": {
    "USE_GITIGNORE": true
  },
  "files.defaultLanguage": "{activeEditorLanguage}",
  "javascript.validate.enable": false,
  "search.exclude": {
    "**/node_modules": true,
    "**/bower_components": true,
    "**/coverage": true,
    "**/dist": true,
    "**/build": true,
    "**/.build": true,
    "**/.gh-pages": true
  },
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": false
  },
  "eslint.validate": [
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact"
  ],
  "eslint.options": {
    "env": {
      "browser": true,
      "jest/globals": true,
      "es6": true
    },
    "parserOptions": {
      "ecmaVersion": 2019,
      "sourceType": "module",
      "ecmaFeatures": {
        "jsx": true
      }
    },
    "rules": {
      "no-debugger": "off"
    }
  },
  "breadcrumbs.enabled": true,
  "grunt.autoDetect": "off",
  "gulp.autoDetect": "off",
  "npm.runSilent": true,
  "explorer.confirmDragAndDrop": false,
  "editor.formatOnPaste": false,
  "editor.cursorSmoothCaretAnimation": true,
  "editor.smoothScrolling": true,
  "php.suggest.basic": false
}
' >> ./.vscode/settings.json

echo .vscode/ >> .gitignore
echo .env >> .gitignore

fi

# ------------------
# Check for conflict
# ------------------

echo
echo
echo -e "${GREEN}Configuring other libraries... ${NC}"

# CSS in JS libraries

css_cmd=false

echo
echo "Which CSS in JS library will you use ?"
select css_library_choices in "emotion" "styled-components" "Cancel"; do
  case $css_library_choices in
    emotion ) css_cmd="$pkg_cmd emotion"; break;;
    styled-components ) css_cmd="$pkg_cmd styled-components"; break;;
    Cancel ) exit;;
  esac
done

if [ "$css_cmd" == "false" ]; then
  break
else
  echo
  echo -e "${YELLOW}CSS in JS library installation ...${NC}"
  echo
  $css_cmd
  echo
fi

echo
echo -e "${YELLOW}Installing husky pre-commit modul ...${NC}"
$pkg_cmd husky
echo
echo -e "${LCYAN} Don't forget to add a eslint script and the husky config to your package.json.${NC}"


echo
echo -e "${GREEN}Finished setting up !${NC}"
echo