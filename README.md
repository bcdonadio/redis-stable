# Redis Stable for Enterprise Linux

<a href="https://packagecloud.io/redis/redis-stable"><img alt="Hosted repo for redis-stable RPMs | packagecloud" height="46" src="https://packagecloud.io/images/packagecloud-badge.png" width="158" /></a>
<a href="https://github.com/bcdonadio/redis-stable"><img alt="Scripts for building Redis Stable for Enterprise Linux 6 and 7 | github" height="46" src="https://assets-cdn.github.com/images/modules/logos_page/GitHub-Logo.png" /></a>

This project contains a set of scripts and dockerfiles (recipes) to build, sign
and push to PackageCloud.io a distribution of Redis following the official
Redis.io stable channel, instead of lagging behing with the EPEL-provided (but
very battle-tested) version of the package.

The biggest motivation for me was the Redis Cluster feature introduced in 3.0,
but there was a lot of other changes which might also motivate you to use this
packaging of Redis.

The way the code was packaged follows the EPEL guidelines (in fact, the spec
file was forked from redis-2.8.19 from EPEL). It uses the jemalloc provided by
the system, instead of in-tree dependency, and enforces the use of both -fPIC
and RedHat hardening flags on all built artifacts.

## Versions
* redis: 3.2.8

## Supported distributions
* RedHat Enterprise Linux (RHEL) 6
* RedHat Enterprise Linux (RHEL) 7
* CentOS 6
* CentOS 7

## Building
### Dependencies
Ensure you have the following in your building machine:
* recent version of Docker
* rubygems
* rpm-sign

In Fedora, you can install these with:
```
# yum install docker rubygems rpm-sign
```

Then, if you intend to push the files to Packagecloud.io, install it with:
```
# gem install package_cloud
```

### Scripts
#### build.sh
This script creates a container for each `$VERSION` (space separated) of a
`$DIST` (single distribution supported currently) listed on the `common.sh`
script, naming it according to the `$REPO` parameter, and executes the
according dockerfile in the `recipes` folder (simple concatenation of `$DIST`,
`$VERSION` and `.dockerfile`).

The resulting artifacts are copied to the host machine on the `build` folder.

#### sign.sh
This script signs with your GPG key listed in your `~/.rpmmacros` file all rpm
packages underneath the `build` folder.

A valid `~/.rpmmacros` looks like the following:
```
%_gpg_name Bernardo Donadio (https://www.bcdonadio.com/) <bcdonadio@bcdonadio.com>
%__gpg /usr/bin/gpg2
```

Obviously, you need to have the secret-key of the identity listed in the
`%_gpg_name` directive in your gpg keyring.

Caution: gpg and gpg2 use different keyrings, and both can be installed at the
same time.

#### push.sh
This script pushes every rpm file underneath the `build` folder to
Packagecloud.io, verifying their signatures are valid in the processes. If a
package isn't signed with a valid signature, it aborts the process.

The repository used is the one listed inside the `common.sh` script, in the
`$REPO` directive.

In the first run, the `package_cloud` package will asks your user and password
for the service. Also obviously, you need to have push privileges to the
repository.
