# django-tools.tmbundle

Commands and tweaks for [Django](https://www.djangoproject.com/) projects, particularly relating to Pivotal Energy Solutions' product "Axis".  The bundle is developed and tuned in the latest [TextMate 2 alphas](https://github.com/textmate/textmate).

## Installation
Clone a copy of the repository's root to `~/Library/Application Support/Avian/Bundles`, or in some other location and symlink it there instead.

## Configuration
To specifically target Django-only Python files, many of the project-level commands activate on the `"project.attr.django"` scope.  This is done so that the `./manage.py shell` command can be launched in Terminal from any file in your project, without forcing you to open up a Python source file first.  Also, this means that the key bindings won't conflict with normal Python source files.

### Scope

To activate this scope attribute on your project, add the following to your project's `.tm_properties`:

    scopeAttributes = "attr.project.django"

`scopeAttributes` is a ` `-separated list of scope names you can arbitrarily assign to all files in the project.

Some commands might require the scope `"attr.project.pes"`, which would force you to use the following line instead:

    scopeAttributes = "attr.project.pes attr.project.django"
    
Like the other `.tm_properties` variables, you can compound your own value if you're already defining `scopeAttributes` in another `.tm_properties` file:

    scopeAttributes = "$scopeAttributes attr.project.pes attr.project.django"

Also, something like the following should be used to assign a `"attr.test.django"` scope to test files.

    [ "**/tests.py" ]
    scopeAttributes = "$scopeAttributes attr.test.django"


### Optional settings
#### `DJANGO_SETTINGS_MODULE`
_Example: `DJANGO_SETTINGS_MODULE = 'settings.local'`_

This variable can be set to a module path [as described in the Django documentation](https://docs.djangoproject.com/en/dev/topics/settings/#designating-the-settings).  That is, it needs to be a dotted module path discoverable on the Python environment path.

Bundle commands that leverage the `manage.py` script will make sure this settings module is used.  Typically, this is required for projects that use a `settings` directory containing various separate settings modules.  If you aren't getting fancy with your setup, this isn't necessary to specify.

#### `DJANGO_MANAGE_SHELL`
_Example: `DJANGO_MANAGE_SHELL = 'shell_plus'`_

When you use the "shell" (`⌘>`) command, you can override the management command that is actually sent to the script.  By default this is just `"shell"`, but if (for example) you have [django-extensions](https://github.com/django-extensions/django-extensions) installed, you can set this to `"shell_plus"` instead.

#### `DJANGO_RUNSERVER_HOSTNAME`
_Example: `DJANGO_RUNSERVER_HOSTNAME = '0.0.0.0'`_

Sets the hostname used by the "runserver" (`⇧⌘R`) command.  Default is simply `'localhost'`.

#### `DJANGO_RUNSERVER_PORT`
_Example: `DJANGO_RUNSERVER_PORT = '8080'`_

Sets the port used by the "runserver" (`⇧⌘R`) command.  Default is `8000`.

#### `DJANGO_ALL_TESTS`
_Example: `DJANGO_ALL_TESTS = 'appname[ appname appname ...]'`_

The names of tests you want the "Run tests" (⌃⇧⌘R) command to execute.  If this is blank, then the command will let `manage.py` run all tests normally.

#### `SUBMODULES_DIRECTORY`
_Example: `SUBMODULES_DIRECTORY = 'lib'`_

Set this to where you keep your project's submodules.  the "Pull submodules" (`⌥⇧⌘U`) command will find all submodule directories at `"$SUBMODULES_DIRECTORY/*"` and run `git pull`.  See the command details below.

#### `COVERAGE_OUTPUT_DIRECTORY`
_Example: `COVERAGE_OUTPUT_DIRECTORY = '../'`_

This is the location that commands invoking the [coverage](http://nedbatchelder.com/code/coverage/) utility will store the generated `.coverage` file.  By default this is blank, storing it in the root of the project directory.

#### `VIRTUALENV`
_Example: `VIRTUALENV = 'env'`_

Path to the virtualenv directory from the project root.  Terminal commands will attempt to activate this environment before doing anything.

#### `VIRTUALENVWRAPPER`
_Example: `VIRTUALENVWRAPPER = 'axis'`_

Name of the virtualenv available for activation via the virtualenvwrapper command `workon`.  For example, `'axis'` would be the name of the environment that I should be able to activate from the command line with the following command:

    workon axis

`VIRTUALENVWRAPPER` will trump plain old `VIRTUALENV` if the two settings are both available.

To successfully use a couple of commands, ones that run within TextMate's process (not a separate Terminal tab), your `PATH` will need to include the location of `virtualenvwrapper.sh`, which is normally `source`d in your `.bash_profile`.  TextMate doesn't run that profile script or make changes to environment variables, so you may need to help it out in your `.tm_properties`:

    # My virtualenvwrapper.sh is located in my macports-activated Python framework 
    PATH = "/opt/local/Library/Frameworks/Python.framework/Versions/Current/bin:$PATH"

Alternately, if this is a common requirement, you can pop open TextMate's preferences and use the _Variables_ tab to enter the same information for TextMate's global (not project) use.

## Commands
Commands that open the Terminal make an effort to try to activate the local [virtualenv](http://www.virtualenv.org/en/latest/) or [virtualenvwrapper](http://www.doughellmann.com/projects/virtualenvwrapper/).  Make sure you set the [`VIRTUALENV`](#virtualenv) or [`VIRTUALENVWRAPPER`](#virtualenvwrapper) variables in your `.tm_properties` accordingly.

### Manage › shell (`⌘>`)
Opens a Terminal tab at the project directory (`$TM_PROJECT_DIRECTORY`).  If available, the [`DJANGO_MANAGE_SHELL`](#django_manage_shell) variable will replace the default `"shell"` command with something else, such as `"shell_plus"`.

### Manage › dbshell (`⌃⌘>`)
Opens a Terminal tab and runs `manage.py dbshell`.

### Manage › runserver (`⇧⌘R`)
Opens a Terminal tab and runs `manage.py runserver`.  The settings [`DJANGO_RUNSERVER_HOSTNAME`](#django_ruserver_hostname) and [`DJANGO_RUNSERVER_PORT`](#django_rusnerver_port) can override the default `'localhost'` and `8000` respectively.

### Manage › Run tests (`⌃⇧⌘R`)
Opens an HTML output window and displays the ongoing results of running the command `manage.py test`.

If [`DJANGO_ALL_TESTS`](#django_all_tests) is set to a list of test names, the string will be dropped in as arguments to `manage.py test`, causing the command to only run the specified tests.

### Manage › Run this test (`⌘R`)
_Scope: `attr.test.django`_

Examines the current line and upwards to find the nearest test method definition.  (Valid unittest method names are "runTest" and anything that starts with "test_".)

If a method name is found, the method's classname is searched out, and a command such as the following is run:

    ./manage.py test appname.TestClassName.test_method_name

As with commands that open Terminal, this respects [`DJANGO_SETTINGS_MODULE`](#django_settings_Module) and the local virtualenv.

If the app has some prefix module on the front, it will be respected.  This grants support to apps with a module path such as `myproject.apps.myapp.tests`.

### Manage › Run this test class (`⌘R`)
_Scope: `attr.test.django`_

Like `Run this test`, but looks only for the test class name, running a command such as the following:

    ./manage test appname.TestClassName
    
### Manage › Run app tests (`⌘R`)
_Scope: `attr.test.django`_

Like `Run this test`, but only discovers the app name, running a command such as the following:

    ./manage test appname

### Deploy › staging (`⌃⌥⌘F8`)
_Scope: `attr.project.pes`_

Runs `fab -R staging deploy` on a new Terminal tab.

### Open Terminal here (`⌘.`)
_Scope: `source.python, attr.project.django`_

Opens a Terminal tab at the file's location and activates the virtualenv.

### Pull submodules (`⌥⇧⌘U`)
_Scope: `attr.project.pes`_

Opens an HTML output window and displays the ongoing results of running updating submodules found in [`SUBMODULES_DIRECTORY`](#submodules_directory).  (In the future this command will read all submodules directly from `.git/config`.)

If a submodule is not on a branch (detached HEAD), it is first switched to `master`.

Once the submodule is confirmed to be on a branch (even if that branch is not `master`), the submodule is pulled from `origin/$branch`.
