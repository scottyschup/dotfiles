module.exports = {
  extends: [
    'react-app',
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended'
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: './tsconfig.json',
  },
  plugins: ['@typescript-eslint', 'import', 'react' ],
  root: true,
  rules: {
    '@typescript-eslint/explicit-module-boundary-types': 'off',
    '@typescript-eslint/no-explicit-any': 'warn',
    '@typescript-eslint/member-delimiter-style': 'warn',
    '@typescript-eslint/no-extra-parens': [
      'error',
      'all',
      { 'nestedBinaryExpressions': false },
    ],
    '@typescript-eslint/no-non-null-assertion': 'off',
    '@typescript-eslint/no-unnecessary-boolean-literal-compare': 'warn',
    '@typescript-eslint/no-unnecessary-type-assertion': 'warn',
    '@typescript-eslint/no-unused-vars': [
      'warn',
      {
        argsIgnorePattern: '^_',
        varsIgnorePattern: '^_',
      },
    ],
    '@typescript-eslint/no-use-before-define': ['error'],
    '@typescript-eslint/semi': 'warn',
    'arrow-spacing': ['warn'],
    'brace-style': ['error', '1tbs', { "allowSingleLine": true }],
    'comma-dangle': ['warn', 'always-multiline'],
    'comma-spacing': ['warn'],
    'generator-star-spacing': ['warn', { before: false, after: true }],
    'import/order': [
      'error',
      {
        groups: ['builtin', 'external', ['internal', 'sibling', 'parent', 'index']],
        pathGroups: [
          {
            pattern: 'react',
            group: 'external',
            position: 'before',
          },
          {
            pattern: '~*',
            group: 'internal',
            position: 'before'
          },
          {
            pattern: '~*/**',
            group: 'internal',
            position: 'before'
          },
        ],
        pathGroupsExcludedImportTypes: ['react'],
        'newlines-between': 'always',
        alphabetize: {
          order: 'asc',
          caseInsensitive: true,
        },
      },
    ],
    'import/prefer-default-export': 'off',
    'indent': ['warn', 2, { 'SwitchCase': 1 }],
    'key-spacing': ['warn'],
    'keyword-spacing': ['warn'],
    'max-len': ['warn', {
      code: 100,
      ignoreComments: true,
      ignoreTrailingComments: true,
      ignoreUrls: true,
      tabWidth: 2,
    }],
    'no-console': [
      'error',
      {
        allow: [
          'debug',
          'error',
          'group',
          'groupCollapsed',
          'groupEnd',
          'info',
          'memory',
          'table',
          'time',
          'timeEnd',
          'timeLog',
          'trace',
          'warn',
        ],
      }
    ],
    'no-debugger': 'warn',
    'no-extra-boolean-cast': 'warn',
    'no-multi-str': 'off',
    'no-multiple-empty-lines': ['warn', { max: 1 }],
    'no-param-reassign': [
      'error',
      {
        // Ignore property modifications for state because @reduxjs/toolkit uses immer to allow you
        // to modify the state object instead of creating a new 'draft'
        props: true,
        ignorePropertyModificationsFor: ['draft']
      }
    ],
    'no-unreachable': 'off',
    'no-unused-vars': 'off',

    // Addressing the false positives from this rule: https://stackoverflow.com/a/64024916/3251463
    'no-use-before-define': 'off',

    // `object-curly-newline` is sometimes helpful, but usually a PITA, so make
    // sure it's commented before approving/merging PRs:
    // 'object-curly-newline': ['warn', { multiline: true }],

    'object-curly-spacing': ['warn', 'always'],
    'padding-line-between-statements': [
      'error',
      { blankLine: 'always', prev: '*', next: 'return' },
      { blankLine: 'always', prev: 'return', next: '*' },
      { blankLine: 'always', prev: ['const', 'let', 'var'], next: '*'},
      { blankLine: 'any', prev: ['const', 'let', 'var'], next: ['const', 'let', 'var']},
      { blankLine: 'always', prev: ['case', 'default'], next: '*' },
      { blankLine: 'always', prev: '*', next: 'multiline-block-like' },
      { blankLine: 'always', prev: 'multiline-block-like', next: '*' },
    ],

    'quote-props': ['warn', 'as-needed'],
    'quotes': ['warn', 'single'],
    'semi-spacing': ['warn', { before: false, after: true }],
  },
  settings: {
    'import/resolver': {
      typescript: {},
    },
  },
}
