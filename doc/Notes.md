Diagnostics
===========

Add to agent install to call xslt from two http paths of the appliance to get the
transform and the rdf file.  The translation should be a bat file that generates a zip
then pushes it to the - where?

Windows
-------

 * Use NSIS installer.
 * Generate PowerShell script - perhaps PowerShell module.
 * How to sign powershell module.

Darwin
------

 * Generate pkg
   - Use fpm?
   - Use OSX tools (prefer)

```
gem install fpm
installer  -pkg redx-diagnostics-1.0.pkg -target /Volumes/Macintosh\ HD
man installer
pkgutil --pkgs
pkgutil --files redx-diagnostics-1.0.pkg 
pkgutil --files redx-diagnostics-1.0
pkgutil --files redx-diagnostics
```

Biopsy
------

Add from ( http://www.chkrootkit.org/ )

 * https://en.wikipedia.org/wiki/Chkrootkit

TODO
----
 * how to package for all distros - without library dependencies
 * redis health check
   - 'redis-cli ping' -> PONG
   - 'redis-cli set diagnostics-key $RANDOM'
   - 'redis-cli get diagnostics-key'

 * change build to generate an RPM for
   1. RHEL6/AWS/AMI
   2. RHEL7/CentOS/Appliance

 * add to inventory upstart job to create system-uuid for AWS/EC2 instances
 * create systemd config for inventory
   * need to enable in the spec file
 * where ever this is built it requires 'apt-get install equivs'
   in order to create these simple packages

 * add symlinks to /var/www/maytag/diagnostics/... to point at diag info
   used by endpoint

 * we also need to close down the console login
 * change spec file to have /var/spool/... be 01777 to allow anyone to create
   but only owner to delete
 * after we cut over to centos - move rsyslog override conf to osconfig rpm
 * change archive name to include diagnostic type

 * add inotify event diagnostics
 * add rsyslog event diags

 * Add `chkrootkit` diagnosis

IDEAS
----

 * auto update
 * windows install
 * macos install

### What about voice recog

what are the far field voice recognition solutions like Alexa uses?

Amazon bought several companies with pieces of technology to piece this
together.

DONE
----

<!-- vim: set autoindent expandtab sw=4 syntax=xslt: -->
