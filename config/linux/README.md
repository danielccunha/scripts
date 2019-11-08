# Linux Configuration

Currently I'm a Manjaro user, so this scripts are focused on setting up Arch-based environments. Ideally, it should work with any operating system, but due to lack of time I can't fix it right know.

## Setting up

In this folder you'll find two important files, which are **packages.csv** and **post_installs.sh**. The first one is where you're going to specify the packages you need (obviously).

Basically, it's a CSV file with three columns which says which **package** it should install, if it has a **post install** script and if it should **force** the post install if package is already installed.

Post installs are scripts you run for setting up your packages like Git, Flutter and many others. You may just write a command or write the function name, which you should write it in the **post_installs.sh** script.

The reason of forcing running post install script is because some packages (like Git) already come with OS. In this case, the package won't be installed, but it will be configured.

Last but not least, I've already added some post installs functions I need. One of them is for setting up **Visual Studio Code**. In case you also use vscode, you may put your configuration in the vscode folder.

There you'll find three files which are pretty self-explanatory and have some examples. Just add your settings there and it will be added.

## Running

When you finish setting up the packages, just run it with the following commands:

```
chmod +x system.sh
./system.sh
```
