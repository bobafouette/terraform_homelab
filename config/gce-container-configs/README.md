# Metadata for Containers

Based on [konlet](https://github.com/GoogleCloudPlatform/konlet/) yml files following the struct defined by the [api](https://github.com/GoogleCloudPlatform/konlet/blob/9cb9106daf07123c2641159cb8bcc9d6f4960ec2/gce-containers-startup/types/api.go#L30) passed via a metadata field `gce-container-declaration` allow us to boot strap containers at the start of the CooS.

# Depercation
This seems less flexible and more tedious that using ansible for provisionning and has been deprecated for most use cases.
