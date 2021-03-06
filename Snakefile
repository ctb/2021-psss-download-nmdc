import csv, os.path

configfile: 'conf.yml'

# load the data.tsv file
data_tsv = config['data_tsv']
data_rows = []
with open(data_tsv, newline="") as fp:
    r = csv.DictReader(fp, delimiter='\t')
    for row in r:
        data_rows.append(row)

name = config['name']
bucket = config.get('bucket', '')
toplevel_path = config.get('toplevel_path', '')

if not toplevel_path or not bucket:
    print("Figuring out toplevel path now (e.g. 'gut')", file=sys.stderr)
    # find the row for the given name
    for row in data_rows:
        if row['MGA_ID'] == name:
            path = row['AWS_PATH']
            path = path.split('/')
            bucket = path[2]
            toplevel_path = path[3]

assert bucket
assert toplevel_path

###

FILES = config.get('files', [])
prefix = name.replace(':', '_')

# path within bucket
path_prefix = os.path.join(toplevel_path, name)

# replace {prefix} with prefix in the files list
local_files = []
for f in FILES:
    local_files.extend(expand(f, prefix=prefix))

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
