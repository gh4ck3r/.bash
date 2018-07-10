'use strict';

/* eslint-env node */
module.exports = {
  env: {
    es6: true,
    browser: true,
  },
  extends: 'eslint:recommended',
  parserOptions: {
    sourceType: 'module',
    ecmaVersion: 8,
  },
  rules: {
    indent:             [ 'error', 2 , {SwitchCase: 1}],
    'linebreak-style':  [ 'error', 'unix' ],
    quotes:             [ 'error', 'single', {
      avoidEscape: true,
      allowTemplateLiterals: true
    } ],
    semi:               [ 'error', 'always' ],
    'no-console':       'off',
    'no-unused-vars':   'warn',
  }
};
