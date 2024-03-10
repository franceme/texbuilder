#!/usr/bin/env python3
import os, sys
from base64 import b64encode

def mini_file(file):
    quote="'"
    try:
        from python_minifier import minify
    except:
        os.system(f"{sys.executable} -m pip install python-minifier")
        from python_minifier import minify
    with open(file, "r") as f:
        mini = b64encode(minify(f.read(),rename_globals=True).encode()).decode()
    return f"import base64;exec(base64.b64decode('{mini}').decode())"

def mini_shell(cmd,prefix="/usr/bin/env python3 -c"):
    return f"{prefix} \"import base64;exec(base64.b64decode('{cmd}').decode())\""

if __name__ == '__main__':
    for arg in sys.argv:
        if 'minifier' not in arg and arg.endswith('.py'):
            mini = mini_file(arg)
            print(arg)
            #print(f"{arg} :> {mini_shell(mini)}")
            output_file = arg.replace('.py','_mini')
            if os.path.exists(output_file):
                try:
                    os.remove(output_file)
                except:
                    pass
            with open(output_file,'w+') as writer:
                writer.write("#!/usr/bin/env python3\n"+mini)
