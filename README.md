# dataloader.sh

dataloader.sh is a script tool based on Apache Ant, similar to Salesforce dataloader, which currently supports data Export and Upsert. The tool can run on a server and perform scheduled operations on data in Salesforce.

## Java Requirement

Developers need to use JDK 11 or later such as [Zulu OpenJDK](https://www.azul.com/downloads/zulu) before running dataloader.sh.

## Support jar package version

The current supported versions of jar packages are `46 to 50`, and you need to pay attention to the corresponding versions when configuring environment variables.

## Usage

Let's take exporting Account data as an example: 

1. create a Account.sh file under the path `bin/exports`, Modify SOQL statement
2. Run `encrypt.sh`, The main purpose is to encrypt the passwords of Salesforce users
3. Then execute `./bin/exports/Account.sh`, The exported data will be placed under the `export/` path

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.
