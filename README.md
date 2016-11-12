# Katanga iOS app

## Setting up the development environment
First install Ruby gems bundler:

```shell
	gem install bundler
```

Then go to project folder, and run:

```shell
	bundle install
	bundle exec pod install
```
If this doesn't work execute:

```shell
	bundle exec pod repo update
	bundle exec pod install
```
Last, open *.xcworkspace* on XCode IDE to complete the setup of the project.
