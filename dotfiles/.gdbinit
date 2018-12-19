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
