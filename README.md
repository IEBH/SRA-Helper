SRA-Helper
==========

<p align="center"><a href="https://github.com/CREBP/SRA-Helper/raw/master/builds/SRA-Helper-Bond.exe">
  <img src="https://raw.githubusercontent.com/CREBP/SRA-Helper/master/src/img/download.png" alt="Download SRA-Helper"/>
</a></p>

A simple helper tool to make EndNote a little easier to use.

This script installs various hotkeys which assist with EndNote reference screening.


Keys
----

| Key                 | Description                                             |
|---------------------|---------------------------------------------------------|
| `1` \ `Space bar`   | Move reference to first group                           |
| `2` \ `Left arrow`  | Move reference to second group                          |
| `3` \ `Right arrow` | Move reference to third group                           |
| `4` \ `0`           | Move reference to fourth group                          |
| `Numpad *`          | Search the reference title with Bond Library search     |
| `Numpad /`          | Search the reference title with Google Scholar          |
| `Numpad -`          | Search the reference title with PubMed                  |
| `Numpad +`          | Copy a searchable version of the title to the clipboard |
| `Pause`             | Exit SRA-Helper                                         |
| `End`               | Debugging information                                   |



Installation
============
The simplest way to get SRA-Helper running is to [download the compiled program](https://github.com/CREBP/SRA-Helper/raw/master/SRA-Helper.exe) and run it.

You will see this icon: ![SRA-Helper tray icon](src/SRA-Helper.png) in the system tray when the program is running.

Simply hit any of the above [keys](#keys) to run that function. The keys will **only** work when viewing an EndNote citation library (no other screen within EndNote). It is recommended that you create the groups before trying to move references to them.


| Filename                                                                                      | Description                      |
|-----------------------------------------------------------------------------------------------|----------------------------------|
| [SRA-Helper-Bond.exe](https://github.com/CREBP/SRA-Helper/raw/master/SRA-Helper-Bond.exe)     | SRA-Helper for Bond University   |
| [SRA-Helper-Monash.exe](https://github.com/CREBP/SRA-Helper/raw/master/SRA-Helper-Monash.exe) | SRA-Helper for Monash University |


Bugs
====
**CAVEAT EMPTOR**: This tool is really just a key remapper. It applies the various shortcuts within EndNote to manipulate the library as needed. Since its pretty 'hacky' the user should be aware that there *may* be side-effects.

If you find any bugs please [contact the developer](mailto:matt_carter@bond.edu.au) and we will do our best to address them.


Credits
=======
Thanks to the [Bond University Center for Research in Evidence-Based Practice](http://www.crebp.net.au), the [Silk icon set](http://www.famfamfam.com/lab/icons/silk) and the [AutoIt](http://autoitscript.com) scripting language.
