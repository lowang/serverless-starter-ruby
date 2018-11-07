# aws-lambda-jruby
Run ruby code on JRuby on AWS Lambda Java

based on:
https://github.com/plainprogrammer/aws-lambda-jruby

# How to use
1. Add your ruby code to lib/hello.rb
please note that you cannot use `Bundler.require`,
you have to require all gems manually like `require 'rspec'`

2. Build project
```
rake
```
3. Deploy using serverless
```
sls deploy
```
4. Run Lambda function
```
sls invoke -f hello -d JohnDoe
```
needs timeout of at least 60 sec for the first execution of the lambda
