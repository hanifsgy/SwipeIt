fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

## Choose your installation method:

<table width="100%" >
<tr>
<th width="33%"><a href="http://brew.sh">Homebrew</a></td>
<th width="33%">Installer Script</td>
<th width="33%">Rubygems</td>
</tr>
<tr>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS or Linux with Ruby 2.0.0 or above</td>
</tr>
<tr>
<td width="33%"><code>brew cask install fastlane</code></td>
<td width="33%"><a href="https://download.fastlane.tools">Download the zip file</a>. Then double click on the <code>install</code> script (or run it in a terminal window).</td>
<td width="33%"><code>sudo gem install fastlane -NV</code></td>
</tr>
</table>

# Available Actions
## iOS
### ios ci
```
fastlane ios ci
```
CI run lane
### ios test
```
fastlane ios test
```
Runs all the unit and UI tests
### ios codecov
```
fastlane ios codecov
```
Print the code coverage
### ios codecov_html
```
fastlane ios codecov_html
```
Show the code coverage in HTML
### ios upload_metadata
```
fastlane ios upload_metadata
```
Upload metadata
### ios fabric
```
fastlane ios fabric
```
Submit a new Beta Build to Fabric
### ios itunes
```
fastlane ios itunes
```
Submit a new Beta Build to Apple TestFlight
### ios synx
```
fastlane ios synx
```
Run Synx
### ios setup
```
fastlane ios setup
```
Setups a new environment
### ios git_precommit_hook
```
fastlane ios git_precommit_hook
```
Adds git pre-commit hook for xUnique
### ios install_certs
```
fastlane ios install_certs
```
Installs all certificates
### ios create_certs
```
fastlane ios create_certs
```
Add certificates for a specified environment through :env
### ios refresh_dsyms
```
fastlane ios refresh_dsyms
```

### ios add_device
```
fastlane ios add_device
```
Add device to Apple dev portal

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
