# Just another packer example for rocky linux 8

Note: this is for vmware vsphere and using a Content library

* using the example from rocky's website, and adjusted it to work for 8.6+
* require docker to be installed to run a webserver for the duration of the execution
* require [taskfile.dev](https://taskfile.dev/installation/)


example of output when canceling a task
```
# task run
task: [start_docker_http] docker run -d -p 80:8043 -v $(pwd)/rockylinux8:/srv/http --name http pierrezemb/gostatic
ad72d2d8ef3cdfb94dea58a32b6514ad43a7872d6f38d5209a691be3a4061df8
task: [run] packer build -var-file=.vsphere.pkr.hcl rockylinux8/template.pkr.hcl
vsphere-iso.auto_template: output will be in this color.

==> vsphere-iso.auto_template: Creating VM...
==> vsphere-iso.auto_template: Customizing hardware...
==> vsphere-iso.auto_template: Mounting ISO images...
==> vsphere-iso.auto_template: Adding configuration parameters...
==> vsphere-iso.auto_template: Set boot order temporary...
==> vsphere-iso.auto_template: Power on VM...
==> vsphere-iso.auto_template: Waiting 10s for boot...
==> vsphere-iso.auto_template: Typing boot command...
==> vsphere-iso.auto_template: Waiting for IP...
task: Signal received: "interrupt"
Cancelling build after receiving interrupt
==> vsphere-iso.auto_template: Clear boot order...
==> vsphere-iso.auto_template: Power off VM...
==> vsphere-iso.auto_template: Destroying VM...
Build 'vsphere-iso.auto_template' finished after 28 minutes 57 seconds.

==> Wait completed after 28 minutes 57 seconds
Cleanly cancelled builds after being interrupted.
task: [stop_docker_http] docker stop http
http
task: [stop_docker_http] docker rm http
http
task: Failed to run task "run": exit status 1
```