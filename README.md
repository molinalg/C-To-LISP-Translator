# C To LISP Translator

## Description
Developed in 2023, "C To LISP Translator" is a university project made during the third course of Computer Engineering at UC3M in collaboration with @AliciaBR02.

It was made for the subject "Compilers" and corresponds to the final practice of this course. The main goal of the practice is to lean how to implement compilers using **Flex (Lex)** and **Bison (Yacc)**.

## Table of Contents
- [Installation](#installation-linux)
- [Usage](#usage-linux)
- [Problem Proposed](#problem-proposed)
- [License](#license)
- [Contact](#contact)

## Installation (Linux)
To install the necessary libraries for this project use the following command:
```sh
sudo apt-get install flex bison gcc
```

## Usage (Linux)
To execute the program, first compile de ".y" file using:

```sh
bison -d trad.y
```

Then compile de generated file with:

```sh
gcc -o translator trad.tab.c -lfl
```

Now the executable is ready to be used. You can execute it directly and write your own code to translate or use one of the examples like this:

```sh
./translator < adicionales/declaraciones_globales.c
```

## Problem Proposed
The problem proposed is to use Bison to create a compiler that receives code written in C language and translates it into LISP programming language. 

**NOTE:** It only works with simple code and does not translate everything **C** language has to offer. Examples of scripts the code can translate are included in this repository.

## License
This project is licensed under the **MIT License**. This means you are free to use, modify, and distribute the software, but you must include the original license and copyright notice in any copies or substantial portions of the software.

## Contact
If necessary, contact the owner of this repository.
