# Database Installation Instructions

The database will be hosted through local machines, instead of relying on a cloud service. The json files in this folder will serve as the collections for the 128lab database that will be used for the application. To locally host and import these collections, the following software is needed.

## Software Requirements

- MongoDB Community Server v. 6.0.5
- MongoDB Shell v. 1.8.0
- (Optional) MongoDB Compass v. 1.63.0

## Creating the Database

For mongosh, connect to the localhost and input `use 128lab` to create the database.

To import the collections one-by-one, use the mongoimport tool to import the collections.
`mongoimport _(path of the json file)_ -d 128lab -c _(name of the json file)_`

To import a clean collection, add the `--drop` flag at the end of the command to drop the existing collection before the data is imported.

------

For MongoDB Compass, connect to the localhost and press the `create a database` button to create the 128lab database, and set the collection name of one of the collections (in this case use admins).

Once the database has been created, press the `create collection` button to create the remaining collections.

After all the collections have been created, go to each collection and press the `add data` button, choosing the `Import JSON or CSV file` dropdown option and pick the json file for said collection. Afterwards set the input file type to JSON and import.

------

Once done, the database should be properly set up.