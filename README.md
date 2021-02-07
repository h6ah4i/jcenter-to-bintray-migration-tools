## What's this?

This repository contains some tools which help you to migrate artifacts uploaded to Bintray (JCenter) to OSSRH (Maven Central).

- Download entire repositories
- Create Artifact Bundle JAR file which can be upload via Nexus Repository Manager

ref.) [Into the Sunset on May 1st: Bintray, JCenter, GoCenter, and ChartCenter](https://jfrog.com/blog/into-the-sunset-bintray-jcenter-gocenter-and-chartcenter/)


---

NOTE: I have tested this on Ubuntu Linux only. Pull requests are welcome :sweat_smile:

## Setup

1. Prerequisites
     - `git`
     - `bash`
     - `ruby`
     - `wget`
     - `gpg`
2. Clone the repo
3. `bundle install`

## Usage

### 1. Download the entire of your Bintray repo

```bash
# Create files list (change "h6ah4i" to your Bintray user name)
./list_bintray_repo_files.sh https://dl.bintray.com/h6ah4i/maven > list.txt

# Download all files
./download_bintray_repo_files.rb list.txt
```

### 2. Setup your GPG key
See the following instruction.

- [Working with PGP Signatures](https://central.sonatype.org/pages/working-with-pgp-signatures.html)
  - Installing GnuPG
  - Generating a Key Pair
  - Listing Keys
  - Distributing Your Public Key

### 3. Create Artifact Bundle JARs

The `build_bundle_jar.sh` command performs the following processes internally.

- Create GPG signature files (`*.asc`)
- Archive artifacts to a single JAR file `bundle.jar`

```bash
# ------
# Usage: ./build_bundle_jar.sh [-y] [-v] [-k gpg_key_name] target_dir

#      -y  No prompt mode.
#      -v  Verbose
#      -k  Specify GPG key name
# ------

# NOTE: Change the GPG key name and path to yours

./build_bundle_jar.sh -y -v -k C6ABE60482B734F35D5A7214FE4A8434FDD50882 ./dl.bintray.com/h6ah4i/maven/com/h6ah4i/android/colortransitiondrawable/colortransitiondrawable/0.5.0
# => ./dl.bintray.com/h6ah4i/maven/com/h6ah4i/android/colortransitiondrawable/colortransitiondrawable/0.5.0/bundle.jar

./build_bundle_jar.sh -y -v -k C6ABE60482B734F35D5A7214FE4A8434FDD50882 ./dl.bintray.com/h6ah4i/maven/com/h6ah4i/android/colortransitiondrawable/colortransitiondrawable/0.5.1
# => ./dl.bintray.com/h6ah4i/maven/com/h6ah4i/android/colortransitiondrawable/colortransitiondrawable/0.5.1/bundle.jar

./build_bundle_jar.sh -y -v -k C6ABE60482B734F35D5A7214FE4A8434FDD50882 ./dl.bintray.com/h6ah4i/maven/com/h6ah4i/android/colortransitiondrawable/colortransitiondrawable/0.5.2
# => ./dl.bintray.com/h6ah4i/maven/com/h6ah4i/android/colortransitiondrawable/colortransitiondrawable/0.5.2/bundle.jar


...
```


### 4. Sign up to OSSRH (create JIRA and Nexus account)

https://issues.sonatype.org/secure/Signup!default.jspa

### 5. Create a new ticket on JIRA

https://issues.sonatype.org/secure/CreateIssue.jspa?issuetype=21&pid=10134

- Verify your domain with TXT record if you are using your own domain.

### 6. Upload bundle to OSSRH Staging repository

1. Open the following page
    - https://oss.sonatype.org/#staging-upload
2. Upload Artifact Bundle
  1. Select upload mode: `Artifact Bundle`
  2. Select one of a `bunldle.jar` file created in Step 3.
  3. Press the `Upload Bundle` button
3. Check the staging repository status and **Release** it if no problem found
    - https://oss.sonatype.org/#stagingRepositories

### 7. Add a comment and close the JIRA ticket

After finishing your first release, close the JIRA ticket created in Step 5.

### 8. Repeat Step 5-7

Repeat and repeat again until (all of / enough) your artifacts available on Maven Central...

(I have not automated this process yet, because I do not have so many artifacts that need to be migrated.)

## References

- [OSSRH Guide](https://central.sonatype.org/pages/ossrh-guide.html)
- [Manual Staging Bundle Creation and Deployment](https://central.sonatype.org/pages/manual-staging-bundle-creation-and-deployment.html)
- [(Japanese) GitHub＋Maven Centralで自作ライブラリを公開する](https://qiita.com/yoshikawaa/items/a7a7c1d927f6e7e75320)
- [(Japanese) GitHub で公開したソースコードを Maven Central Repository に登録する手順](https://blog.tagbangers.co.jp/2015/02/27/to-register-the-source-code-that-was-published-in-github-to-maven-central-repository)


## License

```
MIT License

Copyright (c) 2021 Haruki Hasegawa

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
