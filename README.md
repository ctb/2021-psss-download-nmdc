# 2021-psss-download-nmdc

## quickstart

You'll need snakemake.

Edit conf.yml so that your desired set of files is indicated in the
`files` section, and the `name` is set correctly.
You may need to adjust `directory`: as well.

Then:

```
snakemake -j 1
```
