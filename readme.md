![alibaba cloud](https://upload.wikimedia.org/wikipedia/commons/4/40/Alibaba-cloud-logo-grey-2-01.png)

# Alibaba Cloud [![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg)](https://github.com/ellerbrock/open-source-badges/) [![Gitter Chat](https://badges.gitter.im/frapsoft/frapsoft.svg)](https://gitter.im/frapsoft/frapsoft/) [![MIT Licence](https://badges.frapsoft.com/os/mit/mit.svg?v=103)](https://opensource.org/licenses/mit-license.php)


## Build Status

[![Build Status](https://travis-ci.org/ellerbrock/alicloud-playground.svg?branch=master)](https://travis-ci.org/ellerbrock/alicloud-playground)

## Work in Progress!

**Warning:** This won't yet work!

Plan was to run Rancher Server in High Availability Mode on a CoreOS Cluster with Kubernetes as sugar on the top :)
Problem i ran here into that RDS was not available in multi AZ setup in this environment and i started my work first with a 2 AZ Setup. Then i run some Benchmarking Tests between the AZ ...

**Base Architecture:**

- WAF
- CDN
- LoadBalancer (in Muli AZ)
- 1 x etcd Server per AZ (1 x AZ, total 3 for DEV)
- 1 Rancher Server per AZ (1 x AZ, total 3 for DEV)
- Autoscaling Group (3-10 x AZ in DEV)
- RDS (in Multi AZ)

For the Architecture Overview i was planing to use a new Tool with Auto Import function like [lucidchart](https://www.lucidchart.com/pages/de/aws-architektur-import) or [cloudcraft](https://cloudcraft.co/) because im too lazy for [draw.io](https://www.draw.io/).

Further my idea was to use the NIST-Framework and rewrite the setup in Terraform for Alibaba Cloud + write some Terraform Modules when then new Provider would be merged.

- [NIST Compliance on AWS](https://aws.amazon.com/de/quickstart/architecture/accelerator-nist/)
- [NIST High Impact on AWS](https://aws.amazon.com/de/quickstart/architecture/accelerator-nist-high-impact/)

So much more i could write but i have to proceed with my work, so i upload this for now ...

Cheers Maik


## Support

You can get direct support for my Open Source projects on Alibaba Cloud here

[![gitter](https://github.frapsoft.com/top/gitter-alibabacloudnews.jpg)](https://gitter.im/alibabacloudnews/Lobby)


## Try Alibaba Cloud

[Sign up](http://ow.ly/YKQe30hHgp8) today and get $300 valid for the first 60 days to try Alibaba Cloud.


## Contact

[![Github](https://github.frapsoft.com/social/github.png)](https://github.com/ellerbrock/)[![Docker](https://github.frapsoft.com/social/docker.png)](https://hub.docker.com/u/ellerbrock/)[![npm](https://github.frapsoft.com/social/npm.png)](https://www.npmjs.com/~ellerbrock)[![Twitter](https://github.frapsoft.com/social/twitter.png)](https://twitter.com/frapsoft/)[![Facebook](https://github.frapsoft.com/social/facebook.png)](https://www.facebook.com/frapsoft/)[![Google+](https://github.frapsoft.com/social/google-plus.png)](https://plus.google.com/116540931335841862774)[![Gitter](https://github.frapsoft.com/social/gitter.png)](https://gitter.im/frapsoft/frapsoft/)

## License 

[![MIT license](https://badges.frapsoft.com/os/mit/mit-125x28.png?v=103)](https://opensource.org/licenses/mit-license.php)

This work by <a xmlns:cc="http://creativecommons.org/ns#" href="https://github.com/ellerbrock" property="cc:attributionName" rel="cc:attributionURL">Maik Ellerbrock</a> is licensed under a <a rel="license" href="https://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a> and the underlying source code is licensed under the <a rel="license" href="https://opensource.org/licenses/mit-license.php">MIT license</a>.
