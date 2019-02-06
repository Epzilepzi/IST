# History of Linux

## Background

- Based upon Unix and Multics, two projects which aimed to create a reliable multi-user operating system.
- Unix had many useful features (i.e. modular design, written in C to be portable, and being designed to allow multiple users and to be able to sustain multiple workloads), however still remained proprietary.
- A non-proprietary project based on linux called the GNU Project ("GNU's not Unix!") was started by Richard Stallman. The GNU kernel (GNU Hurd) was developed by Stallman as an alternative to Unix.
- During this time, Finnish undergrad Linus Torvalds started developing the linux kernel using the GNU C compiler. Initially called "Freax" (A portmanteau of the words "free" and the "x" to signify UNIX), it was later changed to Linux.

## Development

- Linux heavily relied on GNU code, including being compiled with the GNU C Compiler.
- The Linux kernel became its own project, and kernel version 1.0 was released by Torvalds and his team of core developers in 1994.
- The Linux kernel has since been continually developing, reaching kernel 4.20.4 at the time of writing.
- Linux has evolved into a variety of flavours or "distros". As well as this, Linux has been adapted to many use cases, including cloud servers, scientific research, and many other applications.

## List and History of Notable Linux Distros

### Debian - 1993

- First announced by Ian Murdock on August 16, 1993, Debian was created on the idea of a stable distro that could be downloaded and used for free by anyone, instead of requiring users to compile apps and libraries by themselves.
- Many distros can have their roots traced back to Debian, with numerous Ubuntu and Debian based distros around.

![Debian](https://www.maketecheasier.com/assets/uploads/2018/07/history-of-linux-02-Debian.png)

### Ubuntu - 2004

- The Debian Project was very ambitious, and was a huge step forward for linux, however it is a large distro with many extras that a lot of users didn't need.
- Ubuntu was created as a lightweight and user-friendly distro, based upon Debian technologies such as the same .deb package system.
- First released in 2004 (Version 4.10 Warty Warthog), it's versioning system is based on the first number being the year (i.e. 4 for 2004), and the second being the month (10 for October).
- A new version of Ubuntu is released every six years, and a long-term release is distributed every two years.

![Ubuntu](https://www.maketecheasier.com/assets/uploads/2018/07/history-of-linux-03-Ubuntu.png)

### Linux Mint - 2006

- Started in 2006 by Clément Lefèbvre and based on Ubuntu, it was designed to be a user-friendly distro, aimed at beginners.
- Linux Mint is different to a few distros in that it contains proprietary software as well as free and open source software. This allows for users to use and install apps with minimal interaction. Since it is Ubuntu based, Debian software is also mostly compatible.

![Mint](https://www.maketecheasier.com/assets/uploads/2018/07/history-of-linux-04-Mint.png)

### Red Hat Enterprise Linux (RHEL) and Fedora Linux - 1995/2003

- Red Hat Linux is one of the oldest Linux distros. Published in 1995, it was designed with business users in mind.
- Red Hat Enterprise Linux, released in 2003, was the successor to the old Red Hat Linux. Aimed at business users also, it is a paid distro.
- A home version of RHEL exists in the form of Fedora.
- RHEL and Fedora uses the .rpm package format, making it incompatible with other distros (i.e. Debian and Debian based distros).

![RHEL](https://www.maketecheasier.com/assets/uploads/2018/07/history-of-linux-05-Red-Hat.png)

### Slackware - 1992

- Launched in 1992 by Patrick Volkerding, it is the oldest surviving Linux distro. It held around 80% of the Linux market share in 1990.
- It was designed to be customisable and stable, which is why its usage declined as more user-friendly distros came to popularity.
- Slackware does not have an official package repo, thus requiring a lot of manual configuration.

![Slackware](https://www.maketecheasier.com/assets/uploads/2018/07/history-of-linux-06-Slackware.png)

### Arch Linux - 2002

- Created in 2002 by Judd Vinet, inspired by CRUX, another minimalist distro.
- It is a rolling-release distro, meaning the latest updates are pushed as soon as they are ready.
- It is designed with simplicity in mind, and by default only comes with the bare necessities. The user is then free to install any apps which they want.
- Arch linux uses binary and source packages, meaning it is up to the user to compile and build packages. This is helped by Pacman, the package management system, as well as the Arch User Repository (AUR).

![Arch](https://www.maketecheasier.com/assets/uploads/2018/09/arch-linux-history.jpg)

## File Management

- Linux follows a file system structure called the Linux File Hierarchy Structure or FHS.
- Under the FHS Standard, all files and directories go under the "root directory" which is `/`. This is the case even if the files are on different drives.
- Most Unix based systems follow the same directory structure.

![list](https://cdncontribute.geeksforgeeks.org/wp-content/uploads/linuxDir.jpg)
Diagram of a typical linux file system structure.

- There are many ways of accessing these files. They can be accessed via a terminal emulator, and directories can be navigated using commands such as `cd` and `ls`.
- Terminal based file managers also exist, such as Midnight Commander and Ranger.