#!/usr/bin/env python

""" If run directly, pass a method name as an argument to have it executed. """

import sys
import os
import re

def get_content():
    with open(os.environ['TM_FILEPATH']) as f:
        return f.readlines()

def _get_this_module_name():
    """ Returns the module path between ``projectname.`` and ``.tests`` """
    app_dir = re.sub(re.escape(os.environ['TM_PROJECT_DIRECTORY']), '', os.environ['TM_FILEPATH'])
    app_module = app_dir.lstrip('/').rstrip('.py').replace('/', '.')
    app_module = re.sub(r'^(?:.*\.)?((?<=[.^]).*)\.tests\.?.*$', r'\1', app_module)
    return app_module

def _get_this_class_name(lines, indentation_level):
    match = None
    for i, line in enumerate(lines):
        match = re.match(r'^%sclass\s+([a-zA-Z_]\w*)\b' % indentation_level, line)
        if match:
            return match.group(1), i
    return None

def _get_this_function_name(lines):
    """
    Seeks through lines for the next function declaration named ``runTest`` or starting with the
    prefix ``test_``.
    
    Returns the indentation of the function and the name of the function as a 2-tuple.
    
    """
    
    match = None
    for i, line in enumerate(lines):
        match = re.match(r'^(\s*)def (runTest|test[^\(]*)', line)
        if match:
            return match.group(1), match.group(2), i

    print "Error: Can't find test method definition at current line's indentation."
    return
    
def get_this_test_module_name():
    """ Finds the module path after ``projectname`` and before ``tests``. """
    
    return _get_this_module_name()

def get_this_test_class_name():
    """ Finds the preceding top-level class name. """
    content = get_content()
    line_number = int(os.environ['TM_LINE_NUMBER']) - 1
    indentation_level = ''
    
    # Get class
    class_name, _ = _get_this_class_name(content[:line_number][::-1], indentation_level)
    
    # Get test module
    app_module = _get_this_module_name()
    
    return '.'.join((app_module, class_name))

def get_this_test_method_name():
    """ Finds the preceding ``classname.methodname`` string from the current line. """
    
    content = get_content()
    line_number = int(os.environ['TM_LINE_NUMBER'])
    current_line = content[line_number]
    
    # Get method
    indentation_level, test_name, method_line = _get_this_function_name(content[:line_number][::-1])
    
    # Get class
    indentation_level = reduce_indentation(indentation_level)
    class_name, _ = _get_this_class_name(content[:line_number - method_line][::-1], indentation_level)
    
    # Get test module
    app_module = _get_this_module_name()
    
    return '.'.join((app_module, class_name, test_name))

def reduce_indentation(whitespace):
    if os.environ['TM_SOFT_TABS'] == 'YES':
        single_tab = ' ' * int(os.environ['TM_TAB_SIZE'])
    else:
        single_tab = '\t'

    return re.match(r'^(\s*)%s(?=\S|$)' % single_tab, whitespace).group(1)


if __name__ == '__main__':
    print locals()[sys.argv[1]]()
