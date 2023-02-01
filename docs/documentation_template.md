# Introduction
This is a TU template which allows the user to create starting repo for TU tracks.

## Environment Variable Set up
All the key values are included in the .env.dev.template and .env.prod.template file as per requirement. You can set them up using our platform, more details are in the enviromemnt management doc.


## Run scripts
There is a scripts folder which contains all the scripts that needs to be run depending on the state of the project. You can customize these scripts as per your requirement.

- `init.sh`: Runs at the time of workspace creation in devspace.  
- `entrypoint.sh`: Runs when the created workspace is activated in devspace.  
- `lint.sh`:Run this script to identify linting problems.
- `test.sh`: Run this script to run test coverage.
