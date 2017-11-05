# 3degrees-api-client
Generated code from https://swaggerhub.com/api/3degreesapp/3-degrees

# Updating
To update the client to reflect another version of the API, run this:

```
cd scripts; ./update.sh _version-number_
git difftool
git add .
git commit -m "Your message here"
```

This requires `jq` to be installed, so you may need to run

```
brew install jq
```

ahead of time. The swagger-generator-cli can be re-built like this:

```
cd ~
cd swagger-codegen
git clone git@github.com:rlmartin/swagger-codegen.git
git checkout expose-http-headers2
mvn clean package
cp modules/swagger-codegen-cli/target/swagger-codegen-cli.jar /projects/3degrees-swift-client/scripts
cd ..
rm -rf swagger-codegen
```
