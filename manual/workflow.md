# Workflow
*Working with the Useful Music Application*

## Overview/Glossary

The **Application** is built on a core of Ruby backend code with Erb templates, This is the code that makes up the files of this **Repository**. A **repository** is a collection of files which have all changes to them tracked and creating versions, in this case the version control software is called [git](http://code.tutsplus.com/tutorials/git-succinctly-introduction--net-33591). This **repository** is stored on Github, like dropbox but for git tracked files. The **Application** files are deployed to a **Cloud Server** where they run  as the application program. This is what answers when a url is visited, Heroku provides our cloud server.

## Git
This is the core of our workflow, we use git because it is extremely powerful. It allows several people to make changes to a single project, even single file, without knowing about other peoples intentions, each works on a separate branch before merging. Any previously committed version of the files call be accessed by rolling back. New work can be kept out of the main codebase before it is ready, on a separate branch. When it can then be submitted and reviewed in a pull request. This last point is summarised [here](https://guides.github.com/introduction/flow/).

## Also
**development** this is a git branch branch that is deployed to staging.

**Staging** this is a heroku server that is hosting the code in the development branch.

**master** this is a git branch that is deploted to production.

**Production** this is a heroku server that is hosting the code in the master branch.

## Contributing

**NB step one is really important**

#### 1. Switch away from the master branch
The master branch is the version of the code that is deployed to production. You can visit [this file]() on the development branch here. The development branch is automatically deployed to the staging enviroment. This is normally what you want when starting a new set of features

#### 2. Identify the files to change
Most of the time you will changing content. Content is stored in template files which have a `.erb` extension. For example the home page is at `app/views/home/index.erb` and the license page `app/views/about/licencing_and_copyright.erb`. Some files are broken down when content is shared e.g. editing `app/views/header.erb` will affect the header on all pages.

#### 3. Edit the file
In the top right of the file page the is an edit icon(pencil). Make your changes to the file.

#### 4. Commit changes
At the bottom of the page you can add a commit message e.g. 'Updated header.erb'. Then select the option ' Create a new branch for this commit and start a pull request'. Finally enter a name for your branch and propose the changes.

> **Naming**
> Descriptive names are helpful, A branch contains one or more commits. Your branch would normally be named something like 'new-header' while your commits would be 'added social icon' and 'fixed typo'

#### 5. Create pull request
Check that the base is to development and compare is set to your new branch. Most times all the defaults here are fine, click create pull request.

> **Pull Requests**
> These consist of a selection of changes you would like to apply to one specific version(branch) of the code base. By this point github will have automatically checked if these changes can be applied without conflicting destructivly with anyone elses work. We have also set up testing which check that the codebase with the changes in place passes all of our automated tests. If there is a fail at this point slack will be notified.

#### 6. Work with the pull request
An open pull request can have comments or further commits added until the feature is ready. You may also view on the files changed tab every line that will be changed by this pull request.

#### 7. Close the pull request
Click the green merge pull request button. Confirm the merge. Finally if you were using a feature branch (one that was not master or development) you may also now delete the branch.

> Commit directly
> When you were editing the file the top commit option was to commit directly. This applies the changes immediately and does not allow any review as a pull request. This is a faster way to make changes however commiting directly to master will push changes to production with much few oportunities to catch errors.

#### 8. Review on staging
When a pull request to make changes to development is closed the code is deployed to staging.

#### 9. Open master pull request
Go to the [repository homepage](https://github.com/CrowdHailer/useful-music) on github. On the menu on the right under issues click pull requests. Click new pull request. set the base as master and the compare as development. Click create new pull request. Create pull request. You can then review and close this request as in steps #6 and #7. (This time dont delete the branch) Once closed the changes will automatically be deployed to production.

> Cautiousness
> The second pull request from development to master will be all the same changes as when we were pulling from the feature branch to development. Most of the time reviewing this pull request will not be necessary but it is worth having as it will notify of failure.
