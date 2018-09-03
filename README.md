# last_fabric_version_code plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-last_fabric_version_code)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-last_fabric_version_code`, add it to your project by running:

```bash
fastlane add_plugin last_fabric_version_code
```

## About last_fabric_version_code

Get the last Fabric version code for your Android app
This is specially useful if you want to auto-increment the version code for your beta builds or something.

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

If you want to get the auto-increment version code feature in your Android app project, you can set up a new lane similar to this:
```ruby
lane :last_version do
  last_version_code = last_fabric_version_code(username: 'your@email.com', password: 'y0urPassW0rd', app_package: 'com.android.example.app')
  gradle(
      task: 'assemble',
      build_type: 'developDebug',
      properties: { 'newVersionCode' => last_version_code }
  )
  # Deploy to Fabric
end
```

And then, read the injected version code in your app's build.gradle like this:

```groovy
android {
  defaultConfig {
    versionCode project.hasProperty('newVersionCode') ? project.property('newVersionCode') as int : 1
  }
}
```

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
