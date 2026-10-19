# dsf-terraform-webapp

A small web application on Azure Container Apps, defined in Terraform and
built issue by issue by [dsf](https://github.com/okaneconnor/dark-software-factory),
a dark software factory: issues labelled `factory:ready` become draft pull
requests, verified with `terraform fmt`, `validate` and mock-provider
`terraform test`.

dsf never holds cloud credentials and never runs `plan` or `apply`. Applying
is a person's job, after review.
