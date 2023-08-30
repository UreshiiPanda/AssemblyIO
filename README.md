# AssemblyIO

#### Assembly IO Procedures


<a name="readme-top"></a>


<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->


<!-- ![assembly io gif]() -->



<!-- ABOUT THE PROJECT -->
## About The Project

This is a program for practicing input and output procedures with MASM x86 Assembly. The program takes
in 10 signed decimal integers from the user, and then displays the integers, along with their sum and
their average. This activity is all about learning assembly via reading in strings and then converting
those strings to integers before writing those values to the console.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

This is a small and simple program but environments that run MASM can be rare. The options are usually
limited to the Visual Studio IDE or to a third-party app/webapp that runs assembly (usually using Wine to 
simulate a Windows Command Prompt). Both of these options are discussed below.

</br>

### Running with Visual Studio

Note that different versions/years of Visual Studio will have different requirements for running MASM x86.
Describing how to fully setup MASM on Visual Studio is beyond the scope of this ReadMe, but sources will be
provided below as to how to get started with this in Visual Studio 2017. Note that the Irvine Library is 
required to run the program.

[MASM & Irvine on VS 2017](http://www.asmirvine.com/gettingStartedVS2017/index.htm) 

[MASM setup guide for VS 2017](https://www.youtube.com/watch?v=-fCyvipptZU)

In order to use the program, please clone the repo or simply copy the sole .asm file:
  ```sh
     git clone https://github.com/UreshiiPanda/AssemblyIO.git
  ```

</br>

### Running with a MASM Windows Editor/Emulator

Luckily, [istareatscreens](https://github.com/istareatscreens) has built a portable MASM editor, complete
with everything needed to run the program, including the Irvine Library. Note that there is also a web version
available on the repo (below). Simply remove the "INCLUDE Irvine32.inc" line from this repo's code and paste it in
the editor. Note that you must click on the Wine window in order to initiate user input into Command Prompt.

[MASM Editor/Emulator](https://github.com/istareatscreens/wasm-masm-x86-editor)

<p align="right">(<a href="#readme-top">back to top</a>)</p>


