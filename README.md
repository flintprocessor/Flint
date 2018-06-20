<div align="center"><img src="/Assets/logo.svg" width="150" /></div>
<h1 align="center">
  <b>Flint</b>
  <br>
  <a href="https://travis-ci.org/flintbox/Flint"><img src="https://travis-ci.org/flintbox/Flint.svg?branch=master" alt="Build Status" /></a>
  <a href="https://github.com/flintbox/Flint/releases"><img src="https://img.shields.io/github/release/flintbox/Flint.svg" alt="GitHub release" /></a>
  <a href="https://github.com/flintbox/Flint/blob/master/LICENSE"><img src="https://img.shields.io/github/license/mashape/apistatus.svg" alt="license" /></a>
  <a href="https://swift.org/package-manager"><img src="https://img.shields.io/badge/Swift%20PM-compatible-orange.svg" alt="Swift Package Manager" /></a>
  <a href="https://brew.sh"><img src="https://img.shields.io/badge/%F0%9F%8D%BA-Homebrew-yellow.svg" alt="Homebrew" /></a>
  <a href="https://github.com/yonaskolb/Mint"><img src="https://img.shields.io/badge/%F0%9F%8C%B1-Mint-brightgreen.svg" alt="Mint" /></a>
</h1>

***Never write same code again.***

**Table of Contents**
- [Installation](#installation)
- [Create Template](#create-template)
- [Environment Variable](#environment-variable)
- [Command](#command)
  - [Template](#template)
    - [Add](#add)
    - [Clone](#clone)
    - [List](#list)
    - [Remove](#remove)
  - [Spark](#spark)
  - [Input](#input)
  - [Version](#version)
  - [Help](#help)
- [Contribute](#contribute)

## Installation

### [Homebrew](https://brew.sh)

```shell
brew tap flintbox/Flint
brew install flint
```

### [Mint](https://github.com/yonaskolb/Mint)

```shell
mint install flintbox/Flint
```

### Make

#### Install

```shell
git clone https://github.com/flintbox/Flint
cd Flint
make
```

#### Uninstall

```shell
make uninstall
```

## Create Template

### Template Directory Structure

```
Template
└╴template.json
└╴template
└╴include
└╴prehooks
└╴posthooks
```

### template.json

Template manifest file. YAML is also supported.

```json
{
  "description": "Template description",
  "variables": [
    {
      "name": "Author"
    },
    {
      "name": "Module Name",
      "defaultValue": "CLI"
    }
  ],
  "prehooks": [
    "script1.sh",
    "script2.sh",
    "script3.sh"
  ],
  "posthooks": [
    "script4.sh",
    "script5.sh"
  ]
}
```

`description`

Template description. This field is optional.

`variables`

Variable used in template. Each item has `name` and optional `defaultValue`. This field is optional.

`prehooks`

Prehook scripts. These scripts will be executed in sequence before the variables are processed. Scripts can use `FLINT_OUTPUT_PATH` and `FLINT_ + each variable name` environment variable. This field is optional.

`posthooks`

Posthook scripts. These scripts will be executed in sequence after the variables are processed. Scripts can use `FLINT_OUTPUT_PATH` and `FLINT_ + each variable name` environment variable. This field is optional.

### Include Files

You can include other files under `include/` on template files or directory names with following variables.

```
__INCLUDE:PATH TO FILE__
___INCLUDE:PATH TO FILE___
--INCLUDE:PATH TO FILE--
{{INCLUDE:PATH TO FILE}}
```

For example, read file `include/license/MIT` and replace variable with the content.

```
{{INCLUDE:license/MIT}}
```

### Date Variables

Beside custom variables, predefined date variables are also available. Date variable has following form and processed with Swift [`DateFormatter`](https://developer.apple.com/documentation/foundation/dateformatter).

```
__DATE:LOCALE|DATE FORMAT__
___DATE:LOCALE|DATE FORMAT___
--DATE:LOCALE|DATE FORMAT--
{{DATE:LOCALE|DATE FORMAT}}
```

`LOCALE` is optional locale identifier.

`DATE FORMAT` can be one of the following values.

Type | Description
---- | -----------
`YEAR` | Date format `yyyy`.
`YEAR-SHORT` | Date format `yy`.
`MONTH` | Date format `MM`.
`MONTH-SHORT` | Date format `M`.
`DAY` | Date format `dd`.
`DAY-SHORT` | Date format `d`.
`SHORT` | System short date style.
`MEDIUM` | System medium date style.
`LONG` | System long date style.
`FULL` | System full date style.
Any String Value | Any date format needed.

Examples,

```swift
{{DATE:YEAR}} // 2018
{{DATE:ko_KR|FULL}} // 2018년 6월 20일 수요일
--DATE:yyyy M dd-- // 2018 6 20
```

### template

Actual template files to be copied. Name of file and folder or content of file can have variables.

*Available variable formats*
- `__VARIABLE_NAME__`
- `___VARIABLE_NAME___`
- `--VARIABLE_NAME--`
- `{{VARIABLE_NAME}}`

### prehooks

Prehook scripts.

### posthooks

Posthook scripts.

## Environment Variable

### Template Home

```shell
FLINT_TEMPLATE_HOME
```

Set path for template home.

## Command

### Template

#### Add

Copy template to template home path.

##### Command

```shell
flint template add <path-to-template> [<template-name>] [--force | -f] [--verbose | -v]
```

or

```shell
flint t a <path-to-template> [<template-name>] [--force | -f] [--verbose | -v]
```

##### Argument

`<path-to-template>`

Path to template.

`[<template-name>]`

Template name. This is sub path relative to template home. If not present, the value will be the last path component of path to template.

##### Option

`[--force | -f]`

Override existing template under template home.

`[--verbose | -v]`

Output more information.

#### Clone

Clone template repository to template home path.

##### Command

```shell
flint template clone <repository-url> [<template-name>] [--branch | -b <branch>] [--force | -f] [--verbose | -v]
```

or

```shell
flint t c <repository-url> [<template-name>] [--branch | -b <branch>] [--force | -f] [--verbose | -v]
```

##### Argument

`<repository-url>`

Repository URL to clone.

`[<template-name>]`

Template name. This is sub path relative to template home. If not present, the value will be the name from repository URL.

##### Option

`[--branch | -b <branch>]`

Branch to clone.

`[--force | -f]`

Override existing template under template home.

`[--verbose | -v]`

Output more information.

#### List

List available templates under template home.

##### Command

```shell
flint template list [--verbose | -v]
```

or

```shell
flint t l [--verbose | -v]
```

##### Option

`[--verbose | -v]`

Output more information.

#### Remove

Remove templates under template home.

##### Command

```shell
flint template remove <template-name>... [--verbose | -v]
```

or

```shell
flint t r <template-name>... [--verbose | -v]
```

##### Argument

`<template-name>...`

Templates to remove from template home.

##### Option

`[--verbose | -v]`

Output more information.

### Spark

Generate project from template.

#### Command

```shell
flint spark [<template-name>] [--template | -t <template-path>] [--output | -o <output-path>] [--input | -i <input-file-path>] [--force | -f] [--verbose | -v]
```

or

```shell
flint s [<template-name>] [--template | -t <template-path>] [--output | -o <output-path>] [--input | -i <input-file-path>] [--force | -f] [--verbose | -v]
```

#### Argument

`[<template-name>]`

Template from template home to use.

#### Option

`[--template | -t <template-path>]`

Path for template to use. If template name argument is presented, this value will be ignored.

`[--output | -o <output-path>]`

Path to write generated project. If not presented, current path for the process will be used.

`[--input | -i <input-file-path>]`

Variable input file path.

`[--force | -f]`

Override output path.

`[--verbose | -v]`

Output more information.

### Input

Generate variable input file from template.

#### Command

```shell
flint input [<template-name>] [--template | -t <template-path>] [--output | -o <output-path>] [--yaml | -y] [--force | -f] [--verbose | -v]
```

or

```shell
flint i [<template-name>] [--template | -t <template-path>] [--output | -o <output-path>] [--yaml | -y] [--force | -f] [--verbose | -v]
```

#### Argument

`[<template-name>]`

Template from template home to use.

#### Option

`[--template | -t <template-path>]`

Path for template to use. If template name argument is presented, this value will be ignored.

`[--output | -o <output-path>]`

Path to write generated file. If not presented, current path for the process will be used.

`[--yaml | -y]`

Use YAML format. If not presented, JSON format will be used.

`[--force | -f]`

Override output path.

`[--verbose | -v]`

Output more information.

### Version

Print binary version.

#### Command

```shell
flint version
```

or

```shell
flint v
```

### Help

Print available command list.

#### Command

```shell
flint help
```

or

```shell
flint h
```

## Contribute

If you have good idea or suggestion? Please, don't hesitate to open a pull request or send me an [email](mailto:contact@jasonnam.com).
