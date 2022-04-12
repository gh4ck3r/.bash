# vim:fdm=marker:
# peda {{{
define init-peda
python
import os
peda = os.path.dirname(os.path.realpath(os.environ['HOME'] + '/.bashrc')) + '/wrappers/peda/peda.py'
gdb.execute('source'+peda)
end
end
document init-peda
Initialize the PEDA (Python Exploit Development Assistant for GDB) framework
end
# }}} peda

# pwndbg {{{
define init-pwndbg
python
import os
peda = os.path.dirname(os.path.realpath(os.environ['HOME'] + '/.bashrc')) + '/wrappers/pwndbg/gdbinit.py'
gdb.execute('source'+peda)
end
end
document init-pwndbg
Initialize the PwnDBG
end
# }}} pwndbg

set breakpoint pending on
set print array on
set print array-indexes on
set print asm-demangle on
set print elements 0
set print pretty on
# following makes gdb slow down with massive argument(s)
#set print frame-arguments all
set print vtbl on
set print object on
set pagination off
set dump-excluded-mappings on

# causes the step command to stop at the first instruction of a function which
# contains no debug line information rather than stepping over it.
set step-mode on

# Pretty print for STL containers
python
sys.path.insert(0, '/usr/share/gcc/python/')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end

python
import glob
import os
for f in glob.glob(os.path.join(os.path.expanduser('~/.gdb/'), '*')):
    print(f'load {f}')
    gdb.execute(f'source {f}')
end


set history save on
set history size unlimited
set history filename .gdb_history
set history expansion
set history remove-duplicates 1
#set debug separate-debug-file
set script-extension strict
#set python print-stack full
set tui tab-width 2
set tui compact-source on

skip -gfi /usr/include/c++/*/bits/*
skip -gfi /usr/include/c++/*/ext/*
skip -gfi /usr/include/c++/*/optional
skip -gfi /usr/include/x86_64-linux-gnu/c++/*/bits/*
skip -gfi /usr/include/x86_64-linux-gnu/c++/*/ext/*
# skip every templated C++ constructor and descructor in the std namespace
skip -rfu ^std::([a-zA-z0-9_]+)<.*>::~?\1\ *\\(
