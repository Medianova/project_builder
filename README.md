# Project Builder

Project builder is a scaffolding generator for dart project with custom templates. With it you can:

- build new projects based on template
- create new templates based on existing templates
- use placeholders in templates

Project builder comes with executable file for easier access to project from global scope.

## Installation

The easiest way to install this project is to clone it from [GitHub] [github] and then add it to your global pub list:

```sh
git clone https://github.com/Medianova/project_builder.git project_builder
cd project_builder
pub get
pub global activate --source path /path/to/cloned/project_builder
```

This will create builder executable file and add it to your global pub folder. If you add this folder to your PATH variable (just follow instructions showed by pub global activate command) you will be able to run this project globally just by typing builder in your console.

> You can find more info for activate command [here][pubActivate].

## Commands

Builder has 4 commands:

- list - lists all available templates
- info - gives all available information for a specific template
- copy - creates new template based on existing template
- build - generates new project based on a template

You can always use built-in help to get info about each command and available parameters by typing:

```sh
builder --help
builder help template
builder help template list
builder help template info
builder help template copy
builder help build
```

> You can run all commands with **-v** flag which will enable verbose mode and give you extra information.

## Usage

Here are some examples what you can do:

List all available templates:
```sh
builder template list
```

Get information for template called *basic*
```sh
builder template info -n basic
```

Create new template *custom_basic* by copying template *basic*
```sh
builder template copy -s basic -t custom_basic
```

Build new dart projects called *project1* in directory */dart/project1* by using template basic and by replacing placeholders *var1* with *"some value 1"* and *var2* with *"some value 2"*
```sh
builder build -n project1 -t basic -t "var1=some value 1" -t "var2= some value 2" -d "/dart/"
```

## Templates

Templates are stored in *project_builder/templates* folder. Here you can add new templates manually or create them by using *builder template copy* command.

Each template has a special **builder.json** file which has:

* description: short template description
* placeholders: list of placeholders used in template which will be replaced with values when building new project
* rename: list of files that needs to be renamed when building new project

Here is an example of builder.json file:

```json
{
  "description": "Basic console dart application",
  "placeholders" : [
    "author"
  ],
  "rename" : [
    {
      "from": "lib/main.dart",
      "to": "lib/{!name!}.dart"
    }
  ]
}
```

In template files you can then use placeholders with this syntax:

```
print('Author of project {!name!} is {!author!}');
```

Where *{!name!}* and *{!authors!}* are placeholders.

> Please note that you don't need to define *{!name!}* placeholder in *builder.json* because it will be automatically generated when running builder command from the name of the project you pass with *--name* option.

[github]: <https://github.com/Medianova/project_builder>
[pubActivate]: <https://www.dartlang.org/tools/pub/cmd/pub-global.html>
