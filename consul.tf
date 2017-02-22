provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "us-west-2"
}

resource "aws_key_pair" "deployer" {
  key_name = "consul-demo" 
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCUCbUHA0zmNB4AycvEtOaIktFbuGXVmW1xlgMOHYXAXi789WI9TQ9pj9JX+/ZyYwLjMXZ+og0h4SkNvsliXMBU4Aq7MsE4u7skUVjjRDk0EpPWxjI0fQnj7fV2FkpPkMVDOl72UY80ZOlTvTJgwC48m4/wx4bNpQ2VlFwSK9jm95Z99Y5HJd7iqzyGh4oqMnTyxGGIXwGXzktHbKO+LL+6HnyGTb5NfE5HoompB3DK1WU5bY860FjxPIDtW5ki6mTj2XN6zx3HpcvC3kdV7f+DcCyU/qqht0h8LuVGv1ePWxYsEvn9Dn6Wn0RkvZksYMOuvgZir/gvgBb95ddZREi1"
}

module "consul" {
    source = "github.com/lvm76gh/consul/terraform/aws"
    key_name = "consul-demo"
    key_path = "/home/vagrant/consul.key"
    region = "us-west-2"
    servers = "3"
}


