# Correctness, replicability (and reproducibility), auditing

Doing research today means writing code.

We usually learn to write code but not to take care of it in the long term

a common saying in the programming world is:

> write your code as if the next person having to work on it is a psychopath that knows where you live

Considering the number of projects that the average scientist has to follow nowadays, the cited psychopath might be yourself six months in the future!

* CORRECTNESS: to be sure that your code does exactly what you think it does; that any modification you perform does not introduce errors, and that is they do, you would be able to identify them and rollback from them
* REPLICABILITY - 1: you want to be able to repeat an analysis and obtain the same results, even after several months. This means keeping track of what are the prerequisites of the analysis, how to use it, on which data and which parameters
* REPLICABILITY - 2: Allow to someone else to do the same, ideally without you having to be physicall present in the same room with them to explain step-by-step all the process

* REPRODUCIBILITY: allow others to reuse the same analysis (and in general your ideas) on other data and use cases compared to the one you worked on
* AUDITING: keep the history of your project, knowing what have been done, when and why. This is necessary both to maintain the knowledge you obtain and to allow some external reviewer to verify what you did

What is necessary to have "healthy" code?

* version control
* documentation
* test procedures
* procedure automation
* well designed analysis pipeline

In this course our plan is to teach you, alonside how to write code, also how to manage your projects to avoid those moments of sheer terror, desperation and discomfort that you could feel otherwise

If you think I'm joking, imagine the following situations:

* Your simulation run for 36 hours, and it fails at the last step. You don't know how to recover, you have to start from scratch, without understanding where the error was

* while you edit your thesis you accidentally delete a paragraph (or an entire section) and you don't notice

* they ask you to modify a plot for an article, but to modify it you have to run again the previous 36 hours simulation

* you have to focus on the exams for 6-7 months and, when it's time to go back to your project, you can't remember what you did already tried and what was still on the todo list

* your program requires and very precise series of steps to be executed in the correct order. The cat hides the notes where you wrote them and put it under the couch

* you kept a proper documentation for your project, but with the last backup you forgot to copy the last version and now your documentation and your code are not in sync

* you modify your code and, while you are presenting it to your professor, you realize that there was a wrong step and the results are absurds

* you inherit someone else's code, and have no idea on why a specific line of code is there, but you cannot change it because you can't understand if it is relevant for the simulation

These are just some examples, really happened in real life, and are sources of stress that can be easily avoided

What we are going to learn do not negate complete and utter misfortune, but can limit the negative effects of the disasters

And their are easy enough to be used without erculean efforts

The main concept behind this examples and instruments is the correct management of metadata (data about data)

Consider a function in your code: variable names are absolutely arbitrary, and you can replace them with anything else without changing the behavior of the function.
But if the names are confusing, the code will be hard to understand, hard to modify and you would shortly forget what it is supposed to be doing.

And there is so much more, alonside naming conventions and comments that one can keeps track of, if one is aware of it.

## Distributed Version control and Code Source Management

I'm sure all of you, when working on an important file, have various versions, called

* doc_v1
* doc_v2
* doc_final
* doc_final_for_real
* etc...

This is already a very rough for of version control.

Thanks to the computer we can do better than this.

We can:

* keep track of everything that happens
* roll back to a previous version at any moment
* visualize the difference between two versions of it
* keep track of "parallel world versions" of our work

and so on.

The programs that allow one to do so are called Version Control Systems.

These work in tandem with Source Code Management tools, that also allow to keep track of:

* bugs
* documentation
* feature requests
* etc...

cit. 

> If it worth doing, it is worth doing under version control

You can use version control for any text-based file that you want, not just code.

For example you can also keep (and I suggest you do) your thesis and your research articles under VC.

One can still use version control for non text-based files, but it loses a great deal of its power.

Any time you stray away from text based files you lose the opportunity to use the full power of VC (and many other tools), and I personally think that this is a huge argument toward text-based solutions 

In this course we will use **git**  [(git-scm.com)](https://git-scm.com/) as a control version system, and the (free) website **GitHub** [(github.com)](https://github.com/) to do the general code management and as a central repository of our work

### full disclosure

I'm not a big fan of **git**.

I personally prefer a different system called **fossil** (https://fossil-scm.org).

I will teach you git (and GitHub) because they are the *de-facto* industry standards, and what you will be expected to know if you collaborate with other groups.

If any of you is curious about **fossil** and the diffences between it and git, I'll be happy to discuss them out of the lessons hours

## The idea behind git

If you were to design a simple version control system, how would you do it?

for a better written version, see http://tom.preston-werner.com/2009/05/19/the-git-parable.html

### version 1

> everytime you modify a file, save it as a new version with the date of edit attached to it

It is basically what you are already doing, but using date instead of numbers is more explicit.
But if you have to coordinate various files it's still a mess

### version 2
> save a snapshot of the whole directory everytime you modify something, with the date in the name

good for keeping various file together, but a huge waste of file

### version 3

> go back to version 1, but keep a document (the manifest) with written what is the current state of the directory

We are already 90% of the road toward a real version control system, but how would I know the state in previous moments in time?

### version 4

> keep several manifests, each one referencing the one before it and what changed between them

99% of the way now... how do you manage collaboration and such?

### version 5

> Identify each file and manifest with a unique hash, store the various versions of the various files in a hidden subdirectory together with the manifests, build the directory based on those, exchange the blobs (files) and manifests with other people

Now you have basically a simple implementation of git

## ideas behind git

* you have to choose which files to follow, and which files to ignore
* everytime you change one or more files, you have to **commit** them to the VC, to let it know to create a new snapshot
* once in a while, you have to sync with the remote server (GitHub)

## Using Git

**git** is based on subcommands.

This means that all the operations you need to do are going to be called as:

    git <some_command> command options
    
some commands will be:

* commit
* push/pull
* diff
* history
* etc...

### Setting up git    

First thing, tell git who you are.

This info are required, and will be attached to all the commits you do
    
    git config --global user.name "Enrico Giampieri"
    git config --global user.email "enrico.giampieri@unibo.it"

### creating the repository

I need to create an empty folder to host my project

    mkdir myproject
    cd myproject
    
and now I can initialize the git repository
    
    git init

### obtain the current situation of the repository

tells you which files are new, which are modified, and which have been deleted

    git status

### Adding a file to the one you follow
    
    git add myfile.txt
    git status
    

### Commit the snapshot to the history of the repository
    
commit all the changes
    
    git commit -a -m "added the first file"
    
you can also add one or more modified files again to tell git that you want to keep trackof only those changes, and then do

    git commit -m "my commit only of the staged modifications"

### show the history of the current branch

for each commit it shows the message and the SHA (hash) of the commit

    git log
    
all the commits that are related to a specific file

    git log myfile.txt

### show the edits

after you edit your file, you chan check what has been changed for each file

    git diff myfile.txt
    
or for the whole directory

    git diff

### edit on the history

differences between the file and the last commit (**HEAD**)

    git diff HEAD myfile.txt
    
differences between the file and the commit before the HEAD (or the one even before that)


    git diff HEAD~1 myfile.txt
    git diff HEAD~2 myfile.txt
    
difference with a specific commit from the history

    git diff <commit SHA1> myfile.txt

### revert back history

replace the current version of the file with a previous one from an older commit

    git checkout <commit SHA1> myfile.txt
    
    
You could revert the whole repository if you forget the `myfile.txt`, so please the careful!!

if you want to go back to the latest commit you did, you can write:

    git checkout master
    
beware that in both cases you will lose all the edits you have done and not commited!

### removing and renaming a file

    git rm <oldfile>
    git mv <oldfile> <newfile>
    
watch out because git will do the modification and keep track of it.

you can always revert the changes by doing

    git checkout HEAD <oldfile>
    
git will explain precisely what to do to revert your changes, just remember to always check the status of the repo before committing!!!

### sync with the main server - setting up the remote

The big advantage of distributed version control systems such as git is that you can store your repository on a remote server that multiple people can collaborate on.

first thing you have to set the remote server location (such as github), with one of two version depending if it is a public location or behind an ssh login.

    git remote add <origin> ssh://login@IP/path/to/repository

    git remote add <origin> http://IP/path/to/repository
    
you can have multiple remotes, and each one will have to be synced independently. **origin** is the most common name.

you can also duplicate an existing repository in a clean folder with 

    git clone http://IP/path/to/repository
    
this will automatically also set up the remote for you

to see the list of currente remotes, you can use:

    git remote -v

#### note - updating the origin

If you want to change the location for a remote, such as origin, of your repository, you have to update it, don't try to use again `remote add`

    git remote set-url origin <link to repo>

### sync with the main server - push and pull

once you have the remote set up, everytime you want to modify the project, you should

    git pull origin master
    
to get the latest updates from the other authors.
After you do your commits, you can

    git push origin master
    
to share it with them.

**origin** is the name of the remote to which you are syncing, if you use a different name, work accordingly

**master** is the name of the main branch of commits (the possible parallel realities you can work on).
If you work on different branches, change them accordingly.

### sync with the main server - merging conflicts

If you and another author modify the same file, git will try to be smart and merge by itself the edits, as long as they involve different part of the file.

If you are editing the same positions, it will complain, **stop you from committing** and ask you to **solve it by hand**, giving you a modified version of the file that highlight the stuff that you need to merge by hand.

To limit this, try to keep each commit nice and well focused, so that you don't risk modifying random stuff in a file and risk a merge conflict

![](https://github.com/louim/in-case-of-fire/blob/master/in_case_of_fire.png?raw=true)

### ignoring stuff

sometimes you will have some files you don't want to be notified about, for example chaches, temporary files, etc...

For these files, you can silence all the notifications by creating a `.gitignore` file, that is a list of filters that will be used to not show the files.

for example, a `.gitignore` file could be:

    *.temp
    *.cache
    
you have to leep the .gitignore under version control like any other file!

### Alternative histories - branching

Branching is the process by which you can create alternative realities in your repository to experiment without messing up other people's work.

it can lead to some real mess, so use them sparingly...
