configfile: 'conf.yml'

#print(config.keys())

bucket = config['bucket']
FILES = config.get('files', [])
directory = config['directory']
name = config['name']
prefix = name.replace(':', '_')

path_prefix = os.path.join(directory, name)

local_files = []
for f in FILES:
    local_files.extend(expand(f, prefix=prefix))

#FILES = [ os.path.join(path_prefix, f) for f in local_files ]

rule all:
    input:
        local_files
        

rule download:
    output:
        "{filename}"
    shell: """
        aws s3api get-object --bucket psss-metagenomics-codeathon-data \
           --key {path_prefix}/{wildcards.filename} {wildcards.filename}
    """
