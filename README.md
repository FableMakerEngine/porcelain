# Porcelain

A set of helper classes and core game mechanics used by **Fable Maker** developed using Ceramic game engine.

## Development

- Clone the repository
  
```sh
git clone https://gitlab.com/FableMakerEngiine/porcelain
```

### Install dependencies

Install [Haxe](https://haxe.org/)

### Install ceramic

```sh
haxelib install ceramic
```

install ceramic globally

```sh
haxelib run ceramic setup
```

### Install ceramic locally

```sh
haxelib run ceramic setup -cwd path/to/porcelain/libs/ceramic
```

### Install Required Libs

```sh
ceramic libs
```

### Test The Sample

```sh
ceramic clay run web --setup --assets --cwd ./sample
```

or just run the build task within VSCode.

## Contribute
Read the [Contribution guide](./CONTRIBUTING.md)

## License
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
Currently under the [MIT license](./LICENSE)
